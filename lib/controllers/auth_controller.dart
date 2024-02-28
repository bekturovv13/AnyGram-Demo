import 'dart:async';
import 'dart:io';

import 'package:unicorn_app/consts/consts.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  final box = GetStorage();

  Rx<UserData> userData = UserData(
    userUid: ''.obs,
    userPhoto: ''.obs,
    userNumber: ''.obs,
    userName: ''.obs,
    userAge: 0.obs,
    userCity: ''.obs,
    userGender: ''.obs,
    userLikes: 0.obs,
    userMutual: 0.obs,
    userBio: ''.obs,
  ).obs;

  dynamic isSign;
  var phoneController = TextEditingController();
  var oldPhoneNumber = ''.obs;
  var nameController = TextEditingController();
  var ageController = TextEditingController();
  var cityController = TextEditingController();
  var genderController = TextEditingController();
  var bioController = TextEditingController();

  late List<String?> verificationCode;
  late List<TextEditingController?> otpControllers;

  var isloading = false.obs;

  late PhoneVerificationCompleted phoneVerificationCompleted;
  late PhoneVerificationFailed phoneVerificationFailed;
  late PhoneCodeSent phoneCodeSent;

  String _verificationID = '';
  int? _resendToken = 0;
  String otpCode = '';

  File? image;
  File? oldImagePth;
  var imagePath = ''.obs;

  // ------------------------------------------------------------------------

  String blockingPhone = '';
  String blockingFor = '';
  int? blocking2min = 0;
  int? blocking5min = 0;
  int secondsIn2minutes = 0;
  int secondsIn5minutes = 0;

  // ------------------------------------------------------------------------

  int resendCodeQuantity = 0;
  int invalidCodeQuantity = 0;

  var timer2Min = 120.obs;
  var timer5Min = 300.obs;
  var allTimer = 480.obs;

  var resendOTPSuccess = false.obs;
  var isResendAvailable = true.obs;
  var isAvailable = true.obs;
  var waitingInvalidCode = false.obs;
  var waitingResendCode = false.obs;
  var showInvalidCode = false.obs;
  var alreadyRequested = false.obs;

  String showBlocking = '';
  Timer? currentTimer2min;
  Timer? currentTimer5min;

  void increase(String increase) {
    if (increase == 'send') {
      resendCodeQuantity++;
      box.write('resendCodeQuantity', resendCodeQuantity);
    }
    if (increase == 'invalid') {
      invalidCodeQuantity++;
      box.write('invalidCodeQuantity', invalidCodeQuantity);
    }
  }

  void unableToRequest() {
    if (showBlocking == 'send') {
      waitingResendCode(true);
      Future.delayed(const Duration(seconds: 5), () {
        waitingResendCode(false);
      });
    }
    if (showBlocking == 'invalid') {
      waitingInvalidCode(true);
      Future.delayed(const Duration(seconds: 5), () {
        waitingInvalidCode(false);
      });
    }
    if (showBlocking == 'alreadyRequested') {
      alreadyRequested(true);
      Future.delayed(const Duration(seconds: 5), () {
        alreadyRequested(false);
      });
    }
    if (showBlocking == 'otpResend') {
      var singinController = Get.find<SinginController>();
      resendOTPSuccess(true);
      Future.delayed(const Duration(seconds: 20), () {
        int lastFilledIndex = otpControllers.lastIndexWhere((controller) {
          return controller != null && controller.text.isNotEmpty;
        });

        if (lastFilledIndex != -1) {
          singinController.otpFocusNodes[lastFilledIndex]!.requestFocus();
        } else {
          singinController.otpFocusNodes[0]!.requestFocus();
        }
        resendOTPSuccess(false);
      });
    }
  }

  void countdownTimer(int minutes, int seconds) {
    if (currentTimer5min != null && currentTimer5min!.isActive) {
      currentTimer5min!.cancel();
    }
    if (allTimer.value < 480) {
      allTimer.value = 480;
    } else {
      resetAllTimer();
    }
    if (minutes == 2) {
      isResendAvailable(false);
      currentTimer2min = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (seconds > 0) {
          seconds--;
          timer2Min.value = seconds;
        } else {
          timer.cancel();
          isResendAvailable(true);
          timer2Min.value = 120;
          if (resendCodeQuantity > 2) {
            manyAttempts('send');
          }
        }
      });
    }
    if (minutes == 5) {
      currentTimer5min = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (seconds > 0) {
          seconds--;
          timer5Min.value = seconds;
        } else {
          timer.cancel();
          counterReset();
        }
      });
    }
  }

  resetAllTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (allTimer > 0) {
        allTimer--;
      } else {
        timer.cancel();
        allTimer.value = 480;
        resendCodeQuantity = 0;
        invalidCodeQuantity = 0;
        box.write('resendCodeQuantity', 0);
        box.write('invalidCodeQuantity', 0);
        box.write('blocking2min', 0);
        box.write('blocking5min', 0);
      }
    });
  }

  void manyAttempts(actions) {
    countdownTimer(5, 300);
    if (actions == 'send') {
      showBlocking = 'send';
      saveBlocking(5, 'send');
    }
    if (actions == 'invalid') {
      Get.back();
      showBlocking = 'invalid';
      saveBlocking(5, 'invalid');
      unableToRequest();
    }
  }

  void counterReset() {
    if (currentTimer5min != null && currentTimer5min!.isActive) {
      currentTimer5min!.cancel();
    }
    if (currentTimer2min != null && currentTimer2min!.isActive) {
      currentTimer2min!.cancel();
    }
    timer5Min.value = 300;
    resendCodeQuantity = 0;
    invalidCodeQuantity = 0;
    box.write('resendCodeQuantity', 0);
    box.write('invalidCodeQuantity', 0);
    box.write('blocking2min', 0);
    box.write('blocking5min', 0);
  }

  void saveBlocking(int minutes, String actions) {
    DateTime currentTime = DateTime.now();
    late DateTime blocking2min;
    late DateTime blocking5min;
    late int milliseconds;
    if (minutes == 2) {
      blocking2min = currentTime.add(const Duration(minutes: 2));
      milliseconds = blocking2min.millisecondsSinceEpoch;
      box.write('blocking2min', milliseconds);
    }
    if (minutes == 5) {
      blocking5min = currentTime.add(const Duration(minutes: 5));
      milliseconds = blocking5min.millisecondsSinceEpoch;
      box.write('blocking5min', milliseconds);
      if (actions == 'send') {
        box.write('actions', actions);
      }
      if (actions == 'invalid') {
        box.write('actions', actions);
      }
    }
    box.write('phone', phoneController.text);
    box.write('blockingFor', actions);
  }

  @override
  void onInit() {
    _verificationID = box.read('verificationID') ?? '';
    _resendToken = box.read('resendToken') ?? 0;
    showBlocking = box.read('blockingFor') ?? '';
    blocking2min = box.read('blocking2min') ?? 0;
    blocking5min = box.read('blocking5min') ?? 0;
    blockingPhone = box.read('phone') ?? '';
    blockingFor = box.read('blockingFor') ?? '';
    int resendCount = box.read('resendCodeQuantity') ?? 0;
    int invalidCount = box.read('invalidCodeQuantity') ?? 0;
    int timeHasPassed = 0;
    secondsIn2minutes =
        ((blocking2min ?? 0) - DateTime.now().millisecondsSinceEpoch) ~/ 1000;
    secondsIn5minutes =
        ((blocking5min ?? 0) - DateTime.now().millisecondsSinceEpoch) ~/ 1000;
    timeHasPassed = secondsIn2minutes;
    secondsIn2minutes = secondsIn2minutes < 0 ? 0 : secondsIn2minutes;
    secondsIn5minutes = secondsIn5minutes < 0 ? 0 : secondsIn5minutes;

    if (timeHasPassed < -360) {
      counterReset();
      return;
    }

    if (blockingFor == 'send') {
      invalidCodeQuantity = invalidCount;
      if (secondsIn2minutes > 0) {
        resendCodeQuantity = resendCount;

        countdownTimer(2, secondsIn2minutes);
      } else {
        resendCodeQuantity = resendCount;
      }
      if (secondsIn5minutes > 0) {
        resendCodeQuantity = 3;
        countdownTimer(5, secondsIn5minutes);
      } else {
        resendCodeQuantity = resendCount;
      }
    }
    if (blockingFor == 'invalid') {
      resendCodeQuantity = resendCount;
      if (secondsIn5minutes > 0) {
        invalidCodeQuantity = 3;
        countdownTimer(5, secondsIn5minutes);
      } else {
        invalidCodeQuantity = invalidCount;
      }
    }
    super.onInit();
  }

  checkOnCondition(context) {
    var singinController = Get.find<SinginController>();
    if (AppStrings.phoneCodesKG
        .contains(phoneController.text.substring(0, 4).trim())) {
      if (isResendAvailable.value == true &&
          resendCodeQuantity < 3 &&
          invalidCodeQuantity < 3) {
        Future.delayed(const Duration(milliseconds: 200),
            () => singinController.checkNumber(true));
      } else if (isResendAvailable.value == false &&
          (blockingPhone == phoneController.text ||
              oldPhoneNumber.value == phoneController.text)) {
        Get.to(() => const OTPScreen(), transition: Transition.rightToLeft);
      } else if (isResendAvailable.value == false &&
          (blockingPhone != phoneController.text ||
              oldPhoneNumber.value != phoneController.text)) {
        showBlocking = 'alreadyRequested';
        unableToRequest();
      } else if (resendCodeQuantity > 2 || invalidCodeQuantity > 2) {
        unableToRequest();
      }
    } else {
      showSneckBar(context, AppStrings.wrongPhoneNumber);
      singinController.phonefocusNode.value.requestFocus();
    }
  }

  invalidCode() {
    showInvalidCode(true);
    Future.delayed(const Duration(seconds: 1), () {
      showInvalidCode(false);
    });
  }

  // ------------------------------------------------------------------------

  setSignIn() {
    box.write('singIn', true);
  }

  checkSing() async {
    isSign = box.read('singIn') ?? false;
    if (isSign) {
      await getUserData();
      Get.offAll(() => const Home(), transition: Transition.rightToLeft);
    } else {
      Get.offAll(() => const LoginScreen(), transition: Transition.rightToLeft);
    }
  }

  checkExistingUser() async {
    var snapshot = await firebaseFirestore
        .collection(collectionUsers)
        .doc(currentUser!.uid)
        .get();
    if (snapshot.exists) {
      return true;
    } else {
      return false;
    }
  }

  sendingFunction(context, type) async {
    var singinController = Get.find<SinginController>();
    singinController.checkNumber(false);
    increase('send');
    countdownTimer(2, 120);
    saveBlocking(2, 'send');
    if (type == 'send') {
      isloading(true);
    }

    try {
      final phone = phoneController.text.replaceAll(' ', '');
      oldPhoneNumber.value = phoneController.text;
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: '+996$phone',
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          await firebaseAuth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (error) {
          showSneckBar(
              context, "Ошибка верификации телефона: ${error.message}");
          throw Exception(error.message);
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationID = verificationId;
          _resendToken = resendToken;
          if (type == 'resend') {
            showBlocking = 'otpResend';
            unableToRequest();
          }
          box.write('verificationID', verificationId);
          box.write('resendToken', resendToken);
          if (type == 'send') {
            Get.to(() => const OTPScreen(), transition: Transition.rightToLeft);
            isloading(false);
            Future.delayed(const Duration(milliseconds: 500), () {
              var singinController = Get.find<SinginController>();
              singinController.otpFocusNodes[0]!.requestFocus();
            });
          }
        },
        forceResendingToken: _resendToken,
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } catch (e) {
      if (type == 'send') {
        isloading(false);
        showSneckBar(context, "Ошибка при отправке SMS: ${e.toString()}");
      } else if (type == 'resend') {
        showSneckBar(
            context, "Ошибка при повторной отправке SMS: ${e.toString()}");
      }
    }
  }

  verificationFunction(context) async {
    try {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: _verificationID,
        smsCode: otpCode,
      );

      UserCredential userCredential =
          await firebaseAuth.signInWithCredential(phoneAuthCredential);
      isloading(true);
      User? user = userCredential.user;

      if (user != null) {
        counterReset();
        final userExists = await checkExistingUser();
        if (userExists) {
          await getUserData();
          await setSignIn();
          isloading(false);
          Get.offAll(() => const Home(), transition: Transition.rightToLeft);
        } else {
          isloading(false);
          Get.offAll(() => const CreateUser(),
              transition: Transition.rightToLeft);
        }
      } else {
        isloading(false);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        increase('invalid');
        var singinController = Get.find<SinginController>();
        singinController.otpFocusNodes[5]!.requestFocus();
        invalidCode();
        if (invalidCodeQuantity >= 3) {
          manyAttempts('invalid');
        }
      } else {
        showSneckBar(context, "Ошибка в разделе verificationFunction() - $e");
      }
    }
  }

  String formatTime(int seconds) {
    int minutes = (seconds ~/ 60);
    int remainingSeconds = seconds % 60;
    String minutesStr = (minutes < 10) ? '0$minutes' : '$minutes';
    String secondsStr =
        (remainingSeconds < 10) ? '0$remainingSeconds' : '$remainingSeconds';
    return '$minutesStr:$secondsStr';
  }

  Future<void> getImageGallery() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      imagePath.value = File(pickedFile.path).toString();
    } else {
      imagePath.value = '';
    }
  }

  Future<int> getDominantColor(File image) async {
    var paletteGenerator = await PaletteGenerator.fromImageProvider(
      FileImage(image),
    );
    Color dominantColor = paletteGenerator.dominantColor!.color;
    return dominantColor.value;
  }

  uploadImage(String ref, File file) async {
    UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    var imageLink = await snapshot.ref.getDownloadURL();
    return imageLink;
  }

  createUserDataCheck(context) {
    int? age = int.tryParse(ageController.text.trim());
    if (bioController.text.isEmpty) {
      bioController.text = '';
    }
    if (genderController.text.trim().isEmpty) {
      genderController.text = 'Мужчина';
    }
    if (nameController.text.trim().length >= 4 &&
        age != null &&
        age >= 14 &&
        cityController.text.isNotEmpty &&
        image != null) {
      createUser(context);
    } else {
      if (nameController.text.trim().length < 4) {
        showSneckBar(context, AppStrings.nameWarning);
      } else if (age == null || age < 14) {
        showSneckBar(context, AppStrings.ageWarning);
      } else if (cityController.text.isEmpty) {
        showSneckBar(context, AppStrings.citySelectionWarning);
      } else if (genderController.text.trim().isEmpty) {
        showSneckBar(context, AppStrings.genderSelectionWarning);
      } else if (image == null) {
        showSneckBar(context, AppStrings.photoWarning);
      }
    }
  }

  createUser(context) async {
    isloading(true);
    final phone = phoneController.text.replaceAll(' ', '');
    int age = int.tryParse(ageController.text) ?? 0;

    try {
      var newUserPick = '';
      if (imagePath.isNotEmpty) {
        newUserPick = await uploadImage('Users/${currentUser!.uid}/', image!);
      }

      await firebaseFirestore
          .collection(collectionUsers)
          .doc(currentUser!.uid)
          .set({
        'uid': currentUser!.uid,
        'photo': newUserPick,
        'number': '+996$phone',
        'name': nameController.text,
        'age': age,
        'city': cityController.text,
        'gender': genderController.text,
        'likes': 0,
        'mutual': 0,
        'liked': [],
        'bio': bioController.text,
        'isOnline': false,
        'lastActive': DateTime.now().millisecondsSinceEpoch.toString(),
        'pushToken': '',
        'contacts': {},
      }, SetOptions(merge: true)).then((_) async {
        await getUserData();
        await setSignIn();
        await Get.offAll(() => const Home(),
            transition: Transition.rightToLeft);
        isloading(false);
      });
    } on FirebaseException catch (e) {
      isloading(false);
      showSneckBar(context, e.message.toString());
    }
  }

  updateUserData(context) async {
    isloading(true);
    int? age = int.tryParse(ageController.text.trim());

    try {
      var store =
          firebaseFirestore.collection(collectionUsers).doc(currentUser!.uid);

      await firebaseFirestore
          .collection(collectionUsers)
          .where('uid', isEqualTo: currentUser!.uid)
          .get()
          .then((value) async {
        bool updated = false;

        if (value.docs[0]['name'] != nameController.text.trim()) {
          store.update({'name': nameController.text.trim()});
          updated = true;
        }
        if (value.docs[0]['age'] != age) {
          store.update({'age': age});
          updated = true;
        }
        if (value.docs[0]['city'] != cityController.text.trim()) {
          store.update({'city': cityController.text.trim()});
          updated = true;
        }
        if (value.docs[0]['bio'] != bioController.text.trim()) {
          store.update({'bio': bioController.text.trim()});
          updated = true;
        }
        if (image != null && image != oldImagePth) {
          String oldImageUrl = value.docs[0]['photo'];

          String imageUrl =
              await uploadImage('Users/${currentUser!.uid}/', image!);

          oldImagePth = image;

          if (imageUrl.isNotEmpty && value.docs[0]['photo'] != imageUrl) {
            store.update({'photo': imageUrl});
            updated = true;
            CachedNetworkImage.evictFromCache(oldImageUrl);
          }
        }

        isloading(false);
        if (updated) {
          await getDataFirestore();
          showSneckBar(context, AppStrings.succesUpdateProfile);
        }
      });
    } on FirebaseException catch (e) {
      isloading(false);
      showSneckBar(context, e.message.toString());
    }
  }

  //
  getUserData() async {
    var userDataFromStorage = box.read<Map<String, dynamic>>(currentUser!.uid);
    if (userDataFromStorage != null) {
      userData.value = _mapUserDataFromStorage(userDataFromStorage);
    } else {
      await getDataFirestore();
    }
  }

  UserData _mapUserDataFromStorage(Map<String, dynamic>? userDataFromStorage) {
    if (userDataFromStorage == null) {
      // Возвращаем пустой объект UserData
      return UserData(
        userUid: ''.obs,
        userPhoto: ''.obs,
        userNumber: ''.obs,
        userName: ''.obs,
        userAge: 0.obs,
        userCity: ''.obs,
        userGender: ''.obs,
        userLikes: 0.obs,
        userMutual: 0.obs,
        userBio: ''.obs,
      );
    }

    return UserData(
      userUid: (userDataFromStorage['userUid']?.toString() ?? '').obs,
      userPhoto: (userDataFromStorage['userPhoto']?.toString() ?? '').obs,
      userNumber: (userDataFromStorage['userNumber']?.toString() ?? '').obs,
      userName: (userDataFromStorage['userName']?.toString() ?? '').obs,
      userAge: int.parse(userDataFromStorage['userAge']?.toString() ?? '0').obs,
      userCity: (userDataFromStorage['userCity']?.toString() ?? '').obs,
      userGender: (userDataFromStorage['userGender']?.toString() ?? '').obs,
      userLikes:
          int.parse(userDataFromStorage['userLikes']?.toString() ?? '0').obs,
      userMutual:
          int.parse(userDataFromStorage['userMutual']?.toString() ?? '0').obs,
      userBio: (userDataFromStorage['userBio']?.toString() ?? '').obs,
    );
  }

  //
  Future<void> getDataFirestore() async {
    try {
      var userSnapshot = await firebaseFirestore
          .collection(collectionUsers)
          .where('uid', isEqualTo: currentUser!.uid)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        var userDataFromFirestore = userSnapshot.docs[0].data();
        // Обновляем данные в объекте UserData
        userData.value = UserData(
          userUid: RxString(userDataFromFirestore['uid'] ?? ''),
          userPhoto: RxString(userDataFromFirestore['photo'] ?? ''),
          userNumber: RxString(userDataFromFirestore['number'] ?? ''),
          userName: RxString(userDataFromFirestore['name'] ?? ''),
          userAge: RxInt(userDataFromFirestore['age'] ?? 0),
          userCity: RxString(userDataFromFirestore['city'] ?? ''),
          userGender: RxString(userDataFromFirestore['gender'] ?? ''),
          userLikes: RxInt(userDataFromFirestore['likes'] ?? 0),
          userMutual: RxInt(userDataFromFirestore['mutual'] ?? 0),
          userBio: RxString(userDataFromFirestore['bio'] ?? ''),
        );
        // Сохраняем обновленные данные в GetStorage
        saveUserDataToStorage();
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error getting user data: $e");
    }
  }

  //
  saveUserDataToStorage() {
    box.write(currentUser!.uid, {
      'userUid': userData.value.userUid.value,
      'userPhoto': userData.value.userPhoto.value,
      'userNumber': userData.value.userNumber.value,
      'userName': userData.value.userName.value,
      'userAge': userData.value.userAge.value.toString(),
      'userCity': userData.value.userCity.value,
      'userGender': userData.value.userGender.value,
      'userLikes': userData.value.userLikes.value.toString(),
      'userMutual': userData.value.userMutual.value.toString(),
      'userBio': userData.value.userBio.value,
    });
  }

  // Задать активность пользователя
  Future<void> updateUserStatus(active) async {
    if (active == true) {
      await firebaseFirestore
          .collection(collectionUsers)
          .doc(currentUser!.uid)
          .update({
        'isOnline': true,
        'lastActive': DateTime.now().millisecondsSinceEpoch.toString(),
      });
    } else {
      await firebaseFirestore
          .collection(collectionUsers)
          .doc(currentUser!.uid)
          .update({
        'isOnline': false,
        'lastActive': DateTime.now().millisecondsSinceEpoch.toString(),
      });
    }
  }

  // Выйти из аккаунта и Firebase
  userSingOut() async {
    Get.delete<LiveController>();
    Get.delete<ChatsController>();
    await updateUserStatus(false);
    isloading(false);
    await box.erase();
    await firebaseAuth.signOut();
  }
}
