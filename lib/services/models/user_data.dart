import 'package:unicorn_app/consts/consts.dart';

class UserData {
  late RxString userUid;
  late RxString userPhoto;
  late RxString userNumber;
  late RxString userName;
  late RxInt userAge;
  late RxString userCity;
  late RxString userGender;
  late RxInt userLikes;
  late RxInt userMutual;
  late RxString userBio;

  UserData({
    required this.userUid,
    required this.userPhoto,
    required this.userNumber,
    required this.userName,
    required this.userAge,
    required this.userCity,
    required this.userGender,
    required this.userLikes,
    required this.userMutual,
    required this.userBio,
  });
}
