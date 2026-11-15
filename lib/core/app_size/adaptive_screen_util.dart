import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Phone-first design size used across the app.
const Size kDesignSize = Size(360, 690);

/// The largest factor by which the phone design is enlarged.
///
/// Phones render exactly as before. Tablets and large windows stop zooming the
/// whole UI (text, paddings, radii and icons) past this factor, which keeps
/// multi-column layouts readable instead of overflowing.
const double kMaxDesignScale = 1.25;

/// Returns the design size to hand to [ScreenUtilInit] for [logicalSize].
///
/// Instead of always using [kDesignSize] (which makes a 1024px wide tablet
/// scale a 360px design by 2.8×), the design grows with the screen so that the
/// resulting scale never exceeds [maxScale].
Size adaptiveDesignSize(
  Size logicalSize, {
  Size design = kDesignSize,
  double maxScale = kMaxDesignScale,
}) {
  return Size(
    logicalSize.width / maxScale > design.width
        ? logicalSize.width / maxScale
        : design.width,
    logicalSize.height / maxScale > design.height
        ? logicalSize.height / maxScale
        : design.height,
  );
}

/// [ScreenUtilInit] with a design size that adapts to the current view.
///
/// It recomputes the design size when the window changes (rotation, split
/// screen, desktop resize) so the scale stays capped.
class AdaptiveScreenUtilInit extends StatefulWidget {
  const AdaptiveScreenUtilInit({
    super.key,
    required this.builder,
    this.child,
  });

  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  @override
  State<AdaptiveScreenUtilInit> createState() => _AdaptiveScreenUtilInitState();
}

class _AdaptiveScreenUtilInitState extends State<AdaptiveScreenUtilInit>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    if (mounted) setState(() {});
  }

  Size _logicalSize(BuildContext context) {
    final view = View.of(context);
    return view.physicalSize / view.devicePixelRatio;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: adaptiveDesignSize(_logicalSize(context)),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: widget.builder,
      child: widget.child,
    );
  }
}
