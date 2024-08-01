import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storesalephone/MyAppScreen.dart';
import 'build_images.dart';

class PageOnBorarding extends StatelessWidget {
  const PageOnBorarding({super.key});

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage('assets/h1.jpg'), context);
    precacheImage(const AssetImage('assets/h2.jpg'), context);
    precacheImage(const AssetImage('assets/h3.jpg'), context);
    precacheImage(const AssetImage('assets/h4.jpg'), context);

    return Scaffold(
      body: IntroductionScreen(
        pages: [
          PageViewModel(
            title: 'Chào mừng',
            body:
                'Chúng tôi rất vui mừng được đồng hành cùng bạn trong hành trình khám phá và trải nghiệm thế giới công nghệ tiên tiến.',
            image: const BuildImages(image: 'assets/h1.jpg'),
            decoration: getPageDecoration(),
          ),
          PageViewModel(
            title: 'Đa dạng sản phẩm',
            body:
                'Chúng tôi cung cấp một loạt các sản phẩm từ các thương hiệu hàng đầu thế giới, bao gồm điện thoại thông minh, máy tính bảng, phụ kiện và nhiều hơn nữa. Bạn có thể dễ dàng tìm thấy sản phẩm phù hợp với nhu cầu và ngân sách của mình.',
            image: const BuildImages(image: 'assets/h2.jpg'),
            decoration: getPageDecoration(),
          ),
          PageViewModel(
            title: 'Thanh toán an toàn và linh hoạt',
            body:
                'Chúng tôi cung cấp nhiều phương thức thanh toán an toàn và linh hoạt như thẻ tín dụng, ví điện tử, chuyển khoản ngân hàng và thanh toán khi nhận hàng. Bạn hoàn toàn có thể yên tâm khi thực hiện giao dịch trên ứng dụng của chúng tôi.',
            image: const BuildImages(image: 'assets/h3.jpg'),
            decoration: getPageDecoration(),
          ),
          PageViewModel(
            title: 'Ưu đãi hấp dẫn',
            body:
                'Chúng tôi thường xuyên cập nhật các chương trình khuyến mãi, giảm giá và quà tặng hấp dẫn dành cho khách hàng. Hãy theo dõi ứng dụng của chúng tôi để không bỏ lỡ bất kỳ ưu đãi nào nhé!',
            image: const BuildImages(image: 'assets/h4.jpg'),
          ),
        ],
        next: const Icon(
          Icons.arrow_forward,
          size: 30,
        ),
        done: const Text('Bắt đầu',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        onDone: () => goToHome(context),
        showSkipButton: true,
        skip: const Text('Bỏ qua',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        dotsDecorator: getDotDecoration(),
        nextFlex: 0,
        skipOrBackFlex: 0,
        animationDuration: 500,
        isProgressTap: true,
        isProgress: true,
        onChange: (index) => print(index),
      ),
    );
  }

  PageDecoration getPageDecoration() {
    return const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
      bodyTextStyle: TextStyle(fontSize: 20),
      imagePadding: EdgeInsets.all(24),
      titlePadding: EdgeInsets.zero,
      bodyPadding: EdgeInsets.all(20),
      pageColor: Colors.white,
    );
  }

  DotsDecorator getDotDecoration() {
    return DotsDecorator(
      color: const Color(0xFFBDBDBD),
      size: const Size(10, 10),
      activeSize: const Size(22, 10),
      activeColor: Colors.orange,
      activeShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    );
  }

  void goToHome(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnBoarding', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyAppScreen()),
    );
  }
}
