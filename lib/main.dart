import 'package:unicorn_app/consts/consts.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate();
  await GetStorage.init();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  firebaseMessaging.getInitialMessage();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(const Unicorn());
  });
}

class Unicorn extends StatelessWidget {
  const Unicorn({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Unicorn',
          theme: ThemeData(
              scrollbarTheme: ScrollbarThemeData(
            thumbColor: MaterialStateProperty.all(Colors.transparent),
          )),
          home: const SplashScreen(),
          routes: {
            '/chats': (_) => const ChatsScreen(),
            '/live': (_) => const LiveScreen(),
          },
        );
      },
    );
  }
}

class MainNavigationBar1 extends StatefulWidget {
  const MainNavigationBar1({super.key});

  @override
  State<MainNavigationBar1> createState() => _MainNavigationBarState();
}

class _MainNavigationBarState extends State<MainNavigationBar1> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    var authController = Get.find<AuthController>();
    authController.updateUserStatus(true);
    if (currentUser != null) {
      SystemChannels.lifecycle.setMessageHandler((message) {
        if (message.toString().contains('pause')) {
          authController.updateUserStatus(false);
        } else if (message.toString().contains('resumed')) {
          authController.updateUserStatus(true);
        }
        return Future.value(message);
      });
    }
  }

  var liveController = Get.put(LiveController());
  var chatsController = Get.put(ChatsController());

  List<Widget Function()> pages = [
    () => const Home(),
    () => const LiveScreen(),
    () => const EventScreen(),
    () => const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(child: pages[currentIndex]()),
      bottomNavigationBar: RepaintBoundary(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 70.w,
          padding: EdgeInsets.symmetric(horizontal: 26.w),
          child: CNav(
              onTabChange: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              curve: Curves.easeOutExpo,
              activeColor: const Color(0xFF33363F),
              tabBackgroundColor: const Color(0xFFF5F5F5),
              iconSize: 24.w,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.w),
              tabs: const [
                CButton(
                  icon: 'assets/icons/icon_menu.svg',
                  semanticsLabel: 'menu',
                ),
                CButton(
                  icon: 'assets/icons/icon_live.svg',
                  semanticsLabel: 'live',
                ),
                CButton(
                  icon: 'assets/icons/icon_like.svg',
                  semanticsLabel: 'event',
                ),
                CButton(
                  icon: '',
                  semanticsLabel: 'userPhoto',
                )
              ]),
        ),
      ),
    );
  }
}
