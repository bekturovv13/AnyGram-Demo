import 'package:unicorn_app/consts/consts.dart';

class CButton extends StatefulWidget {
  final bool? active;
  final Color? iconColor;
  final Color? rippleColor;
  final Color? hoverColor;
  final Color? iconActiveColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? iconSize;
  final Function? onPressed;
  final String icon;
  final String semanticsLabel;
  final String? iconLink;
  final Color? backgroundColor;
  final Duration? duration;
  final Curve? curve;
  final BorderRadius? borderRadius;
  final CnavStyle? style;

  const CButton({
    super.key,
    this.active,
    this.backgroundColor,
    required this.icon,
    required this.semanticsLabel,
    this.iconLink,
    this.iconColor,
    this.rippleColor,
    this.hoverColor,
    this.iconActiveColor,
    this.padding,
    this.margin,
    this.duration,
    this.curve,
    this.iconSize,
    this.onPressed,
    this.borderRadius,
    this.style = CnavStyle.google,
  });

  @override
  State<CButton> createState() => _CButtonState();
}

class _CButtonState extends State<CButton> {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      child: RepaintBoundary(
        child: Button(
          style: widget.style,
          borderRadius: widget.borderRadius,
          duration: widget.duration,
          iconSize: widget.iconSize,
          active: widget.active,
          semanticsLabel: widget.semanticsLabel,
          onPressed: () {
            HapticFeedback.selectionClick();
            widget.onPressed?.call();
          },
          padding: widget.padding,
          margin: widget.margin,
          color: widget.backgroundColor,
          rippleColor: widget.rippleColor,
          hoverColor: widget.hoverColor,
          curve: widget.curve,
          iconActiveColor: widget.iconActiveColor,
          iconColor: const Color(0x8033363F),
          icon: widget.icon,
        ),
      ),
    );
  }
}
