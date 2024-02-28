import 'package:google_fonts/google_fonts.dart';
import 'package:unicorn_app/consts/consts.dart';

class LiveScreen extends StatefulWidget {
  const LiveScreen({super.key});
  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  var authController = Get.find<AuthController>();
  var liveController = Get.find<LiveController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: 345.h,
            color: const Color(0xFF51565A),
          ),
          Column(
            children: [
              Container(
                color: Colors.amber,
                height: 80.h,
                child: Container(
                  margin: EdgeInsets.only(top: 30.w),
                  alignment: Alignment.center,
                  child: Text(
                    'Live',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Obx(
                  () {
                    if (liveController.users.isEmpty) {
                      return Center(
                        child: Text(
                          'Данная время нету пользователей подходящих под вашу анкету, попробуйте вернутся чуть позже',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF33363F),
                            fontSize: 14.sp,
                          ),
                        ),
                      );
                    } else {
                      return RepaintBoundary(
                        child: CardSlider(
                          cards: liveController.users.map((user) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              padding: EdgeInsets.all(5.h),
                              child: Hero(
                                tag: user['photo'],
                                child: Container(
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.r),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox.expand(
                                        child: Image.network(
                                          user['photo'],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      AnimatedOpacity(
                                        curve: Curves.easeInOutCubic,
                                        duration:
                                            const Duration(milliseconds: 800),
                                        opacity: liveController
                                                .deskcriptionScreen.value
                                            ? 0
                                            : 1.0,
                                        child: Container(
                                          margin: EdgeInsets.all(20.w),
                                          child: Text(
                                            user['name'],
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.lobster(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 36.sp,
                                                letterSpacing: 3,
                                                shadows: [
                                                  BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.5),
                                                      blurRadius: 4,
                                                      offset:
                                                          const Offset(0, 4))
                                                ]),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          slideChanged: (sliderIndex) {
                            liveController.current.value = sliderIndex;
                            liveController.receiverUid.value =
                                liveController.users[sliderIndex]['uid'];
                            liveController.receiverPhoto.value =
                                liveController.users[sliderIndex]['photo'];
                            liveController.receiverName.value =
                                liveController.users[sliderIndex]['name'];
                            liveController.receiverAge.value = liveController
                                .users[sliderIndex]['age']
                                .toString();
                            liveController.receiverCity.value =
                                liveController.users[sliderIndex]['city'];
                            liveController.receiverBio.value =
                                liveController.users[sliderIndex]['bio'];
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
              Container(color: Colors.amber, height: 80.h),
            ],
          ),
        ],
      ),
    );
  }
}
