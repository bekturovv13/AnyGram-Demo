import 'package:unicorn_app/consts/consts.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsState();
}

class _ChatsState extends State<ChatsScreen> {
  @override
  Widget build(BuildContext context) {
    var authProvider = Get.find<AuthController>();
    var chatsController = Get.find<ChatsController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const AppBarCustom(
              titleVisible: true,
              titleText: 'Сообщение',
            ),
            Expanded(
              child: Obx(() {
                var nonNullCreatedOnChats = chatsController.chats
                    .where((chat) =>
                        chat['created_at'] != null &&
                        chat['users'].containsKey(currentUser!.uid))
                    .toList();

                nonNullCreatedOnChats.sort((a, b) {
                  // Сравниваем даты в обратном порядке
                  return b['created_at'].compareTo(a['created_at']);
                });

                if (nonNullCreatedOnChats.isEmpty) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FadeIn(
                          child: Text(
                            'У вас нету активных сообщении идите в лайв и найдите кого не будь',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        GestureDetector(
                          onTap: () => Get.toNamed('/live'),
                          child: FadeIn(
                            child: Container(
                              width: 200.w,
                              height: 40.w,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: const Color(0xFF33363F),
                                      width: 1.w),
                                  borderRadius: BorderRadius.circular(10.r)),
                              child: Text(
                                'В Live',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }

                return ListView(
                  physics: const BouncingScrollPhysics(),
                  children: nonNullCreatedOnChats.mapIndexed((index, doc) {
                    return Obx(() => chatsBubble(
                        doc, authProvider.userData.value.userName.value));
                  }).toList(),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
