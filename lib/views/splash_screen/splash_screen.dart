import 'package:google_fonts/google_fonts.dart';
import 'package:unicorn_app/consts/consts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    var authController =
        Get.put<AuthController>(AuthController(), permanent: true);
    super.initState();
    Future.delayed(const Duration(seconds: 6), () async {
      await authController.checkSing();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeIn(
                    delay: const Duration(milliseconds: 1000),
                    duration: const Duration(milliseconds: 1000),
                    child: SizedBox(
                      width: 100.w,
                      height: 100.w,
                      child: Image.asset('assets/icons/logo.png'),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'UNICORN',
                    style: GoogleFonts.bellotaText(
                      color: const Color(0xFF33363F),
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(bottom: 40.h),
              child: Text(
                'power by\nunicorn'.toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.bellotaText(
                  color: Colors.black,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
