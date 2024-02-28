import 'dart:async';

import 'package:unicorn_app/consts/consts.dart';

class ChatsController extends GetxController {
  final RxList<DocumentSnapshot> chats = <DocumentSnapshot>[].obs;
  StreamSubscription<QuerySnapshot>? _chatStream;

  @override
  onInit() {
    super.onInit();
    if (currentUser != null) {
      _chatStream = StoreServices.getChats().listen((QuerySnapshot allChats) {
        for (var newDoc in allChats.docs) {
          var existingDocIndex = chats.indexWhere(
            (existingDoc) => existingDoc.id == newDoc.id,
          );
          if (existingDocIndex != -1) {
            chats[existingDocIndex] = newDoc;
          } else {
            chats.add(newDoc);
          }
        }
        for (var existingDoc in chats.toList()) {
          if (allChats.docs.every((newDoc) => newDoc.id != existingDoc.id)) {
            chats.remove(existingDoc);
          }
        }
        update();
      });
    }
  }

  @override
  void onClose() {
    _chatStream?.cancel();
    super.onClose();
  }
}
