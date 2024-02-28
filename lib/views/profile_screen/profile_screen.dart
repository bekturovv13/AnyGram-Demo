import 'dart:ui';

import 'package:unicorn_app/consts/consts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var authController = Get.find<AuthController>();
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: 250.h,
              child: Stack(
                children: [
                  SizedBox.expand(
                      child: Obx(
                    () => CachedNetworkImage(
                      imageUrl: authController.userData.value.userPhoto.value,
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
                  ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 15.0,
                        sigmaY: 15.0,
                      ),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Прямоугольник
            SizedBox.expand(
              child: CustomPaint(
                painter: UserPainter(),
                size: Size(360.w, 690.h),
              ),
            ),

            Column(
              children: [
                AppBarCustom(
                  pushRight: (BuildContext context) {
                    Get.to(
                      () => const ProfileEditScreen(),
                      transition: Transition.rightToLeft,
                    );
                  },
                ),
                // Аватар
                Container(
                  margin: EdgeInsets.only(top: 10.h),
                  child: SizedBox(
                    width: 100.w,
                    height: 100.w,
                    child: Stack(
                      children: [
                        GestureDetector(
                          onLongPress: () {
                            authController.userSingOut();
                            Get.offAll(() => const LoginScreen(),
                                transition: Transition.rightToLeft);
                          },
                          child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  color: Colors.white,
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
                        ),
                        Container(
                          alignment: Alignment.bottomRight,
                          padding: EdgeInsets.all(5.w),
                          width: double.infinity,
                          height: double.infinity,
                          child: Container(
                            width: 22.w,
                            height: 22.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),

            //
            Column(
              children: [
                SizedBox(height: 190.h),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 30.w),
                      child: Column(
                        children: [
                          // Имя

                          Obx(
                            () => Text(
                              authController.userData.value.userName.value,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: const Color(0xFF33363F),
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                height: 0,
                              ),
                            ),
                          ),

                          // Возраст, город
                          Obx(
                            () => Text(
                              '${authController.userData.value.userAge}, ${authController.userData.value.userCity}',
                              maxLines: 1,
                              style: TextStyle(
                                color: const Color(0xFF33363F),
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                height: 0,
                              ),
                            ),
                          ),
                          SizedBox(height: 15.h),

                          // Лайки и взаимные
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    AppStrings.likes,
                                    style: TextStyle(
                                      color: const Color(0xFF33363F),
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Obx(
                                    () => Text(
                                      authController
                                          .userData.value.userLikes.value
                                          .toString(),
                                      style: TextStyle(
                                        color: const Color(0xFF33363F),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(width: 50.w),
                              Column(
                                children: [
                                  Text(
                                    AppStrings.mutual,
                                    style: TextStyle(
                                      color: const Color(0xFF33363F),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Obx(
                                    () => Text(
                                      authController
                                          .userData.value.userMutual.value
                                          .toString(),
                                      style: TextStyle(
                                        color: const Color(0xFF33363F),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h),

                          //О себе
                          Container(
                            width: double.infinity,
                            height: 120.h,
                            alignment: Alignment.topCenter,
                            child: Obx(
                              () => Text(
                                authController
                                        .userData.value.userBio.value.isNotEmpty
                                    ? authController
                                        .userData.value.userBio.value
                                    : AppStrings.forAboutMe,
                                maxLines: 6,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: const Color(0xFF33363F),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 30.h,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
