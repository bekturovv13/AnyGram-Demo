// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:unicorn_app/consts/firebase_consts.dart';

// class HomeController extends GetxController {
//   late SharedPreferences sharedPreferences;

//   String userUid = '';
//   String userPhoto = '';
//   String userNumber = '';
//   String userName = '';
//   int userAge = 0;
//   String userCity = '';
//   String userGender = '';
//   int userLikes = 0;
//   int userMutual = 0;
//   String userBio = '';

//   getUserData() async {
//     await firebaseFirestore
//         .collection(collectionUsers)
//         .where('uid', isEqualTo: currentUser!.uid)
//         .get()
//         .then(
//       (value) async {
//         userUid = value.docs[0]['uid'];
//         userPhoto = value.docs[0]['photoURL'];
//         userNumber = value.docs[0]['phoneNumber'];
//         userName = value.docs[0]['displayName'];
//         userAge = value.docs[0]['age'];
//         userCity = value.docs[0]['city'];
//         userGender = value.docs[0]['gender'];
//         userLikes = value.docs[0]['likes'];
//         userMutual = value.docs[0]['mutual'];
//         userBio = value.docs[0]['bio'];

//         // Используйте GetStorage для сохранения данных
//         final box = GetStorage();
//         box.write('USER', [
//           value.docs[0]['uid'],
//           value.docs[0]['photoURL'],
//           value.docs[0]['phoneNumber'],
//           value.docs[0]['displayName'],
//           value.docs[0]['age'].toString(),
//           value.docs[0]['city'],
//           value.docs[0]['gender'],
//           value.docs[0]['likes'].toString(),
//           value.docs[0]['mutual'].toString(),
//           value.docs[0]['bio'],
//         ]);
//       },
//     );
//   }
// }
