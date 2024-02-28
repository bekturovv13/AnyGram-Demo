import 'package:unicorn_app/consts/consts.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({
    super.key,
  });
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  var liveController = Get.find<LiveController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: GestureDetector(
          onVerticalDragUpdate: (DragUpdateDetails details) {
            liveController.delta.value += details.primaryDelta!;
          },
          onVerticalDragEnd: (DragEndDetails details) {
            if (liveController.delta.value > 10) {
              Get.back();
              Future.delayed(const Duration(milliseconds: 300),
                  () => liveController.deskcriptionButtons(true));
            }
            liveController.delta.value = 0.0;
          },
          child: Hero(
            tag: liveController.receiverPhoto.value,
            child: Image.network(
              liveController.receiverPhoto.value,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
