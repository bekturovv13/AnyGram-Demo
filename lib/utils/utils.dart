import 'package:unicorn_app/consts/consts.dart';

void showSneckBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}
