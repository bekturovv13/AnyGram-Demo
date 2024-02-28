import 'dart:async';

import 'package:unicorn_app/consts/consts.dart';

class ChatRoomController extends GetxController {
  var liveController = Get.find<LiveController>();
  StreamSubscription<DocumentSnapshot>? _userDataStream;
  var userData = <String, dynamic>{}.obs;
  RxBool isloading = true.obs;

  dynamic chatId;
  dynamic messageEdit;

  var chat = Get.arguments[3] ?? '';

  var chats = firebaseFirestore.collection(collectionChats);
  var senderUid = currentUser!.uid;
  var sender = Get.arguments[2];
  var receiverUid = Get.arguments[0];
  var receiver = Get.arguments[1];
  var messageController = TextEditingController();

  getChatId() async {
    isloading(true);
    await chats
        .where('users', isEqualTo: {receiverUid: null, senderUid: null})
        .limit(1)
        .get()
        .then((QuerySnapshot snapshot) async {
          if (snapshot.docs.isNotEmpty) {
            chatId = snapshot.docs.single.id;
          } else {
            await chats.add({
              'users': {senderUid: null, receiverUid: null},
              'sender': sender,
              'receiver': receiver,
              'from_id': '',
              'to_id': '',
              "created_at": null,
              'last_message': '',
              'last_sender': '',
              'read': '',
              'chat_id': ''
            }).then((value) {
              chatId = value.id;
              chats.doc(chatId).update({
                'chat_id': chatId,
              });
            });
          }
        });
    isloading(false);
  }

  sendMessage(String message, BuildContext context) async {
    if (message.trim().isNotEmpty && chatId != null) {
      messageEdit = message.trim();
      messageController.clear();
      chats.doc(chatId).update({
        'created_at': FieldValue.serverTimestamp(),
        'last_message': messageEdit,
        'from_id': senderUid,
        'to_id': receiverUid,
        'last_sender': senderUid,
        'read': '',
      });
      chats.doc(chatId).collection(collectionMessages).doc().set({
        'created_at': FieldValue.serverTimestamp(),
        'message': messageEdit,
        'sender': senderUid,
        'read': '',
      });
      await liveController.updateContact(context, receiverUid);
    }
  }

  updateReadStatus() async {
    if (chatId != null) {
      DocumentSnapshot chatSnapshot = await chats.doc(chatId).get();
      if (chatSnapshot.exists) {
        dynamic data = chatSnapshot.data();
        if (data is Map<String, dynamic>) {
          if (data['last_sender'] != currentUser!.uid) {
            chats.doc(chatId).update({
              'read': 'READ',
            });
          }
        }
      }
      QuerySnapshot messages = await chats
          .doc(chatId)
          .collection(collectionMessages)
          .where('sender', isNotEqualTo: senderUid)
          .get();
      for (QueryDocumentSnapshot messageDoc in messages.docs) {
        if (messageDoc['read'] != 'READ') {
          messageDoc.reference.update({'read': 'READ'});
        }
      }
    }
  }

  @override
  void onInit() {
    if (chat == null || chat == '') {
      getChatId();
    } else {
      chatId = chat;
      isloading(false);
    }
    _userDataStream = StoreServices.getUserData(receiverUid)
        .listen((DocumentSnapshot userDoc) {
      Map<String, dynamic> newData =
          userDoc.data() as Map<String, dynamic>? ?? {};
      newData.forEach((key, value) {
        if (userData[key] != value) {
          userData[key] = value;
        }
      });
      userData.keys.toList().forEach((key) {
        if (!newData.containsKey(key)) {
          userData.remove(key);
        }
      });
      update();
    });
    super.onInit();
  }

  @override
  void onClose() {
    _userDataStream?.cancel();
    super.onClose();
  }
}
