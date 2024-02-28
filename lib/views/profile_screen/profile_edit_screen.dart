import 'package:unicorn_app/consts/consts.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  var authController = Get.find<AuthController>();
  var liveController = Get.find<LiveController>();

  var nameController = TextEditingController();
  var ageController = TextEditingController();
  var cityController = TextEditingController();
  var bioController = TextEditingController();

  @override
  void initState() {
    nameController.text = authController.userData.value.userName.value;
    ageController.text = authController.userData.value.userAge.toString();
    cityController.text = authController.userData.value.userCity.value;
    bioController.text = authController.userData.value.userBio.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> cities = AppStrings.cities;

    final formattedNumber = authController.userData.value.userNumber.value;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            AppBarCustom(
              rightIcon: Container(
                alignment: Alignment.center,
                child: Text(
                  AppStrings.saveButton,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              rightIconSizeW: 85.w,
              rightIconSizeH: 24.h,
              pushRight: (BuildContext context) {
                FocusManager.instance.primaryFocus?.unfocus();
                //_____________________________________________________________________
                storeData(context);
                //_____________________________________________________________________
              },
            ),

            // Фото пользователя
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Column(
                    children: [
                      Obx(
                        () => SizedBox(
                          width: 80.w,
                          height: 80.w,
                          child: InkWell(
                            onTap: () {
                              authController.getImageGallery();
                            },
                            child: authController.imagePath.isEmpty
                                ? Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(50.r),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: authController
                                          .userData.value.userPhoto.value,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const Center(
                                        child: CircularProgressIndicator(
                                          color: Color(0xFF33363F),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
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
                      ),
                      SizedBox(height: 20.h),

                      // Номер телефона
                      TextFieldCustom(
                        labelText: AppStrings.labelPhoneNumder,
                        readOnly: true,
                        hintText: formattedNumber,
                      ),

                      // Имя
                      TextFieldCustom(
                        labelText: AppStrings.reglabelName,
                        controller: nameController,
                        hintText: 'Имя',
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Zа-яА-ЯЁё]')),
                        ],
                        maxLength: 16,
                      ),

                      // Возраст
                      TextFieldCustom(
                        labelText: AppStrings.reglabelAge,
                        controller: ageController,
                        hintText: '',
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                      ),

                      // Город
                      DropdownButtonCustom(
                          labelText: AppStrings.reglabelCity,
                          controller: cityController,
                          values: cities,
                          value: cityController.text.trim()),
                      SizedBox(height: 15.h),

                      // Раздел "О себе"
                      Column(
                        children: [
                          const Label(labelText: AppStrings.reglabelAboutMe),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.w, vertical: 10.w),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                            child: TextField(
                              controller: bioController,
                              maxLines: null,
                              style: TextStyle(
                                color: const Color(0xFF33363F),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: InputDecoration(
                                hintText: AppStrings.textAboutMe,
                                hintStyle: TextStyle(
                                  color: const Color(0xFF909090),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                hintMaxLines: 6,
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 0),
                              ),
                              cursorColor: const Color(0xFF202020),
                              cursorWidth: 1.w,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void storeData(BuildContext context) async {
    int? age = int.tryParse(ageController.text.trim());

    if (authController.image != null ||
        nameController.text != authController.userData.value.userName.value ||
        ageController.text !=
            authController.userData.value.userAge.toString() ||
        cityController.text != authController.userData.value.userCity.value ||
        bioController.text != authController.userData.value.userBio.value) {
      if (nameController.text.trim().length >= 4 && age! >= 14) {
        authController.nameController.text = nameController.text.trim();
        authController.ageController.text = ageController.text.trim();
        authController.cityController.text = cityController.text.trim();
        authController.bioController.text = bioController.text.trim();
        await authController.updateUserData(context);
        liveController.reload();
      } else {
        if (nameController.text.trim().length < 4) {
          // ignore: use_build_context_synchronously
          showSneckBar(context, AppStrings.nameWarning);
        } else if (age == null || age < 14) {
          // ignore: use_build_context_synchronously
          showSneckBar(context, AppStrings.ageWarning);
        }
      }
    }
  }
}
