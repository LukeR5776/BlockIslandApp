import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

/// Serves a bundled `.pmtiles` archive to [PmTilesVectorTileProvider], which
/// reads archives only over HTTP range requests.
///
/// The provider issues `client.get(url, headers: {'range': 'bytes=a-b'})` and
/// accepts a 206, so an [http.Client] that answers from the asset bundle
/// satisfies it without a socket. That matters more than the indirection
/// costs: no loopback server, no copy into the documents directory, and
/// nothing that a disabled radio can interrupt.
///
/// The archive is held in memory — 1.8 MB for Block Island. If a future
/// archive is large enough that this stops being free, swap [_bytes] for a
/// `RandomAccessFile` over a copy in the documents directory; the range
/// arithmetic below is the same either way.
class PmTilesAssetClient extends http.BaseClient {
  PmTilesAssetClient(this.assetPath);

  /// Any absolute URL works — nothing dials it. This one is self-describing
  /// in logs, and the provider derives its cache key from it.
  static const archiveUrl = 'http://pmtiles.asset/blockisland.pmtiles';

  final String assetPath;

  Future<Uint8List>? _pending;

  Future<Uint8List> get _bytes =>
      _pending ??= rootBundle.load(assetPath).then((d) => d.buffer.asUint8List(
            d.offsetInBytes,
            d.lengthInBytes,
          ));

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final archive = await _bytes;
    final range = _parseRange(request.headers['range']);

    if (range == null) {
      return _respond(200, archive, request);
    }

    final start = range.$1;
    if (start >= archive.length) {
      return _respond(416, Uint8List(0), request);
    }
    // A range past the end is satisfied by what exists, per RFC 7233 — the
    // provider asks for 16 KiB of header on an archive smaller than that.
    final end = range.$2 == null || range.$2! >= archive.length
        ? archive.length - 1
        : range.$2!;

    final slice = Uint8List.sublistView(archive, start, end + 1);
    return _respond(206, slice, request, contentRange: {
      'content-range': 'bytes $start-$end/${archive.length}',
    });
  }

  http.StreamedResponse _respond(
    int status,
    Uint8List body,
    http.BaseRequest request, {
    Map<String, String> contentRange = const {},
  }) =>
      http.StreamedResponse(
        Stream.value(body),
        status,
        contentLength: body.length,
        request: request,
        headers: {
          'content-type': 'application/octet-stream',
          'accept-ranges': 'bytes',
          ...contentRange,
        },
      );

  /// Returns (start, endInclusive) for `bytes=a-b` and `bytes=a-`.
  /// Suffix ranges (`bytes=-n`) are not produced by the provider.
  (int, int?)? _parseRange(String? header) {
    if (header == null) return null;
    final match = RegExp(r'^bytes=(\d+)-(\d*)$').firstMatch(header.trim());
    if (match == null) return null;
    final end = match.group(2)!;
    return (int.parse(match.group(1)!), end.isEmpty ? null : int.parse(end));
  }
}
