import 'package:flutter/material.dart';
import 'package:grocipe/app/app_widgets/svg_render_widget.dart';
import 'package:grocipe/helper/utils/context_extension.dart';

class LoadingWidget extends StatefulWidget {
  final Duration duration;
  final String loaderMessage;

  const LoadingWidget({
    Key? key,
    required this.loaderMessage,
    this.duration = const Duration(milliseconds: 200),
  }) : super(key: key);

  @override
  LoadingWidgetState createState() => LoadingWidgetState();
}

class LoadingWidgetState extends State<LoadingWidget> {
  int _currentIndex = 0;
  List<String> svgPaths = [
    "assets/svgs/loading1.svg",
    "assets/svgs/loading2.svg",
    "assets/svgs/loading3.svg"
  ];

  @override
  void initState() {
    super.initState();
    _startSwitching();
  }

  void _startSwitching() {
    Future.delayed(widget.duration, _switchSvg);
  }

  void _switchSvg() {
    if (mounted) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % svgPaths.length;
      });
      _startSwitching();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgRenderWidget(
            svgPath: svgPaths[_currentIndex],
            width: 100,
            height: 100,
          ),
          const SizedBox(height: 10),
          Text(widget.loaderMessage, style: context.textTheme.titleMedium)
        ],
      ),
    );
  }
}
