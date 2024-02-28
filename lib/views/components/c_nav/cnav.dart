import 'package:unicorn_app/consts/consts.dart';

enum CnavStyle {
  google,
  oldSchool,
}

class CNav extends StatefulWidget {
  const CNav({
    super.key,
    required this.tabs,
    this.selectedIndex = 0,
    this.onTabChange,
    this.semanticsLabel = 'icon',
    this.padding = const EdgeInsets.all(25),
    this.activeColor,
    this.color,
    this.rippleColor = Colors.transparent,
    this.hoverColor = Colors.transparent,
    this.backgroundColor = Colors.transparent,
    this.tabBackgroundColor = Colors.transparent,
    this.tabBorderRadius = 5,
    this.iconSize,
    this.curve = Curves.easeInCubic,
    this.tabMargin = EdgeInsets.zero,
    this.duration = const Duration(milliseconds: 0),
    this.tabBackgroundGradient,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.style = CnavStyle.google,
  });

  final List<CButton> tabs;
  final int selectedIndex;
  final ValueChanged<int>? onTabChange;
  final double tabBorderRadius;
  final double? iconSize;
  final String semanticsLabel;
  final Color? activeColor;
  final Color backgroundColor;
  final Color tabBackgroundColor;
  final Color? color;
  final Color rippleColor;
  final Color hoverColor;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry tabMargin;
  final Duration duration;
  final Curve curve;
  final Gradient? tabBackgroundGradient;
  final MainAxisAlignment mainAxisAlignment;
  final CnavStyle? style;

  @override
  State<CNav> createState() => _CNavState();
}

class _CNavState extends State<CNav> {
  late int selectedIndex;
  bool clickable = true;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
  }

  @override
  void didUpdateWidget(CNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      selectedIndex = widget.selectedIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      child: Row(
        mainAxisAlignment: widget.mainAxisAlignment,
        children: widget.tabs
            .map(
              (t) => CButton(
                style: widget.style,
                key: t.key,
                borderRadius: t.borderRadius ??
                    BorderRadius.all(
                      Radius.circular(widget.tabBorderRadius),
                    ),
                margin: t.margin ?? widget.tabMargin,
                semanticsLabel: widget.semanticsLabel,
                active: selectedIndex == widget.tabs.indexOf(t),
                iconActiveColor: t.iconActiveColor ?? widget.activeColor,
                iconColor: t.iconColor ?? widget.color,
                iconSize: t.iconSize ?? widget.iconSize,
                rippleColor: t.rippleColor ?? widget.rippleColor,
                hoverColor: t.hoverColor ?? widget.hoverColor,
                padding: t.padding ?? widget.padding,
                icon: t.icon,
                curve: widget.curve,
                backgroundColor: t.backgroundColor ?? widget.tabBackgroundColor,
                duration: widget.duration,
                onPressed: () {
                  if (!clickable) return;
                  setState(() {
                    selectedIndex = widget.tabs.indexOf(t);
                    clickable = false;
                  });
                  t.onPressed?.call();
                  widget.onTabChange?.call(selectedIndex);
                  Future.delayed(
                    widget.duration,
                    () {
                      setState(
                        () {
                          clickable = true;
                        },
                      );
                    },
                  );
                },
              ),
            )
            .toList(),
      ),
    );
  }
}
