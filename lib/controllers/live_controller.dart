import 'dart:async';
import 'package:unicorn_app/consts/consts.dart';

var chats = firebaseFirestore.collection(collectionChats);

class LiveController extends GetxController {
  var authController = Get.find<AuthController>();
  final RxList<DocumentSnapshot> users = <DocumentSnapshot>[].obs;

  var messageController = TextEditingController();

  Rx<CarouselController> mainCarouselController = CarouselController().obs;
  StreamSubscription<QuerySnapshot>? _liveStream;

  RxBool userDescriptionScreen = false.obs;

  RxInt current = 0.obs;
  RxDouble delta = 0.0.obs;

  RxBool isVisible = false.obs;

  void viewMainPhoto(context) {
    deskcriptionButtons(false);
    Future.delayed(const Duration(milliseconds: 200), () {
      Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 700),
          reverseTransitionDuration: const Duration(milliseconds: 700),
          pageBuilder: (context, animation, secondaryAnimation) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: const Interval(0, 0.4),
            );

            return FadeTransition(
              opacity: curvedAnimation,
              child: const DetailScreen(),
            );
          },
        ),
      );
    });
  }

  RxBool visibleChatScreen = false.obs;
  chatScreen() {
    visibleChatScreen.value = !visibleChatScreen.value;
  }

  RxBool isloading = false.obs;

  RxBool deskcriptionScreen = false.obs;
  RxBool deskcriptionButtons = false.obs;
  RxBool deskcriptionName = false.obs;
  RxBool deskcriptionAgeCity = false.obs;
  RxBool deskcriptionBio = false.obs;
  RxBool galery = false.obs;

  showDeskcriptionDetails() async {
    deskcriptionName(true);
    await Future.delayed(
        const Duration(milliseconds: 100), () => deskcriptionAgeCity(true));
    await Future.delayed(
        const Duration(milliseconds: 100), () => deskcriptionBio(true));
  }

  openDetailScreen() {
    deskcriptionScreen(true);
    deskcriptionButtons(true);
    Future.delayed(const Duration(milliseconds: 50), () => galery(true));
    Future.delayed(
        const Duration(milliseconds: 200), () => showDeskcriptionDetails());
  }

  closeDetailScreen() async {
    deskcriptionBio(false);
    deskcriptionName(false);
    deskcriptionAgeCity(false);
    deskcriptionScreen(false);
    deskcriptionButtons(false);
    galery(false);
  }

  dynamic chatId;
  dynamic messageEdit;

  var receiverPhoto = ''.obs;
  var receiverName = ''.obs;
  var receiverUid = ''.obs;
  var receiverAge = ''.obs;
  var receiverCity = ''.obs;
  var receiverBio = ''.obs;

  getChatId() async {
    isloading(true);
    await chats
        .where('users',
            isEqualTo: {receiverUid.value: null, currentUser!.uid: null})
        .limit(1)
        .get()
        .then((QuerySnapshot snapshot) async {
          if (snapshot.docs.isNotEmpty) {
            chatId = snapshot.docs.single.id;
          } else {
            await chats.add({
              'users': {currentUser!.uid: null, receiverUid.value: null},
              'sender': authController.userData.value.userName.value,
              'receiver': receiverName,
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
        'from_id': currentUser!.uid,
        'to_id': receiverUid.value,
        'last_sender': currentUser!.uid,
        'read': '',
      });
      chats.doc(chatId).collection(collectionMessages).doc().set({
        'created_at': FieldValue.serverTimestamp(),
        'message': messageEdit,
        'sender': currentUser!.uid,
        'read': '',
      });
      await updateContact(context, receiverUid.value);
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
          .where('sender', isNotEqualTo: currentUser!.uid)
          .get();
      for (QueryDocumentSnapshot messageDoc in messages.docs) {
        if (messageDoc['read'] != 'READ') {
          messageDoc.reference.update({'read': 'READ'});
        }
      }
    }
  }

  updateContact(context, String receiverUid) async {
    try {
      var userSnapshot = await firebaseFirestore
          .collection(collectionUsers)
          .doc(receiverUid)
          .get();

      if (userSnapshot.exists) {
        var contactsMap = userSnapshot['contacts'] as Map<dynamic, dynamic>?;
        if (contactsMap == null || !contactsMap.containsKey(currentUser!.uid)) {
          await firebaseFirestore
              .collection(collectionUsers)
              .doc(receiverUid)
              .update({
            'contacts': {
              currentUser!.uid: DateTime.now().millisecondsSinceEpoch
            },
          });
        } else {
          var contactTime = contactsMap[currentUser!.uid];
          var currentTime = DateTime.now().millisecondsSinceEpoch;
          if (currentTime - contactTime >= 2 * 60 * 60 * 1000) {
            await firebaseFirestore
                .collection(collectionUsers)
                .doc(receiverUid)
                .update({
              'contacts': {
                currentUser!.uid: DateTime.now().millisecondsSinceEpoch
              },
            });
          }
        }
      }
    } catch (e) {
      showSneckBar(context, 'Грубая ошибка - ${e.toString()}');
    }
  }

  like(context) async {
    try {
      var userSnapshot = await firebaseFirestore
          .collection(collectionUsers)
          .doc(receiverUid.value)
          .get();

      if (userSnapshot.exists) {
        var userData = userSnapshot.data();
        List<dynamic>? likedList = userData?['liked'] as List<dynamic>?;
        if (likedList == null || !likedList.contains(currentUser!.uid)) {
          likedList ??= [];
          likedList.add(currentUser!.uid);
          int likes = (userData?['likes'] ?? 0) + 1;
          await firebaseFirestore
              .collection(collectionUsers)
              .doc(receiverUid.value)
              .update({
            'liked': likedList,
            'likes': likes,
          });
          // await updateContact(context, receiverUid.value);
          return null;
        } else {
          likedList.remove(currentUser!.uid);
          int likes = (userData?['likes'] ?? 0) - 1;
          await firebaseFirestore
              .collection(collectionUsers)
              .doc(receiverUid.value)
              .update({
            'liked': likedList,
            'likes': likes,
          });
        }
      }
    } catch (e) {
      showSneckBar(context, 'Грубая ошибка - ${e.toString()}');
    }
  }

  getData() {
    String userGender = authController.userData.value.userGender.value;
    String userCity = authController.userData.value.userCity.value;
    int userAge = authController.userData.value.userAge.value;
    _liveStream = StoreServices.getAllUsers(userGender, userCity, userAge)
        .listen((QuerySnapshot usersDoc) {
      List<DocumentSnapshot> updatedUsers = [];

      for (var newUser in usersDoc.docs) {
        var contactsMap = newUser['contacts'] as Map<dynamic, dynamic>?;
        if (contactsMap == null || !contactsMap.containsKey(currentUser!.uid)) {
          updatedUsers.add(newUser);
        } else {
          var contactTime = contactsMap[currentUser!.uid];
          var currentTime = DateTime.now().millisecondsSinceEpoch;
          if (currentTime - contactTime >= 2 * 60 * 60 * 1000) {
            updatedUsers.add(newUser);
          }
        }
      }
      users.clear();
      users.addAll(updatedUsers);
      update();
    });
  }

  reload() {
    _liveStream?.cancel();
    getData();
  }

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  @override
  void onClose() {
    _liveStream?.cancel();
    super.onClose();
  }
}
