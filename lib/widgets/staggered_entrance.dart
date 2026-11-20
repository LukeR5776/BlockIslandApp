import 'package:flutter/material.dart';

/// Fades and lifts its child into place, delayed by [index] so lists cascade
/// in. Skipped entirely under reduce motion.
class StaggeredEntrance extends StatefulWidget {
  final int index;
  final Widget child;

  const StaggeredEntrance({super.key, required this.index, required this.child});

  static const _step = Duration(milliseconds: 70);
  static const _length = Duration(milliseconds: 520);

  @override
  State<StaggeredEntrance> createState() => _StaggeredEntranceState();
}

class _StaggeredEntranceState extends State<StaggeredEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: StaggeredEntrance._length,
  );
  late final Animation<double> _curve = CurvedAnimation(
    parent: _controller,
    curve: const Cubic(0.05, 0.7, 0.1, 1.0),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller.isAnimating || _controller.isCompleted) return;
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
    } else {
      Future.delayed(StaggeredEntrance._step * widget.index, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _curve,
      child: SlideTransition(
        position: Tween(begin: const Offset(0, 0.18), end: Offset.zero)
            .animate(_curve),
        child: widget.child,
      ),
    );
  }
}
