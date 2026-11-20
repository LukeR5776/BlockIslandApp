import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/animation.dart';
import 'package:flutter/painting.dart';

import '../../data/pois.dart';
import '../../models/poi.dart';
import '../../theme/onboarding_tokens.dart';
import 'island_outline.dart';
import 'onboarding_timeline.dart';

/// Screen regions for one layout pass. Everything positional in the
/// sequence is relative to these, so SE through Pro Max (and any other
/// aspect ratio) compose the same way.
class StageLayout {
  StageLayout(this.size, this.padding)
    : stage = Rect.fromLTRB(
        padding.left + 16,
        padding.top + 64,
        size.width - padding.right - 16,
        math.max(padding.top + 260, size.height - padding.bottom - _belowStage),
      );

  final Size size;
  final EdgeInsets padding;

  /// Where the island and the mini-screens live.
  final Rect stage;

  /// Copy block bottom edge, measured up from the screen bottom. Leaves room
  /// for the landfall button and nav bar so the copy never jumps between
  /// beats.
  double get copyBottom => padding.bottom + 150;

  // Copy (~150) + button and nav bar (~150).
  static const _belowStage = 300.0;
}

/// A pose of the "camera" looking at the island: zoom about the stage
/// center, then a pan in fractions of the stage size.
class CameraPose {
  final double scale;
  final double dx;
  final double dy;

  const CameraPose(this.scale, this.dx, this.dy);

  static CameraPose lerp(CameraPose a, CameraPose b, double t) => CameraPose(
    lerpDouble(a.scale, b.scale, t)!,
    lerpDouble(a.dx, b.dx, t)!,
    lerpDouble(a.dy, b.dy, t)!,
  );
}

/// The shot list. One pose per beat; the camera dollies between them over
/// [OnboardingTiming.cameraMove] at the start of each beat.
const _heroFrom = CameraPose(0.86, 0, 0.03);
const _heroTo = CameraPose(1.0, 0, 0);
const _poses = <OnboardingBeat, CameraPose>{
  // Push in until the coastline is a backdrop texture behind the cards.
  OnboardingBeat.read: CameraPose(2.15, 0.16, 0.44),
  // Pull all the way back out: the map.
  OnboardingBeat.explore: CameraPose(0.98, 0, -0.02),
  // Back off to fit the compass rose.
  OnboardingBeat.care: CameraPose(0.74, 0, -0.04),
  // Settle high, leaving room for the title, button and nav bar.
  OnboardingBeat.landfall: CameraPose(0.66, 0, -0.04),
};

CameraPose cameraAt(double t) {
  var pose = CameraPose.lerp(
    _heroFrom,
    _heroTo,
    seg(t, 0, beatEnd(OnboardingBeat.hero), Curves.easeOutCubic),
  );
  for (final beat in OnboardingBeat.values.skip(1)) {
    final start = beatStart(beat);
    if (t <= start) break;
    pose = CameraPose.lerp(
      pose,
      _poses[beat]!,
      seg(
        t,
        start,
        start + OnboardingTiming.cameraMove,
        OnboardingCurves.camera,
      ),
    );
  }
  // A slow 3% creep while each beat holds, so the frame is never dead still.
  final beat = beatAt(t);
  final creep =
      0.03 *
      seg(
        t,
        beatStart(beat) + OnboardingTiming.cameraMove,
        beatEnd(beat),
        Curves.easeOut,
      );
  return CameraPose(pose.scale * (1 + creep), pose.dx, pose.dy);
}

/// The island projected into the stage at camera scale 1. Built once per
/// layout size and shared by every painter, so paths and samples are never
/// recomputed per frame.
class IslandGeometry {
  IslandGeometry(this.layout) {
    final stage = layout.stage;
    // Equirectangular with a cos(lat) squeeze — at this scale it is
    // indistinguishable from Web Mercator and keeps the math obvious.
    final lat0 = 41.19 * math.pi / 180;
    final kx = math.cos(lat0);
    Offset raw(double lat, double lng) => Offset(lng * kx, -lat);

    final rawOutline = [for (final (lat, lng) in kIslandOutline) raw(lat, lng)];
    var minX = double.infinity, minY = double.infinity;
    var maxX = -double.infinity, maxY = -double.infinity;
    for (final p in rawOutline) {
      minX = math.min(minX, p.dx);
      maxX = math.max(maxX, p.dx);
      minY = math.min(minY, p.dy);
      maxY = math.max(maxY, p.dy);
    }
    final fit = math.min(
      stage.width * 0.78 / (maxX - minX),
      stage.height * 0.9 / (maxY - minY),
    );
    final rawCenter = Offset((minX + maxX) / 2, (minY + maxY) / 2);
    Offset place(Offset p) => stage.center + (p - rawCenter) * fit;

    final points = [for (final p in rawOutline) place(p)];
    path = Path()..addPolygon(points, true);
    // One contour, so this metric stays valid for the geometry's lifetime.
    metric = path.computeMetrics().first;
    coastLength = metric.length;
    islandHeight = (maxY - minY) * fit;

    // Particle landing spots, spaced evenly along the shore in path order so
    // the convergence reads as the coast being drawn.
    const n = OnboardingParticles.max;
    coastSamples = Float32List(n * 2);
    for (var i = 0; i < n; i++) {
      final tangent = metric.getTangentForOffset(coastLength * i / n)!;
      coastSamples[i * 2] = tangent.position.dx;
      coastSamples[i * 2 + 1] = tangent.position.dy;
    }

    pois = kPois;
    poiPoints = [for (final poi in pois) place(raw(poi.lat, poi.lng))];

    // Markers cascade north → south, so the drop reads top-down.
    dropOrder = List.generate(pois.length, (i) => i)
      ..sort((a, b) => pois[b].lat.compareTo(pois[a].lat));
    dropRank = List.filled(pois.length, 0);
    for (var r = 0; r < dropOrder.length; r++) {
      dropRank[dropOrder[r]] = r;
    }

    // The dashed course visits every place once, sweeping around the
    // island's center — a plotted loop, not a claim about any real route.
    final c = stage.center;
    courseOrder = List.generate(pois.length, (i) => i)
      ..sort((a, b) {
        final pa = poiPoints[a] - c, pb = poiPoints[b] - c;
        return math.atan2(pa.dy, pa.dx).compareTo(math.atan2(pb.dy, pb.dx));
      });

    selected = _indexOf('mohegan-bluffs');
    lighthouse = _indexOf('southeast-light');
  }

  final StageLayout layout;

  late final Path path;
  late final PathMetric metric;
  late final double coastLength;
  late final double islandHeight;
  late final Float32List coastSamples;
  late final List<Poi> pois;
  late final List<Offset> poiPoints;
  late final List<int> dropOrder;
  late final List<int> dropRank;
  late final List<int> courseOrder;

  /// The POI the explore beat opens a card for.
  late final int selected;

  /// Where the hero's lighthouse beam sweeps from.
  late final int lighthouse;

  Offset get center => layout.stage.center;

  int _indexOf(String id) {
    final i = pois.indexWhere((p) => p.id == id);
    return i < 0 ? 0 : i;
  }

  /// Base (camera scale 1) → screen.
  Offset project(Offset base, CameraPose pose, Offset parallax) {
    final stage = layout.stage;
    return center +
        Offset(pose.dx * stage.width, pose.dy * stage.height) +
        parallax +
        (base - center) * pose.scale;
  }

  /// The same transform as [project], for painting base-space paths.
  Float64List matrix(CameraPose pose, Offset parallax) {
    final stage = layout.stage;
    final tx = center.dx + pose.dx * stage.width + parallax.dx;
    final ty = center.dy + pose.dy * stage.height + parallax.dy;
    final s = pose.scale;
    return Float64List.fromList([
      s, 0, 0, 0, //
      0, s, 0, 0, //
      0, 0, 1, 0, //
      tx - center.dx * s, ty - center.dy * s, 0, 1,
    ]);
  }
}
