import 'dart:ui';

import 'package:unicorn_app/consts/consts.dart';
import 'package:intl/intl.dart' as intl;

// Верхний нивигационный панель
class AppBarCustom extends StatelessWidget {
  final bool leftIconVisible;
  final bool rightIconVisible;
  final Function(BuildContext)? pushLeft;
  final Function(BuildContext)? pushRight;
  final Widget? lelfIcon;
  final Widget? rightIcon;
  final double? leftIconSize;
  final double? rightIconSizeW;
  final double? rightIconSizeH;
  final bool titleVisible;
  final Widget? titleWidget;
  final String titleText;
  final Color? tColor;
  final double? tSize;

  const AppBarCustom({
    super.key,
    this.leftIconVisible = true,
    this.rightIconVisible = true,
    this.pushLeft,
    this.pushRight,
    this.lelfIcon,
    this.rightIcon,
    this.leftIconSize,
    this.rightIconSizeW,
    this.rightIconSizeH,
    this.titleVisible = false,
    this.titleWidget,
    this.titleText = 'TITLE',
    this.tColor,
    this.tSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 30.h),
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Visibility(
            visible: titleVisible,
            child: titleWidget ??
                Text(
                  titleText,
                  style: TextStyle(
                    color: tColor ?? const Color(0xFF33363F),
                    fontSize: tSize ?? 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Visibility(
                visible: leftIconVisible,
                child: GestureDetector(
                  onTap: () {
                    if (leftIconVisible && pushLeft != null) {
                      pushLeft!(context);
                    } else {
                      Get.back();
                    }
                  },
                  child: Container(
                    width: leftIconSize ?? 24.w,
                    height: leftIconSize ?? 24.w,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: lelfIcon ??
                        SvgPicture.asset(
                          'assets/icons/icon_left.svg',
                          semanticsLabel: 'icon_left',
                        ),
                  ),
                ),
              ),
              Visibility(
                visible: rightIconVisible,
                child: GestureDetector(
                  onTap: () {
                    if (rightIconVisible && pushRight != null) {
                      pushRight!(context);
                    }
                  },
                  child: SizedBox(
                    width: rightIconSizeW ?? 24.w,
                    height: rightIconSizeH ?? 24.w,
                    child: rightIcon ??
                        SvgPicture.asset(
                          'assets/icons/icon_more.svg',
                          semanticsLabel: 'icon_more',
                        ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

// Форма для заполнения коротких (текст)
class TextFieldCustom extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final bool? readOnly;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final int? maxLength;

  const TextFieldCustom({
    super.key,
    required this.labelText,
    this.hintText = '',
    this.readOnly = false,
    this.controller,
    this.inputFormatters,
    this.keyboardType,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            labelText!,
            style: TextStyle(
              color: const Color(0xFF404040),
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 3.h),
        Container(
          height: 40.w,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(5.r)),
          child: TextField(
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
            readOnly: readOnly!,
            controller: controller,
            maxLength: maxLength,
            cursorWidth: 1.w,
            decoration: InputDecoration(
              counterText: "",
              hintText: hintText,
              hintStyle: TextStyle(
                color: const Color(0xFF222222),
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(0),
            ),
            cursorColor: const Color(0xFF222222),
          ),
        ),
      ],
    );
  }
}

class DropdownButtonCustom extends StatelessWidget {
  final String labelText;
  final String value;
  final bool readOnly;
  final TextEditingController controller;
  final List<String> values;

  const DropdownButtonCustom({
    super.key,
    required this.labelText,
    this.value = '',
    this.readOnly = false,
    required this.controller,
    required this.values,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            labelText,
            style: TextStyle(
              color: const Color(0xFF404040),
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 3.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(5.r),
          ),
          child: DropdownButtonFormField<String>(
            dropdownColor: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(5.r),
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.all(0),
            ),
            value: value.isNotEmpty ? value : null,
            items: values.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? value) {
              if (value != null) {
                controller.text = value;
              }
            },
          ),
        ),
      ],
    );
  }
}

class CustomCheckBox extends StatefulWidget {
  const CustomCheckBox({
    super.key,
  });

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  bool transition = true;

  change(action) {
    setState(() {
      if (action == 'b') {
        transition = false;
        authController.genderController.text = 'Женщина';
      } else {
        transition = true;
        authController.genderController.text = 'Мужчина';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            AppStrings.reglabelGender,
            style: TextStyle(
              color: const Color(0xFF404040),
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 5.h),
        SizedBox(
          width: 280.w,
          height: 40.w,
          child: Stack(
            children: [
              AnimatedPositioned(
                curve: Curves.easeOutBack,
                duration: const Duration(milliseconds: 100),
                left: transition ? 0 : 150.w,
                child: Container(
                  width: 130.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(5.r)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      change('a');
                    },
                    child: Container(
                      width: 130.w,
                      height: 40.w,
                      alignment: Alignment.center,
                      color: Colors.white.withOpacity(0),
                      child: Text(
                        'Я парень',
                        style: TextStyle(
                          color: transition
                              ? Colors.black
                              : Colors.black.withOpacity(0.7),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      change('b');
                    },
                    child: Container(
                      width: 130.w,
                      height: 40.w,
                      alignment: Alignment.center,
                      color: Colors.white.withOpacity(0),
                      child: Text(
                        'Я девушка',
                        style: TextStyle(
                          color: !transition
                              ? Colors.black
                              : Colors.black.withOpacity(0.7),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class FormForAboutMe extends StatelessWidget {
  final String? labelText;
  final TextEditingController? controller;

  const FormForAboutMe({
    super.key,
    required this.labelText,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            labelText!,
            style: TextStyle(
              color: const Color(0xFF404040),
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 3.h),
        Container(
          padding: EdgeInsets.all(15.w),
          height: 100.h,
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
              border:
                  Border.all(color: Colors.black.withOpacity(0.1), width: 1),
              borderRadius: BorderRadius.circular(5.r)),
          child: TextField(
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
            controller: controller,
            maxLines: 4,
            minLines: 4,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              hintText: AppStrings.textAboutMe,
              hintStyle: TextStyle(
                color: const Color(0xFF606060),
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(0),
            ),
            cursorColor: const Color(0xFF202020),
            cursorWidth: 1.w,
          ),
        ),
      ],
    );
  }
}

// Лейбл
class Label extends StatelessWidget {
  final String labelText;

  const Label({
    super.key,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            labelText,
            style: TextStyle(
              color: const Color(0xFF909090),
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 5.h),
      ],
    );
  }
}

class Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.white; // Замените цвет на ваш

    // Создаем путь
    Path path = Path();
    path.moveTo(0, 244.h);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 92.h);
    path.close();

    // Рисуем прямоугольник
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class UserPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.white; // Замените цвет на ваш

    // Создаем путь
    Path path = Path();
    path.moveTo(0, 50.h);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 200.h);
    path.close();

    // Рисуем прямоугольник
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class AnimatedButton extends StatefulWidget {
  final String iconPath;
  const AnimatedButton({
    super.key,
    required this.iconPath,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  var liveController = Get.find<LiveController>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.iconPath == 'assets/icons/icon_like.svg') {
          liveController.like(context);
        } else if (widget.iconPath == 'assets/icons/icon_return.svg') {
          liveController.mainCarouselController.value.nextPage();
        }
      },
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 40.w,
          height: 40.w,
          color: Colors.white.withOpacity(0),
          padding: EdgeInsets.all(5.w),
          child: SvgPicture.asset(
            widget.iconPath,
            semanticsLabel: 'icons',
          ),
        ),
      ),
    );
  }
}

Widget messagesBubble(DocumentSnapshot doc, bool showTime, time) {
  return Container(
    alignment: doc['sender'] == currentUser!.uid
        ? Alignment.centerRight
        : Alignment.centerLeft,
    child: Container(
      alignment: doc['sender'] == currentUser!.uid
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Column(
        children: [
          if (showTime) SizedBox(height: 10.w),
          Container(
            alignment: doc['sender'] == currentUser!.uid
                ? Alignment.centerRight
                : Alignment.centerLeft,
            margin: doc['sender'] == currentUser!.uid
                ? EdgeInsets.only(right: 15.w, bottom: 3.w)
                : EdgeInsets.only(left: 15.w, bottom: 3.w),
            child: Visibility(
              visible: showTime,
              child: Text(
                time,
                style: TextStyle(
                  color: const Color(0xFF33363F),
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          if (!showTime) SizedBox(height: 2.w),

          // Message
          Container(
            alignment: doc['sender'] == currentUser!.uid
                ? Alignment.centerRight
                : Alignment.centerLeft,
            margin: doc['sender'] == currentUser!.uid
                ? EdgeInsets.only(right: 10.w)
                : EdgeInsets.only(left: 10.w),
            child: SizedBox(
              width: 260.w,
              child: Container(
                alignment: doc['sender'] == currentUser!.uid
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Directionality(
                  textDirection: doc['sender'] == currentUser!.uid
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Stack(
                      alignment: doc['sender'] == currentUser!.uid
                          ? Alignment.bottomLeft
                          : Alignment.bottomRight,
                      children: [
                        Container(
                          padding: doc['sender'] == currentUser!.uid
                              ? EdgeInsets.only(
                                  top: 5.w,
                                  left: 15.w,
                                  right: 10.w,
                                  bottom: 12.w)
                              : EdgeInsets.only(
                                  top: 5.w,
                                  left: 10.w,
                                  right: 15.w,
                                  bottom: 12.w),
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: Text(
                              "${doc['message']}",
                              textAlign: TextAlign.start,
                              maxLines: null,
                              softWrap: true,
                              style: TextStyle(
                                color: const Color(0xFF33363F),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: doc['sender'] == currentUser!.uid,
                          child: Container(
                            margin: EdgeInsets.all(5.w),
                            width: 5.w,
                            height: 5.w,
                            decoration: BoxDecoration(
                                color: doc['read'].toString().isEmpty
                                    ? Colors.grey
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(5.r)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget chatsBubble(DocumentSnapshot doc, user) {
  var userId = currentUser!.uid;
  var userName = user;

  Map<String, dynamic> usersMap = doc['users'];
  List<String> companionUids = usersMap.keys.toList();

  var companionUid =
      userId == companionUids[0] ? companionUids[1] : companionUids[0];
  var companionName =
      userName == doc['sender'] ? doc['receiver'] : doc['sender'];

  var lastMessage = doc['last_message'];
  var createdOn = doc['created_at'];
  var chat = doc['chat_id'];

  var created = createdOn == null ? DateTime.now() : createdOn.toDate();
  var time = intl.DateFormat("HH:mm").format(created);

  return InkWell(
    onTap: () => {
      Get.to(() => const ChatRoomScreen(),
          transition: Transition.rightToLeft,
          arguments: [
            companionUid,
            companionName,
            userName,
            chat,
          ]),
    },
    child: Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(vertical: 3.h),
      child: ListTile(
        leading: SizedBox(
          width: 50.w,
          height: 50.w,
          child: const CircleAvatar(
            backgroundColor: Colors.grey,
            // backgroundImage: NetworkImage(userData.receiverPhoto),
          ),
        ),
        title: Text(
          companionName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: const Color(0xFF33363F),
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          lastMessage ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: const Color(0xFF33363F),
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 10.w,
              height: 10.w,
              alignment: Alignment.center,
              child: Visibility(
                visible: doc['last_sender'] != currentUser!.uid,
                child: Container(
                  width: 10.w,
                  height: 10.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: doc['read'].toString().isEmpty
                        ? Colors.green
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                ),
              ),
            ),
            Text(
              time,
              style: TextStyle(
                color: const Color(0xFF33363F),
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class ExpandingTextField extends StatefulWidget {
  final TextEditingController controller;
  final int maxLines;
  final int minLines;
  const ExpandingTextField(
      {super.key,
      required this.controller,
      this.maxLines = 6,
      this.minLines = 1});

  @override
  State<ExpandingTextField> createState() => _ExpandingTextFieldState();
}

class _ExpandingTextFieldState extends State<ExpandingTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      keyboardType: TextInputType.multiline,
      decoration: const InputDecoration(
        hintText: 'Сообщение',
        hintStyle: TextStyle(
          color: Color(0xFF101010),
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      ),
      cursorColor: const Color(0xFF202020),
      cursorWidth: 1,
    );
  }
}

class InteractionButtons extends StatelessWidget {
  final String assetsLink;
  final String action;

  const InteractionButtons({
    super.key,
    required this.assetsLink,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5,
          sigmaY: 5,
        ),
        child: Container(
          width: 40.w,
          height: 40.w,
          padding: EdgeInsets.all(5.w),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(5.r),
          ),
          child: SvgPicture.asset(
            assetsLink,
            semanticsLabel: assetsLink,
          ),
        ),
      ),
    );
  }
}
