import 'package:flutter/material.dart';

class ShowDialogWidget extends StatefulWidget {
  final Widget Function(BuildContext context, AnimationController controller)
      builder;
  final double? webWidth;
  final double? mobileWidth;

  const ShowDialogWidget({
    super.key,
    required this.builder,
    this.webWidth = 400,
    this.mobileWidth,
  });

  @override
  State<ShowDialogWidget> createState() => _ShowDialogWidgetState();
}

class _ShowDialogWidgetState extends State<ShowDialogWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _controller.forward();

    _controller.addListener(() {
      if (_controller.isCompleted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isWeb(BuildContext context) {
    return MediaQuery.of(context).size.width > 768;
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = _isWeb(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Container(
        width: isWeb ? widget.webWidth : widget.mobileWidth,
        constraints: isWeb
            ? BoxConstraints(
                maxWidth: widget.webWidth ?? 400,
                minWidth: 300,
              )
            : null,
        child: widget.builder(context, _controller),
      ),
    );
  }
}
