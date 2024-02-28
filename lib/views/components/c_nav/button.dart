import 'package:unicorn_app/consts/consts.dart';

class Button extends StatefulWidget {
  const Button({
    super.key,
    required this.semanticsLabel,
    this.icon,
    this.iconLink = '',
    this.iconSize,
    this.iconActiveColor,
    this.iconColor,
    this.color,
    this.rippleColor,
    this.hoverColor,
    required this.onPressed,
    this.duration,
    this.curve,
    this.padding,
    this.margin,
    required this.active,
    this.gradient,
    this.borderRadius,
    this.style = CnavStyle.google,
  });

  final String? semanticsLabel;
  final String? icon;
  final String iconLink;
  final double? iconSize;
  final Color? iconActiveColor;
  final Color? iconColor;
  final Color? color;
  final Color? rippleColor;
  final Color? hoverColor;
  final bool? active;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Duration? duration;
  final Curve? curve;
  final Gradient? gradient;
  final BorderRadius? borderRadius;
  final CnavStyle? style;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> with TickerProviderStateMixin {
  late bool _expanded;
  late final AnimationController expandController;

  @override
  void initState() {
    super.initState();
    _expanded = widget.active!;

    expandController =
        AnimationController(vsync: this, duration: widget.duration)
          ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    expandController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var colorTween =
        ColorTween(begin: widget.iconColor, end: widget.iconActiveColor);
    var colorTweenAnimation = colorTween.animate(CurvedAnimation(
        parent: expandController,
        curve: _expanded ? Curves.easeInExpo : Curves.easeOutCirc));

    var authController = Get.find<AuthController>();

    _expanded = !widget.active!;
    if (_expanded) {
      expandController.reverse();
    } else {
      expandController.forward();
    }

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        highlightColor: widget.hoverColor,
        splashColor: widget.rippleColor,
        borderRadius: widget.borderRadius,
        onTap: widget.onPressed,
        child: Container(
          padding: widget.margin,
          child: AnimatedContainer(
            curve: Curves.easeOut,
            padding: widget.padding,
            duration: widget.duration!,
            decoration: BoxDecoration(
              gradient: widget.gradient,
              color: _expanded
                  ? widget.color!.withOpacity(0)
                  : widget.gradient != null
                      ? Colors.white
                      : widget.color,
              borderRadius: widget.borderRadius,
            ),
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Builder(
                builder: (_) {
                  if (widget.style == CnavStyle.google) {
                    return Align(
                      alignment: Alignment.center,
                      child: widget.icon! != ''
                          ? SvgPicture.asset(
                              widget.icon!,
                              colorFilter: ColorFilter.mode(
                                  colorTweenAnimation.value!, BlendMode.srcIn),
                              semanticsLabel: widget.semanticsLabel,
                              width: widget.iconSize,
                              height: widget.iconSize,
                            )
                          : Container(
                              width: 24.w,
                              height: 24.w,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.r)),
                              child: Obx(
                                () => CachedNetworkImage(
                                  imageUrl: authController
                                      .userData.value.userPhoto.value,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF202020),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              )),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
