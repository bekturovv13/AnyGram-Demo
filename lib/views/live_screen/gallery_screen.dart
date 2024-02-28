import 'package:unicorn_app/consts/consts.dart';

class GalleryScreen extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final int index;
  const GalleryScreen({
    super.key,
    required this.items,
    required this.index,
  });
  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  var liveController = Get.find<LiveController>();

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredItems =
        widget.items.where((user) => user['visible'] == true).toList();
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 42.w),
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 22.w, right: 22.w),
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    color: Colors.transparent,
                    height: 40.w,
                    width: 40.w,
                    padding: EdgeInsets.all(8.w),
                    child: SvgPicture.asset(
                      'assets/icons/icon_left_white.svg',
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 40.w,
                  padding: EdgeInsets.all(8.w),
                  child: Text(
                    liveController.receiverName.value,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.w),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 474.h,
            child: CarouselSlider(
              options: CarouselOptions(
                initialPage: liveController.current.value,
                height: MediaQuery.of(context).size.height,
                viewportFraction: 1,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    liveController.current.value = index;
                  });
                },
              ),
              items: filteredItems.map((user) {
                return Builder(
                  builder: (BuildContext context) {
                    return Column(
                      children: [
                        Container(
                          height: 12.h,
                          padding: EdgeInsets.symmetric(horizontal: 30.w),
                          child: Text(
                            '26 Июля 2023',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(horizontal: 15.w),
                          height: 440.h,
                          child: Hero(
                            tag: user['photo'],
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.r)),
                              child: Image.network(
                                user['photo'],
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 20.w),
          CustomIndicator(
            indicatorCount: filteredItems.length,
            index: liveController.current.value,
          ),
        ],
      ),
    );
  }
}

class CustomIndicator extends StatefulWidget {
  final int indicatorCount;
  final int index;
  const CustomIndicator({
    super.key,
    required this.indicatorCount,
    required this.index,
  });

  @override
  State<CustomIndicator> createState() => _CustomIndicatorState();
}

class _CustomIndicatorState extends State<CustomIndicator> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.indicatorCount,
        (index) => Container(
          margin: EdgeInsets.symmetric(horizontal: 2.w),
          width: 12.w,
          height: 12.w,
          alignment: Alignment.center,
          child: AnimatedContainer(
            duration: index == widget.index
                ? const Duration(milliseconds: 400)
                : const Duration(milliseconds: 200),
            width: index == widget.index ? 7.w : 5.w,
            height: index == widget.index ? 7.w : 5.w,
            decoration: BoxDecoration(
              color: index == widget.index
                  ? Colors.white
                  : const Color(0xFF606060),
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
        ),
      ),
    );
  }
}
