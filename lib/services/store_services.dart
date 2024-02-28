import 'package:unicorn_app/consts/consts.dart';

class StoreServices {
  static getMessages(String chatId) {
    return firebaseFirestore
        .collection(collectionChats)
        .doc(chatId)
        .collection(collectionMessages)
        .orderBy('created_at', descending: false)
        .snapshots();
  }

  static getUserData(receiverUid) {
    if (receiverUid != null) {
      return firebaseFirestore
          .collection(collectionUsers)
          .where('uid', isEqualTo: receiverUid)
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs.first);
    } else {
      return const Stream.empty();
    }
  }

  static getAllUsers(
    String userGender,
    String userCity,
    int userAge,
  ) {
    if (currentUser != null) {
      if (userGender == "Мужчина") {
        var minAge = userAge - 5;
        var maxAge = userAge + 1;
        return firebaseFirestore
            .collection(collectionUsers)
            .where('city', isEqualTo: userCity)
            .where('gender', isEqualTo: 'Женщина')
            .where('age', isGreaterThanOrEqualTo: minAge)
            .where('age', isLessThanOrEqualTo: maxAge)
            .snapshots();
      } else if (userGender == "Женщина") {
        var minAge = userAge - 1;
        var maxAge = userAge + 5;
        return firebaseFirestore
            .collection(collectionUsers)
            .where('city', isEqualTo: userCity)
            .where('gender', isEqualTo: 'Мужчина')
            .where('age', isGreaterThanOrEqualTo: minAge)
            .where('age', isLessThanOrEqualTo: maxAge)
            .snapshots();
      }
    } else {
      return const Stream.empty();
    }
  }

  static getChats() {
    return firebaseFirestore.collection(collectionChats).snapshots();
  }
}
