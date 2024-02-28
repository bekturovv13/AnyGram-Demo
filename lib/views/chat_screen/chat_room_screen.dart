import 'package:intl/intl.dart' as intl;
import 'package:unicorn_app/consts/consts.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  var chatControll = Get.put(ChatRoomController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            AppBarCustom(
              titleVisible: true,
              titleWidget: SizedBox(
                width: 240.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () => Text(
                        chatControll.userData['name'] ?? 'Пользователь',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: const Color(0xFF33363F),
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            height: 1),
                      ),
                    ),
                    Obx(
                      () => Text(
                        chatControll.userData['isOnline'] != null
                            ? chatControll.userData['isOnline']!
                                ? 'в сети'
                                : 'не в сети'
                            : 'нет данных',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: const Color(0xFF33363F),
                          fontSize: 10.sp,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Obx(
              () => Expanded(
                child: chatControll.isloading.value
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.black),
                        ),
                      )
                    : StreamBuilder(
                        stream: StoreServices.getMessages(chatControll.chatId),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          } else {
                            List<QueryDocumentSnapshot> snapshots =
                                snapshot.data!.docs.reversed.toList();

                            if (snapshots.isEmpty) {
                              return Center(
                                child: Text(
                                  'Главное начать 🖐️',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            }

                            return ListView.builder(
                              reverse: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: snapshots.length,
                              itemBuilder: (context, index) {
                                var doc = snapshots[index];

                                // Получаем время сообщения
                                var createdOn = doc['created_at'] == null
                                    ? DateTime.now()
                                    : doc['created_at'].toDate();
                                var time =
                                    intl.DateFormat("HH:mm").format(createdOn);

                                // Переменные для сравнения времени с предыдущим сообщением
                                var previousTime = index < snapshots.length - 1
                                    ? intl.DateFormat("HH:mm").format(
                                        snapshots[index + 1]['created_at']
                                            .toDate())
                                    : null;

                                // Переменные для сравнения отправителя с предыдущим сообщением
                                var lastSender = index < snapshots.length - 1
                                    ? snapshots[index + 1]['sender']
                                    : null;

                                // Переменная для отображения времени
                                var showTime = time != previousTime ||
                                    doc['sender'] != lastSender;

                                // Обновляем статус прочтения сообщения
                                chatControll.updateReadStatus();

                                return messagesBubble(doc, showTime, time);
                              },
                            );
                          }
                        },
                      ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(5.w),
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 50.w,
                    height: 50.w,
                    child: const Icon(
                      Icons.emoji_emotions,
                      color: Colors.black,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: ExpandingTextField(
                        controller: chatControll.messageController,
                        maxLines: 5,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      chatControll.sendMessage(
                          chatControll.messageController.text, context);
                    },
                    child: SizedBox(
                      width: 50.w,
                      height: 50.w,
                      child: const Icon(
                        Icons.send,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
