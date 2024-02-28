import 'package:unicorn_app/consts/consts.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  @override
  Widget build(BuildContext context) {
    var authController = Get.find<AuthController>();
    var singinController = Get.put(SinginController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Obx(
        () => SizedBox(
          child: authController.isloading.value
              ? Container(
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Color(0xFF222222)),
                  ),
                )
              : Stack(
                  children: [
                    Column(
                      children: [
                        //------------------------------------------------- 1
                        SizedBox(
                          height: 70.w,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                width: 40.w,
                                height: 40.w,
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(top: 22.w, left: 22.w),
                                color: Colors.white.withOpacity(0),
                                child: SvgPicture.asset(
                                  'assets/icons/icon_left.svg',
                                  semanticsLabel: 'back',
                                  width: 24.w,
                                  height: 24.w,
                                ),
                              ),
                            ),
                          ),
                        ),

                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                AppStrings.textCod,
                                style: TextStyle(
                                  color: const Color(0xFF222222),
                                  fontSize: 96.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                AppStrings.examination,
                                style: TextStyle(
                                  color: const Color(0xFF222222),
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 15.w),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 40.w),
                                child: Text(
                                  '${AppStrings.otpLabel} +996 ${authController.phoneController.value.text}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFF222222),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(height: 30.w),
                            ],
                          ),
                        ),
                        //------------------------------------------------- 2
                        const OTP(),
                        //------------------------------------------------- 3
                        Expanded(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 40.w,
                                child: GestureDetector(
                                  onTap: () {
                                    if (authController
                                            .isResendAvailable.value &&
                                        authController.resendCodeQuantity < 3) {
                                      authController.sendingFunction(
                                          context, 'resend');
                                    }
                                  },
                                  child: Obx(
                                    () => Container(
                                      height: 40.w,
                                      alignment: Alignment.center,
                                      child: Container(
                                        padding: EdgeInsets.all(5.h),
                                        color: Colors.white.withOpacity(0),
                                        child: authController
                                                .isResendAvailable.value
                                            ? FadeIn(
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                child: Text(
                                                  'Повторить отправку',
                                                  style: TextStyle(
                                                    color: authController
                                                                .resendCodeQuantity <
                                                            3
                                                        ? const Color(
                                                            0xFF33363F)
                                                        : const Color(
                                                            0xFF909090),
                                                    fontSize: 12.sp,
                                                  ),
                                                ),
                                              )
                                            : FadeIn(
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                child: Text(
                                                  singinController.formatTime(
                                                      authController
                                                          .timer2Min.value),
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12.sp,
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 50.w),
                                child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(
                                          width: 260.w,
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              NumBottons(
                                                  type: 'OTP', button: '1'),
                                              NumBottons(
                                                  type: 'OTP', button: '2'),
                                              NumBottons(
                                                  type: 'OTP', button: '3'),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 10.w),
                                        SizedBox(
                                          width: 260.w,
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              NumBottons(
                                                  type: 'OTP', button: '4'),
                                              NumBottons(
                                                  type: 'OTP', button: '5'),
                                              NumBottons(
                                                  type: 'OTP', button: '6'),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 10.w),
                                        SizedBox(
                                          width: 260.w,
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              NumBottons(
                                                  type: 'OTP', button: '7'),
                                              NumBottons(
                                                  type: 'OTP', button: '8'),
                                              NumBottons(
                                                  type: 'OTP', button: '9'),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 10.w),
                                        SizedBox(
                                          width: 260.w,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              const NumBottons(
                                                  type: 'OTP', button: '0'),
                                              SizedBox(width: 10.w),
                                              const NumBottons(
                                                  type: 'OTP',
                                                  button: 'backspace',
                                                  iconPath:
                                                      'assets/icons/backspace.svg'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 70.w),
                      ],
                    ),
                    UpDialogWindow(
                        text: AppStrings.resendingOTPSuccess,
                        visible: authController.resendOTPSuccess.value),
                  ],
                ),
        ),
      ),
    );
  }
}
