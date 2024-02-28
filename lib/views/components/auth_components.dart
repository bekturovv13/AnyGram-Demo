import 'package:unicorn_app/consts/consts.dart';

class NumBottons extends StatefulWidget {
  final String type;
  final String button;
  final String iconPath;
  const NumBottons({
    super.key,
    this.button = '',
    this.iconPath = '',
    this.type = 'phone',
  });

  @override
  State<NumBottons> createState() => _NumBottonsState();
}

class _NumBottonsState extends State<NumBottons> {
  var authController = Get.find<AuthController>();
  var singinController = Get.find<SinginController>();

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.5),
      borderRadius: BorderRadius.circular(5.r),
      color: const Color(0xFFF5F5F5),
      child: InkWell(
        onTap: () {
          if (widget.type == 'phone' &&
              singinController.phonefocusNode.value.hasFocus) {
            String buttonText = widget.button;
            String phoneText = authController.phoneController.value.text;

            if (buttonText == 'backspace') {
              authController.phoneController.text =
                  singinController.removeLastDigit(phoneText);
            } else if ('0123456789'.contains(buttonText) &&
                phoneText.length < 12) {
              authController.phoneController.text += buttonText;

              if (authController.phoneController.text.length == 12) {
                singinController.phonefocusNode.value.unfocus();
                authController.checkOnCondition(context);
              }
            }
            if ([3, 6, 9]
                .contains(authController.phoneController.text.length)) {
              authController.phoneController.text += ' ';
            }
          }
          if (widget.type == 'OTP' &&
              singinController.otpFocusNodes
                  .any((node) => node?.hasFocus ?? false)) {
            singinController.handleButtonPress(context, widget.button);
          }
        },
        borderRadius: BorderRadius.circular(5.r),
        child: Container(
          alignment: Alignment.center,
          width: 80.w,
          height: 40.w,
          child: widget.iconPath.isEmpty
              ? Text(
                  widget.button,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : SvgPicture.asset(
                  widget.iconPath,
                  semanticsLabel: 'backspace',
                ),
        ),
      ),
    );
  }
}

typedef OnCodeEnteredCompletion = void Function(String value);
typedef OnCodeChanged = void Function(String value);
typedef HandleControllers = void Function(
    List<TextEditingController?> controllers);

class OTP extends StatefulWidget {
  const OTP({super.key});

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  var authController = Get.find<AuthController>();
  var singinController = Get.find<SinginController>();

  @override
  void initState() {
    super.initState();
    authController.verificationCode = List<String?>.filled(6, null);
    authController.otpControllers =
        List<TextEditingController?>.filled(6, null);
    singinController.otpFocusNodes.value = List<FocusNode?>.filled(6, null);
  }

  @override
  Widget build(BuildContext context) {
    return generateTextFields(context);
  }

  Widget _buildTextField({
    required BuildContext context,
    required int index,
  }) {
    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 40.w,
        height: 40.w,
        margin: EdgeInsets.only(right: 4.w),
        decoration: BoxDecoration(
            color: authController.showInvalidCode.value
                ? const Color(0xFFFF3636)
                : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(3.r)),
        child: TextField(
          showCursor: true,
          textAlign: TextAlign.center,
          maxLength: 1,
          cursorWidth: 1.w,
          readOnly: true,
          style: TextStyle(
            color: authController.showInvalidCode.value
                ? const Color(0xFFFFFFFF)
                : const Color(0xFF000000),
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
          cursorColor: authController.showInvalidCode.value
              ? const Color(0xFFFFFFFF)
              : const Color(0xFF222222),
          controller: authController.otpControllers[index],
          focusNode: singinController.otpFocusNodes[index],
          autofocus: true,
          enabled: true,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            counterText: "",
            contentPadding: const EdgeInsets.all(0),
            filled: false,
            fillColor: Colors.white,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1.w,
                color: authController.showInvalidCode.value
                    ? const Color(0xFFFF0000)
                    : const Color(0xFF909090),
              ),
              borderRadius: BorderRadius.all(Radius.circular(3.r)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1.w,
                color: authController.showInvalidCode.value
                    ? const Color(0xFFFF0000)
                    : Colors.transparent,
              ),
              borderRadius: BorderRadius.all(Radius.circular(3.r)),
            ),
            disabledBorder:
                const OutlineInputBorder(borderSide: BorderSide.none),
            border: const OutlineInputBorder(borderSide: BorderSide.none),
          ),
          obscureText: false,
        ),
      ),
    );
  }

  Widget generateTextFields(BuildContext context) {
    List<Widget> textFields = List.generate(6, (int i) {
      addFocusNodeToEachTextField(index: i);
      addTextEditingControllerToEachTextField(index: i);
      return _buildTextField(context: context, index: i);
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: textFields,
    );
  }

  void addFocusNodeToEachTextField({required int index}) {
    if (singinController.otpFocusNodes[index] == null) {
      singinController.otpFocusNodes[index] = FocusNode();
    }
  }

  void addTextEditingControllerToEachTextField({required int index}) {
    if (authController.otpControllers[index] == null) {
      authController.otpControllers[index] = TextEditingController();
    }
  }

  @override
  void dispose() {
    super.dispose();
    for (var controller in authController.otpControllers) {
      controller?.dispose();
    }
  }
}

class UpDialogWindow extends StatefulWidget {
  final String text;
  final bool visible;
  const UpDialogWindow({super.key, required this.text, required this.visible});

  @override
  State<UpDialogWindow> createState() => _UpDialogWindowState();
}

class _UpDialogWindowState extends State<UpDialogWindow> {
  var authController = Get.find<AuthController>();
  var singinController = Get.find<SinginController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            authController.resendOTPSuccess(false);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            color: widget.visible ? Colors.black.withOpacity(0.1) : null,
          ),
        ),
        AnimatedPositioned(
          left: 0,
          right: 0,
          top: widget.visible ? 0 : -250,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeOutBack,
          child: Container(
            margin: EdgeInsets.all(20.w),
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Text(
              widget.text,
              style: TextStyle(
                color: const Color(0xFF33363F),
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DownDialogWindow extends StatefulWidget {
  final String text;
  final bool visible;
  const DownDialogWindow(
      {super.key, required this.text, required this.visible});

  @override
  State<DownDialogWindow> createState() => _DownDialogWindowState();
}

class _DownDialogWindowState extends State<DownDialogWindow> {
  var authController = Get.find<AuthController>();
  var singinController = Get.find<SinginController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            color: widget.visible ? Colors.black.withOpacity(0.1) : null,
          ),
          AnimatedPositioned(
            left: 0,
            right: 0,
            bottom: widget.visible ? 0 : -200,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOutBack,
            child: Container(
              margin: EdgeInsets.all(20.w),
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                children: [
                  Text(
                    widget.text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF33363F),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  if (!authController.alreadyRequested.value)
                    Text(
                      singinController
                          .formatTime(authController.timer5Min.value),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
