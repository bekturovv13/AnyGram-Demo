import 'package:unicorn_app/consts/consts.dart';

class SinginController extends GetxController {
  var authController = Get.find<AuthController>();
  var checkNumber = false.obs;

  Rx<FocusNode> phonefocusNode = FocusNode().obs;
  RxList<FocusNode?> otpFocusNodes = <FocusNode?>[].obs;

  check() {
    checkNumber.value = !checkNumber.value;
  }

  void handleButtonPress(context, String button) {
    int targetIndex = -1;
    String targetValue = '';

    switch (button) {
      case '1':
      case '2':
      case '3':
      case '4':
      case '5':
      case '6':
      case '7':
      case '8':
      case '9':
      case '0':
        targetValue = button;
        break;

      case 'backspace':
        targetIndex = findLastFilledIndex();
        break;

      default:
        break;
    }

    if (targetIndex != -1) {
      authController.otpControllers[targetIndex]?.text = '';
      authController.verificationCode[targetIndex] = null;
      changeFocusToPreviousNodeWhenValueIsRemoved(
        context: context,
        value: targetValue,
        indexOfTextField: targetIndex,
      );
    } else {
      for (int i = 0; i < authController.otpControllers.length; i++) {
        if (authController.otpControllers[i]?.text.isEmpty == true) {
          authController.otpControllers[i]?.text = targetValue;
          authController.verificationCode[i] = targetValue;
          changeFocusToNextNodeWhenValueIsEntered(
            value: targetValue,
            indexOfTextField: i,
            context: context,
          );
          break;
        }
      }
    }
  }

  String removeLastDigit(String input) {
    if (input.isEmpty) {
      return '';
    }
    int lastNonSpaceIndex = input.length - 1;
    while (lastNonSpaceIndex >= 0 && input[lastNonSpaceIndex] == ' ') {
      lastNonSpaceIndex--;
    }
    String result = input.substring(0, lastNonSpaceIndex);
    return result;
  }

  // String formatPhoneNumber(String input) {
  //   String cleanedInput = input.replaceAll(' ', '');
  //   String formattedNumber = '';
  //   for (int i = 0; i < cleanedInput.length; i++) {
  //     formattedNumber += cleanedInput[i];
  //     if ((i + 1) % 2 == 0 && i + 1 != cleanedInput.length) {
  //       formattedNumber += ' ';
  //     }
  //   }
  //   return formattedNumber;
  // }

  void onSubmit({
    required context,
    required List<String?> verificationCode,
  }) {
    if (verificationCode.every((String? code) => code != null && code != '')) {
      authController.otpCode = verificationCode.join();
      Future.delayed(const Duration(milliseconds: 300), () {
        authController.verificationFunction(context);
      });
    }
  }

  void changeFocusToNextNodeWhenValueIsEntered({
    required context,
    required String value,
    required int indexOfTextField,
  }) {
    if (value.isNotEmpty) {
      if (indexOfTextField + 1 != 6) {
        FocusScope.of(context)
            .requestFocus(otpFocusNodes[indexOfTextField + 1]);
      } else {
        otpFocusNodes[indexOfTextField]?.unfocus();
        if (authController.verificationCode
            .every((String? code) => code != null && code != '')) {
          onSubmit(
              context: context,
              verificationCode: authController.verificationCode);
        }
      }
    }
  }

  void changeFocusToPreviousNodeWhenValueIsRemoved({
    required context,
    required String value,
    required int indexOfTextField,
  }) {
    if (value.isEmpty) {
      if (indexOfTextField != 0) {
        FocusScope.of(context).requestFocus(otpFocusNodes[indexOfTextField]);
      } else {
        FocusScope.of(context).requestFocus(otpFocusNodes[0]);
      }
    }
  }

  int findLastFilledIndex() {
    for (int i = authController.otpControllers.length - 1; i >= 0; i--) {
      if (authController.otpControllers[i]?.text.isNotEmpty == true) {
        return i;
      }
    }
    return -1;
  }

  String formatTime(int seconds) {
    int minutes = (seconds ~/ 60);
    int remainingSeconds = seconds % 60;
    String minutesStr = (minutes < 10) ? '0$minutes' : '$minutes';
    String secondsStr =
        (remainingSeconds < 10) ? '0$remainingSeconds' : '$remainingSeconds';
    return '$minutesStr:$secondsStr';
  }
}
