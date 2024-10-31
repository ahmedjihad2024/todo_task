import 'package:flutter/material.dart';

class CustomShimmer extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final List<Color> shimmerColors;
  final Widget? child;
  final Duration duration;
  final List<double> stops;
  final BlendMode blendMode;

  const CustomShimmer({
    super.key,
    required this.width,
    required this.height,
    required this.borderRadius,
    this.shimmerColors = const [
      Color.fromARGB(255, 224, 224, 224),
      Color.fromARGB(255, 245, 245, 245),
      Color.fromARGB(255, 224, 224, 224),
    ],
    this.child,
    this.duration = const Duration(seconds: 2),
    this.stops = const [0.1, 0.3, 0.4, 0.5, 0.7, 0.9],
    this.blendMode = BlendMode.srcATop,
  });

  @override
  State<StatefulWidget> createState() => _CustomShimmerState();

}

class _CustomShimmerState extends State<CustomShimmer>
    with SingleTickerProviderStateMixin {
  static AnimationController? _controller;
  static int _activeInstances = 0;

  @override
  void initState() {
    super.initState();

    _activeInstances++;
    _controller ??= AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();

  }

  @override
  void dispose() {
    _activeInstances--;
    if (_activeInstances == 0) {
      _controller!.stop();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller!,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: widget.shimmerColors,
              stops: widget.stops,
              begin: Alignment(-1.0 - 4.0 * _controller!.value, -0.3),
              end: Alignment(1.0 + 4.0 * _controller!.value, 0.3),
            ).createShader(bounds);
          },
          blendMode: widget.blendMode,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: widget.borderRadius,
            ),
            child: widget.child,
          ),
        );
      },
    );
  }
}
