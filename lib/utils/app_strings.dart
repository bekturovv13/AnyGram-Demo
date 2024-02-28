import 'package:unicorn_app/consts/consts.dart';

var authController = Get.find<AuthController>();

class AppStrings {
  static const String appNameLower = 'Unicorn';
  static const String appNameUpper = 'UNICORN';
  static const String hello = 'Привет,';
  static const String examination = 'ПРОВЕРКА';

  //
  static const String liveTitle = 'Давай искать друзей';
  static const String nextButton = 'Дальше';
  static const String beginButton = 'Начать';
  static const String completeButton = 'Завершить';
  static const String saveButton = 'Сохранить';
  static const String likes = 'Нравится';
  static const String mutual = 'Взаимных';
  static const String welcomeTitle = 'ДОБРО\nПОЖАЛОВАТЬ';
  static String alreadyRequested =
      'Запрошен SMS-код для номера\n+996 ${authController.blockingPhone}, ожидайте.';
  static const String resendingOTPSuccess =
      'Мы повторно отправили код подтверждения на ваш номер телефона. Пожалуйста, проверьте SMS в течение нескольких минут. Если вы по-прежнему не получили код, убедитесь, что ваш номер телефона введен корректно, и ожидайте с удовольствием! Если проблема повторится, обратитесь в нашу службу поддержки.';
  static const String welcomeSubTitle =
      'Погрузимся в увлекательное виртуальное путешествие.';
  static const String manyInvalidCode =
      'Превышено допустимое количество ошибок при вводе кода. Пожалуйста, повторите попытку через';
  static const String waitingRequest =
      'Превышено количество запросов кода. Пожалуйста, повторите попытку через';
  static const String sendMessage = 'Отправить сообщение';
  //
  //
  static const String countryTitle = 'Кыргызстан (KG) +996';
  static const String succesUpdateProfile = 'Данные успешно обновлены';
  //
  static const String labelPhoneNumder = ' Номер телефона';
  static const String reglabelName = 'Как вас зовут?';
  static const String reglabelAge = 'Сколько вам лет?';
  static const String reglabelCity = 'От куда вы?';
  static const String reglabelGender = 'Теперь определимся полом';
  static const String reglabelAboutMe = 'Немного о вас';
  static const String textAboutMe =
      'Поделитесь секретом о себе, который никто еще не знает. Обещаю, хранить его как самое ценное сокровище.';
  static const String forAboutMe =
      'Заполните раздел "О себе", Расскажите о себе! Ваша уникальность — ключ к интересным встречам.';

  static const String usersAboutMe =
      'Пользователь еще не поделился информацией о себе.';

  //
  //
  static const String photoWarning =
      'Пожалуйста, загрузите ваше фото, нажав на иконку для загрузки.';
  static const String nameWarning =
      'Пожалуйста, укажите ваше имя, заполнив соответствующее поле (не менее 4 символов).';
  static const String ageWarning =
      'Пожалуйста, укажите ваш возраст, заполнив соответствующее поле (не менее 14 лет).';
  static const String citySelectionWarning =
      'Пожалуйста, выберите ваш город из предложенных вариантов.';
  static const String genderSelectionWarning =
      'Пожалуйста, укажите ваш пол, выбрав соответствующий вариант.';
  //
  //
  static const String requestNumber =
      'Введите номер телефона, исключая ведущий\n0 и код страны';
  static const String wrongPhoneNumber =
      'Неправильный формат номера. Пожалуйста, проверьте введенный номер и попробуйте снова.';
  static const String textGetPhoneNumber =
      'Пожалуйста, введите номер телефона или проверьте введенный номер и попробуйте снова.';
  //
  //
  static const String errorGetPhoneNumber = 'Ошибка: Номер телефона не получен';
  static const String textCod = 'КОД';
  static const String otpLabel =
      'Введите одноразовый код, отправленный на номер';
  static const String otpGetText =
      'Пожалуйста, введите шестизначный код из сообщения.';
  static const String otpCheckButton = 'Проверить';
  //
  static const String completeRegistrationText =
      'Чтобы успешно завершить регистрацию, заполните необходимую информацию.';
  //
  //
  //
  //
  //
  static List<String> phoneCodesKG = [
    //O      B      M
    '500', '220', '550',
    '501', '221', '551',
    '502', '222', '552',
    '503', '223', '553',
    '504', '224', '554',
    '505', '225', '555',
    '507', '226', '556',
    '508', '227', '557',
    '509', '228', '558',
    '700', '770', '559',
    '701', '771', '755',
    '702', '772', '990',
    '703', '773', '995',
    '704', '774', '997',
    '705', '775', '998',
    '706', '776', '999',
    '707', '777',
    '708', '778',
    '709', '779',
    //
    //Коды для теста
    '111',
    '333',
    '444',
    //
  ];

  static List<String> cities = [
    'Баткен',
    'Бишкек',
    'Жалал-Абад',
    'Наарын',
    'Ош',
    'Талас',
    'Ыссык-Кол'
  ];

  static List<String> gender = [
    'Мужчина',
    'Женщина',
  ];
}
