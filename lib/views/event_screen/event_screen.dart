import 'package:unicorn_app/consts/consts.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  double deskcriptionScreen = 0;
  double bottom = -400;
  bool upp = true;

  up() {
    setState(() {
      bottom = -50;
    });
  }

  down() {
    setState(() {
      bottom = -400;
      upp = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          if (upp) {
            bottom > -401 ? bottom -= (details.delta.dy / 10) : bottom = -400;
          }
          if (!upp) {
            bottom <= -50 ? bottom -= (details.delta.dy / 10) : bottom = -50;
          }
        });
      },
      onPanEnd: (details) {
        if (upp) {
          if (bottom > -380) {
            up();
            upp = false;
          } else {
            down();
          }
        }
        if (!upp) {
          if (bottom < -70) {
            down();
          } else {
            up();
            upp = false;
          }
        }
      },
      child: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Center(
              child: Container(
                color: Colors.black,
                width: 200,
                height: 400,
                child: Column(
                  children: [
                    Container(
                      color: Colors.red,
                      width: 200,
                      height: 200,
                    ),
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
              curve: Curves.easeOutCirc,
              duration: const Duration(milliseconds: 500),
              left: 0,
              right: 0,
              bottom: bottom,
              child: Container(
                color: Colors.blue,
                width: 200,
                height: 400,
              ),
            )
          ],
        ),
      ),
    );
  }
}
