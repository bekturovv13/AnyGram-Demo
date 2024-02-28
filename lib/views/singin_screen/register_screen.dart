import 'package:unicorn_app/consts/consts.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({super.key});

  @override
  State<CreateUser> createState() => _CreateUser();
}

class _CreateUser extends State<CreateUser> {
  List<String> cities = AppStrings.cities;
  List<String> gender = AppStrings.gender;

  @override
  Widget build(BuildContext context) {
    var authController = Get.find<AuthController>();
    final formattedNumber = '+996 ${authController.phoneController.value.text}';
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(
          () => SizedBox(
            child: authController.isloading.value
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Color(0xFF33363F)),
                    ),
                  )
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.bottomCenter,
                            height: 70.w,
                            child: Text(
                              AppStrings.completeRegistrationText,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFF222222),
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                          SizedBox(height: 15.h),

                          // Фото пользователя
                          SizedBox(
                            width: 100.w,
                            height: 100.w,
                            child: GestureDetector(
                              onTap: () => authController.getImageGallery(),
                              child: authController.imagePath.value.isEmpty
                                  ? CircleAvatar(
                                      backgroundColor: const Color(0xFFF5F5F5),
                                      child: Icon(
                                        Icons.account_circle,
                                        color: const Color(0xFF33363F),
                                        size: 30.w,
                                      ),
                                    )
                                  : CircleAvatar(
                                      backgroundColor: const Color(0xFFF5F5F5),
                                      backgroundImage:
                                          FileImage(authController.image!),
                                      radius: 50,
                                    ),
                            ),
                          ),
                          SizedBox(height: 15.h),

                          // Номер телефона
                          TextFieldCustom(
                            labelText: AppStrings.labelPhoneNumder,
                            readOnly: true,
                            hintText: formattedNumber,
                          ),
                          SizedBox(height: 10.h),

                          // Имя
                          TextFieldCustom(
                            labelText: AppStrings.reglabelName,
                            controller: authController.nameController,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(
                                  RegExp(r'[0-9]')),
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Zа-яА-ЯЁё]')),
                            ],
                            maxLength: 16,
                          ),
                          SizedBox(height: 10.h),

                          // Возраст
                          TextFieldCustom(
                            labelText: AppStrings.reglabelAge,
                            controller: authController.ageController,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            keyboardType: TextInputType.number,
                            maxLength: 2,
                          ),
                          SizedBox(height: 10.h),

                          // Пол
                          const CustomCheckBox(),
                          SizedBox(height: 10.h),
                          // Город
                          DropdownButtonCustom(
                            labelText: AppStrings.reglabelCity,
                            controller: authController.cityController,
                            values: cities,
                          ),
                          SizedBox(height: 10.h),

                          FormForAboutMe(
                              labelText: AppStrings.reglabelAboutMe,
                              controller: authController.bioController),

                          SizedBox(height: 40.h),

                          // Кнопка
                          GestureDetector(
                            onTap: () {
                              authController.createUserDataCheck(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 280.w,
                              height: 40.w,
                              decoration: BoxDecoration(
                                color: const Color(0xFF222222),
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              child: Text(
                                AppStrings.completeButton,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 70.w),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
