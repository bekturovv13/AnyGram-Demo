import 'package:google_fonts/google_fonts.dart';
import 'package:unicorn_app/consts/consts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var liveController = Get.put(LiveController());
  var chatsController = Get.put(ChatsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 70.w,
              color: const Color(0xFF9C9C9C),
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 30.h),
                    alignment: Alignment.center,
                    child: Text(
                      'Unicorn',
                      style: GoogleFonts.kaushanScript(
                        color: Colors.black,
                        fontSize: 24.sp,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => const ChatsScreen(),
                        transition: Transition.rightToLeft),
                    child: Container(
                      width: 40.h,
                      height: 40.h,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 22.h, right: 22.w),
                      color: Colors.transparent,
                      child: SvgPicture.asset(
                        'assets/icons/icon_chats.svg',
                        semanticsLabel: 'icon_chats',
                        width: 24.w,
                        height: 24.w,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => Get.to(() => const LiveScreen()),
                    child: Container(
                      height: 50.h,
                      color: Colors.amber,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => const EventScreen()),
                    child: Container(
                      height: 50.h,
                      color: Colors.blue,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => const ProfileScreen()),
                    child: Container(
                      height: 50.h,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 50.h),
                  Text(MediaQuery.of(context).size.width.toString()),
                  Text(MediaQuery.of(context).size.height.toString()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
