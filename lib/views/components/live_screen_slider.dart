import 'package:flutter/physics.dart';

import 'package:unicorn_app/consts/consts.dart';

typedef WidgetFunction<T> = Widget Function(T value);

class CardSlider extends StatefulWidget {
  final List<Widget> cards;

  const CardSlider({
    super.key,
    required this.cards,
    this.slideChanged,
  });

  @override
  State<CardSlider> createState() => _CardSliderState();
  final ValueChanged<int>? slideChanged;
}

class _CardSliderState extends State<CardSlider>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double alignmentCenterY = Alignment.center.y;

  late Alignment _dragAlignment;
  late Alignment _dragAlignmentBack;
  double _dragAlignmentCenter = 0;

  late Animation<Alignment> _dragAlignmentAnim;
  late Animation<double> _dragAlignmentCenterAnim;
  late Animation<double> _containerSizeWidthAnim;
  late Animation<double> _containerSizeHeightAnim;

  var liveController = Get.find<LiveController>();

  double _containerSizeWidth = 0;
  double _containerSizeHeight = 0;

  int _animationPhase = 0;
  bool animationPhase3 = false;

  List<int> valuesDataIndex = [];

  bool directionX = false;
  bool directionY = false;
  bool directionNegative = false;

  late double _cardWidth;
  late double _cardWidthOffset;
  late double _cardHeight;
  late double _cardHeightOffset;

  late double _bottomOffset;
  static const double _slideRightOffset = -18.0;
  static const double _slideLeftOffset = 5.55;
  static const double _slideTopOffset = -1.6;
  static const double _slideBottomOffset = 1.9;

  double swipe = 0;

  List<Map<String, dynamic>> userPhotos = [
    {
      'photo':
          'https://i.pinimg.com/736x/29/a6/6f/29a66f5057f4a4b9d95365e24cbfdc4f.jpg',
      'visible': false
    },
    {
      'photo':
          'https://i.pinimg.com/564x/31/65/43/31654306b86aa66cd6bbae81dc46e1a6.jpg',
      'visible': true
    },
    {
      'photo':
          'https://i.pinimg.com/564x/51/8b/7d/518b7d7bd69d031ebf050d51e67435b5.jpg',
      'visible': true
    },
  ];

  void _cardToBackAnimation(Offset pixelsPerSecond, Size size) {
    directionY = false;
    directionX = false;

    _dragAlignmentAnim = _controller.drive(
      AlignmentTween(begin: _dragAlignment, end: Alignment.topCenter),
    );
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 60,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  }

  Alignment getTheAlignment(bool directionNegative,
      [bool withOutDirection = false]) {
    Alignment dragAlignmentSelect = _dragAlignment;

    return Alignment(
        Alignment.center.x +
            (directionX || withOutDirection
                ? (dragAlignmentSelect.x == 0 ||
                        dragAlignmentSelect.x.abs() < 0.1
                    ? 0
                    : (dragAlignmentSelect.x > 0
                        ? _slideLeftOffset
                        : _slideRightOffset))
                : 0),
        alignmentCenterY +
            (directionY || withOutDirection
                ? (dragAlignmentSelect.y + 1 == 0 ||
                        (dragAlignmentSelect.y + 1).abs() < 0.1
                    ? 0
                    : (dragAlignmentSelect.y + 1 > 0
                        ? _slideBottomOffset
                        : _slideTopOffset))
                : 0));
  }

  void _cardToStartAnimation(Offset pixelsPerSecond, Size size) {
    _dragAlignmentAnim = _controller.drive(
      AlignmentTween(
          begin: _dragAlignment, end: getTheAlignment(directionNegative)),
    );

    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 60,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller
        .animateWith(simulation)
        .then((value) => {_cardToFinishAnimation(pixelsPerSecond, size)});
  }

  void _setInitialValues() {
    _containerSizeWidth = 0;
    _containerSizeHeight = 0;
    _dragAlignmentCenter = 0;

    directionY = false;
    directionX = false;

    if (widget.slideChanged != null) {
      widget.slideChanged!(valuesDataIndex[0]);
    }
  }

  void _cardToFinishAnimation(Offset pixelsPerSecond, Size size) {
    _animationPhase = 3;
    animationPhase3 = true;

    if (!directionNegative) {
      int i = valuesDataIndex[0];
      valuesDataIndex.removeAt(0);
      valuesDataIndex.add(i);

      _dragAlignment = Alignment.topCenter;
    }
    _setInitialValues();

    _dragAlignmentCenterAnim =
        _controller.drive(Tween<double>(begin: 0, end: -1 * _bottomOffset));

    _containerSizeWidthAnim =
        _controller.drive(Tween<double>(begin: 0, end: _cardWidthOffset));

    _containerSizeHeightAnim =
        _controller.drive(Tween<double>(begin: 0, end: _cardHeightOffset));

    _dragAlignmentAnim = _controller.drive(
      AlignmentTween(
          begin: getTheAlignment(!directionNegative, true),
          end: Alignment(Alignment.center.x, alignmentCenterY)),
    );
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 60,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation).then((value) => {
          _animationPhase = 0,
        });
  }

  @override
  void initState() {
    super.initState();

    alignmentCenterY += -1;

    _dragAlignment = Alignment(Alignment.center.x, alignmentCenterY);

    for (int i = 0; i < widget.cards.length; i++) {
      valuesDataIndex.add(i);
    }

    _controller = AnimationController(vsync: this);

    _controller.addListener(() {
      setState(() {
        if (_animationPhase == 0 || _animationPhase == 1) {
          _dragAlignment = _dragAlignmentAnim.value;
        }
        if (_animationPhase == 3) {
          _dragAlignment = _dragAlignmentAnim.value;

          _dragAlignmentCenter = _dragAlignmentCenterAnim.value;
          _containerSizeWidth = _containerSizeWidthAnim.value;
          _containerSizeHeight = _containerSizeHeightAnim.value;
        }
      });
    });
    _setInitialValues();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  late Size _size;

  bool runOnlyOnce = false;

  @override
  Widget build(BuildContext context) {
    if (!runOnlyOnce) {
      _size = MediaQuery.of(context).size;
      _cardWidth = _size.width * .9;
      _cardHeight = 460.h;
      _cardWidthOffset = _size.width * .05;
      _cardHeightOffset = _size.height * .01;
      _bottomOffset = 0.7;
      _dragAlignmentBack = Alignment(Alignment.center.x,
          alignmentCenterY + getAlignment(valuesDataIndex.length - 1));
      runOnlyOnce = true;
    }

    return Stack(
      children: _sliderBody(),
    );
  }

  List<Widget> _sliderBody() {
    return [
      animatedBackCards(),
      GestureDetector(
          onPanDown: (details) {
            if (_animationPhase == 0) _controller.stop();
          },
          onPanUpdate: (details) {
            if (_animationPhase == 0) {
              if (!directionX && !directionY) {
                if (details.delta.dx != 0.0 && details.delta.dy != 0.0) {
                  if (((details.delta.dx).abs() - (details.delta.dy).abs())
                          .abs() >
                      0.2) {
                    if ((details.delta.dx).abs() > (details.delta.dy).abs()) {
                      directionX = true;
                      directionNegative = details.delta.dx > 0;
                    } else {
                      directionY = true;
                      directionNegative = details.delta.dy > 0;
                    }
                  }
                }
              }
              if (directionX || directionY) {
                setState(() {
                  if (directionNegative) {
                    _dragAlignment += Alignment(
                      directionX ? details.delta.dx / (_size.width * 10) : 0,
                      directionY ? details.delta.dy / (_size.height * 10) : 0,
                    );
                  } else {
                    _dragAlignment += Alignment(
                      _dragAlignment.x > -5.0
                          ? directionX
                              ? details.delta.dx / (_size.width / 5)
                              : 0
                          : 0,
                      directionY ? details.delta.dy / (_size.height * 10) : 0,
                    );
                  }
                });
              }
            }
          },
          onPanEnd: (details) {
            if (_animationPhase == 0) {
              if (directionY ? _dragAlignment.y < -1 : false) {
                liveController.openDetailScreen();
              }
              if (directionY ? _dragAlignment.y > -1 : false) {}
              if (directionX ? _dragAlignment.x < -0.3 : false) {
                _animationPhase = 1;
                _cardToStartAnimation(details.velocity.pixelsPerSecond, _size);
              } else {
                _cardToBackAnimation(details.velocity.pixelsPerSecond, _size);
              }
            }
          },
          child: Obx(
            () => Container(
              color: liveController.deskcriptionScreen.value
                  ? null
                  : Colors.transparent,
              width: _size.width,
              height: _size.height,
            ),
          )),
    ];
  }

  double getAlignment(int i) {
    double bottomOffset = 0;
    if (i > 1) {
      bottomOffset += _bottomOffset * 2;
    } else if (i > 0) {
      bottomOffset += _bottomOffset;
    }

    return bottomOffset;
  }

  double getWidth(int i) {
    double width = _cardWidth;

    if (i > 1) {
      width -= _cardWidthOffset * 2;
    } else if (i > 0) {
      width -= _cardWidthOffset;
    }

    return width;
  }

  double getHeight(int i) {
    double height = _cardHeight;

    if (i > 1) {
      height -= _cardHeightOffset * 2;
    } else if (i > 0) {
      height -= _cardHeightOffset;
    }

    return height;
  }

  Widget animatedBackCards() {
    return Stack(
      children: [
        for (int i = (widget.cards.length - 1); i >= 0; i--)
          Align(
            alignment: (i == 0 || i == widget.cards.length - 1)
                ? (i == 0
                    ? Alignment(
                        _dragAlignment.x < 1.5 ? _dragAlignment.x : 1.5,
                        _dragAlignment.y < -0.7
                            ? _dragAlignment.y > -1.70
                                ? _dragAlignment.y +
                                    _dragAlignmentCenter +
                                    (animationPhase3 ? _bottomOffset : 0)
                                : -1.70
                            : -0.7)
                    : _dragAlignmentBack)
                : Alignment(
                    Alignment.center.x,
                    alignmentCenterY +
                        getAlignment(i) +
                        _dragAlignmentCenter +
                        (animationPhase3 ? _bottomOffset : 0)),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    (i == 0 || i == widget.cards.length - 1)
                        ? (i == 0)
                            ? BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 10,
                              )
                            : BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5,
                              )
                        : (i == 1)
                            ? BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 10,
                              )
                            : const BoxShadow(color: Colors.transparent)
                  ]),
              width: getWidth(i) +
                  _containerSizeWidth +
                  (animationPhase3 ? -1 * _cardWidthOffset : 0),
              height: getHeight(i) +
                  _containerSizeHeight +
                  (animationPhase3 ? -1 * _cardHeightOffset : 0),
              child: SizedBox.expand(
                  child: (i == 0)
                      ? Obx(() => Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Stack(
                              children: [
                                AnimatedPositioned(
                                  duration: const Duration(milliseconds: 800),
                                  curve: Curves.easeInOutCubic,
                                  width: 330.w,
                                  height: 280.h,
                                  top: liveController.deskcriptionScreen.value
                                      ? 180.h
                                      : 0,
                                  child: SizedBox(
                                    width: 330.w,
                                    height: 280.h,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10.h),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 30.w),
                                          child: Text(
                                            liveController.receiverName.value,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 30.w),
                                          child: Text(
                                            '${liveController.receiverAge.value}, ${liveController.receiverCity.value}',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 30.w),
                                          width: 330.w,
                                          height: 85.h,
                                          child: Text(
                                            'Жизнь – это волшебство моментов, украшенных красками любви. В каждом дне – капля счастья, в каждом сердце – мелодия любви...',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 5,
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontStyle: FontStyle.italic,
                                              fontSize: 14.sp,
                                              height: 1.3,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        Container(
                                          width: 300.w,
                                          height: 80.w,
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 30.w,
                                          ),
                                          child: Gallery(
                                            items: userPhotos,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 800),
                                  curve: Curves.easeInOutCubic,
                                  width: 330.w,
                                  height:
                                      liveController.deskcriptionScreen.value
                                          ? 180.h
                                          : 460.h,
                                  child: Stack(
                                    children: [
                                      GestureDetector(
                                        onPanUpdate: (details) {
                                          setState(() {
                                            swipe -= (details.delta.dy / 10);
                                          });
                                        },
                                        onPanEnd: (details) {
                                          if (swipe > 2) {
                                            setState(() {
                                              swipe = 0;
                                            });
                                            liveController
                                                .viewMainPhoto(context);
                                          } else {
                                            setState(() {
                                              swipe = 0;
                                            });
                                          }
                                        },
                                        onTap: () => liveController
                                            .viewMainPhoto(context),
                                        child: widget.cards[valuesDataIndex[i]],
                                      ),
                                      AnimatedPositioned(
                                        curve: Curves.easeInOutCubic,
                                        duration: liveController
                                                .deskcriptionButtons.value
                                            ? const Duration(milliseconds: 1000)
                                            : const Duration(milliseconds: 300),
                                        left: liveController
                                                .deskcriptionButtons.value
                                            ? 0
                                            : -60.h,
                                        child: GestureDetector(
                                          onTap: () {
                                            liveController.closeDetailScreen();
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(13.h),
                                            width: 40.w,
                                            height: 40.w,
                                            child: SvgPicture.asset(
                                              'assets/icons/i_back_white_background.svg',
                                            ),
                                          ),
                                        ),
                                      ),
                                      AnimatedPositioned(
                                        curve: Curves.easeInOutCubic,
                                        duration: liveController
                                                .deskcriptionButtons.value
                                            ? const Duration(milliseconds: 1000)
                                            : const Duration(milliseconds: 300),
                                        right: liveController
                                                .deskcriptionButtons.value
                                            ? 0
                                            : -60.h,
                                        bottom: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            // liveController.getChatId();
                                            // liveController.chatScreen();
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(13.h),
                                            width: 40.w,
                                            height: 40.w,
                                            child: SvgPicture.asset(
                                              'assets/icons/i_message_white_background.svg',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IgnorePointer(
                                  ignoring: true,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 5.h,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ))
                      : widget.cards[valuesDataIndex[i]]),
            ),
          )
      ],
    );
  }
}

class Gallery extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  const Gallery({super.key, required this.items});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  var liveController = Get.find<LiveController>();
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredItems = widget.items;

    filteredItems.sort((a, b) {
      if (a['visible'] == true && b['visible'] == false) {
        return -1;
      } else if (a['visible'] == false && b['visible'] == true) {
        return 1;
      } else {
        return 0;
      }
    });

    return RepaintBoundary(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          widget.items.length,
          (index) => GestureDetector(
            onTap: () {
              if (widget.items[index]['visible']) {
                liveController.current.value = index;
                Navigator.of(context).push(
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 700),
                    reverseTransitionDuration:
                        const Duration(milliseconds: 700),
                    pageBuilder: (context, animation, secondaryAnimation) {
                      final curvedAnimation = CurvedAnimation(
                        parent: animation,
                        curve: const Interval(0, 0.5),
                      );
                      return FadeTransition(
                        opacity: curvedAnimation,
                        child: GalleryScreen(
                          items: widget.items,
                          index: index,
                        ),
                      );
                    },
                  ),
                );
              }
            },
            child: Hero(
              tag: widget.items[index]['photo'],
              child: Container(
                width: 80.w,
                height: 80.w,
                margin: (index + 1) < widget.items.length
                    ? EdgeInsets.only(right: 10.w)
                    : EdgeInsets.zero,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: widget.items[index]['visible']
                    ? Image.network(
                        filteredItems[index]['photo'],
                        fit: BoxFit.cover,
                      )
                    : SvgPicture.asset(
                        'assets/icons/lock.svg',
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
