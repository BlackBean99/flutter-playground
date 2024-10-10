import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toss_gift_card_interaction/gift_card_page.dart';

class GiftCardPaymentScreen extends StatelessWidget {
  final int selectedCardId; // 상위 위젯에서 관리하는 선택된 상품권 ID
  final GiftCardPage widget; // 이전 화면에서 전달받는 GiftCardPage

  const GiftCardPaymentScreen({
    Key? key,
    required this.selectedCardId,
    required this.widget, // 위젯을 주입받음
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double cardWidth = 320; // 카드 너비
    const double cardHeight = 200; // 카드 높이
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return GestureDetector(
      onTap: () {
        // 다른 터치 이벤트를 처리할 수 있습니다.
      },
      child: Scaffold(
        backgroundColor: Colors.black12.withOpacity(0.2),
        body: Stack(
          children: [
            // 배경색.
            ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
                child: Container(),
              ),
            ),

            // 카드 화면.
            SafeArea(
              child: Column(
                children: [
                  Hero(
                    tag: 'payment-button-hero-$selectedCardId', // 동일한 tag 사용
                    child: GiftCard(
                      cardWidth: cardWidth,
                      cardHeight: cardHeight,
                      widget: widget, // 주입받은 위젯 사용
                      index: selectedCardId, // 카드 인덱스
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// command to create new Project flutter // project-name : hang-dev-app
// flutter create --org com.example --project-name hang-dev-app --template=app
// flu