import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:wine_app/module/home/main_container_page.dart';

class InfoPage extends StatelessWidget {
  List<PageViewModel> getPages(){
    return [
      PageViewModel(
        image: Image.network('https://raw.githubusercontent.com/duongplus/wine-images/master/BRONZE.png',
        ),
        title: 'Hội viên Đồng',
        body: 'Mức ưu đãi của bậc hội viên này trên mỗi hóa đơn thanh toán được giảm 0%',
        footer: Text('\"Điểm tích lũy dưới 250 điểm sẽ được tính là hội viên Đồng. Cứ mỗi 100,000vnđ trên'
            '1 hóa đơn sẽ được tính là 1 điểm.\"'),
      ),
      PageViewModel(
        image: Image.network('https://raw.githubusercontent.com/duongplus/wine-images/master/Silver.png',
        ),
        title: 'Hội viên Bạc',
        body: 'Mức ưu đãi của bậc hội viên này trên mỗi hóa đơn thanh toán được giảm 10%',
        footer: Text('\"Điểm tích lũy dưới 500 điểm sẽ được tính là hội viên Bạc. Cứ mỗi 100,000vnđ trên'
            '1 hóa đơn sẽ được tính là 1 điểm.\"'),
      ),
      PageViewModel(
        image: Image.network('https://raw.githubusercontent.com/duongplus/wine-images/master/GOLD.png',
        ),
        title: 'Hội viên Vàng',
        body: 'Mức ưu đãi của bậc hội viên này trên mỗi hóa đơn thanh toán được giảm 15%',
        footer: Text('\"Điểm tích lũy dưới 1000 điểm sẽ được tính là hội viên Vàng. Cứ mỗi 100,000vnđ trên'
            '1 hóa đơn sẽ được tính là 1 điểm.\"'),
      ),
      PageViewModel(
        image: Image.network('https://raw.githubusercontent.com/duongplus/wine-images/master/Diamond.png',
        ),
        title: 'Hội viên Kim Cương',
        body: 'Mức ưu đãi của bậc hội viên này trên mỗi hóa đơn thanh toán được giảm 20%',
        footer: Text('\"Điểm tích lũy từ 1000 điểm trở lên sẽ được tính là hội viên Kim Cương. Cứ mỗi 100,000vnđ trên'
            '1 hóa đơn sẽ được tính là 1 điểm.\"'),
      )
    ];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: IntroductionScreen(
        done: Container(
          padding: EdgeInsets.only(top: 5, bottom: 5, left: 2, right: 2),
          decoration: BoxDecoration(
            color: Colors.lightBlueAccent,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            'Điểm của tôi',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        onDone: (){
          HomeContainerPage.pagecontroller.jumpToPage(2);
        },
        pages: getPages(),
        globalBackgroundColor: Colors.white,
      ),
    );
  }
}
