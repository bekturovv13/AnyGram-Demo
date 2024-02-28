import 'package:unicorn_app/consts/consts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var authController = Get.find<AuthController>();
  var singinController = Get.put(SinginController());

  i() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        singinController.phonefocusNode.value.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
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
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40.w, vertical: 30.h),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Привет,\nс возвращением'.toUpperCase(),
                                      style: TextStyle(
                                        color: const Color(0xFF222222),
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  Text(
                                    AppStrings.requestNumber,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: const Color(0xFF222222),
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //------------------------------------------------- 2
                          Container(
                            width: 250.w,
                            height: 40.w,
                            decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(5.r)),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 3.h),
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 20.w),
                                  child: Text(
                                    '+996',
                                    style: TextStyle(
                                      color: const Color(0xFF222222),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Obx(
                                    () => TextFormField(
                                      readOnly: true,
                                      autofocus: true,
                                      focusNode:
                                          singinController.phonefocusNode.value,
                                      maxLength: 12,
                                      textInputAction: TextInputAction.none,
                                      controller:
                                          authController.phoneController,
                                      style: TextStyle(
                                        color: const Color(0xFF222222),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      showCursor: true,
                                      cursorColor: const Color(0xFF222222),
                                      cursorWidth: 1.w,
                                      decoration: InputDecoration(
                                        counterText: '',
                                        hintText: AppStrings.labelPhoneNumder,
                                        hintStyle: TextStyle(
                                          color: const Color(0xFF606060),
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding: const EdgeInsets.all(0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //------------------------------------------------- 3
                          Expanded(
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(
                                          top: 40.w, left: 50.w, right: 50.w),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            width: 260.w,
                                            child: const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                NumBottons(button: '1'),
                                                NumBottons(button: '2'),
                                                NumBottons(button: '3'),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10.w),
                                          SizedBox(
                                            width: 260.w,
                                            child: const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                NumBottons(button: '4'),
                                                NumBottons(button: '5'),
                                                NumBottons(button: '6'),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10.w),
                                          SizedBox(
                                            width: 260.w,
                                            child: const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                NumBottons(button: '7'),
                                                NumBottons(button: '8'),
                                                NumBottons(button: '9'),
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
                                                const NumBottons(button: '0'),
                                                SizedBox(width: 10.w),
                                                const NumBottons(
                                                    button: 'backspace',
                                                    iconPath:
                                                        'assets/icons/backspace.svg'),
                                              ],
                                            ),
                                          ),
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
                      Obx(
                        () => Stack(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 1000),
                              color: singinController.checkNumber.value
                                  ? Colors.black.withOpacity(0.7)
                                  : null,
                            ),
                            AnimatedPositioned(
                              left: 0,
                              right: 0,
                              bottom:
                                  singinController.checkNumber.value ? 0 : -200,
                              duration: const Duration(milliseconds: 700),
                              curve: Curves.easeOutBack,
                              child: Container(
                                margin: EdgeInsets.all(30.w),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.r)),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(20.w),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Правильно ли указан номер?',
                                            style: TextStyle(
                                              color: const Color(0xFF33363F),
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 5.w),
                                          Text(
                                            '+996 ${authController.phoneController.text}',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 15.w),
                                      padding: EdgeInsets.only(bottom: 5.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              singinController
                                                  .phonefocusNode.value
                                                  .requestFocus();
                                              singinController.check();
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: 100.w,
                                              height: 40.w,
                                              child: Text(
                                                'Изменить'.toUpperCase(),
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xFF222222),
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              authController.sendingFunction(
                                                  context, 'send');
                                              singinController
                                                  .checkNumber(false);
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: 100.w,
                                              height: 40.w,
                                              child: Text(
                                                'Да'.toUpperCase(),
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xFF222222),
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      DownDialogWindow(
                          text: AppStrings.waitingRequest,
                          visible: authController.waitingResendCode.value),
                      DownDialogWindow(
                          text: AppStrings.manyInvalidCode,
                          visible: authController.waitingInvalidCode.value),
                      DownDialogWindow(
                          text: AppStrings.alreadyRequested,
                          visible: authController.alreadyRequested.value),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
