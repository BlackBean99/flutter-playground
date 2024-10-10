import 'package:flutter/material.dart';
import 'package:toss_gift_card_interaction/gift_card_page.dart';
import 'package:toss_gift_card_interaction/gift_card_payment_screen.dart';
import 'package:toss_gift_card_interaction/payment_overlay.dart';

class PaymentButton extends StatelessWidget {
  const PaymentButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // arguments를 null-safe하게 처리
    final selectedCardId =
        ModalRoute.of(context)?.settings.arguments as int? ?? 0;

    return GestureDetector(
      // 임시 overlay
      // onLongPress: const PaymentOverlay(),
      onTap: () {
        final giftCardPageWidget = GiftCardPage(
            tag: Colors.accents.length,
            colors: Colors.accents[selectedCardId % Colors.accents.length]);

        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return GiftCardPaymentScreen(
                selectedCardId: selectedCardId,
                widget: giftCardPageWidget,
              ); // NewPage로 이동할 때는 arguments 전달
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 2000),
            settings: RouteSettings(
              arguments: selectedCardId, // 여기에서 ID 전달
            ),
          ),
        );
      },
      child: Hero(
        tag: 'payment-button-hero-$selectedCardId',
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20) +
              const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade200,
                Colors.blue.shade400,
              ],
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(5, 5),
                blurRadius: 10,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.7),
                offset: const Offset(-5, -5),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Center(
            child: Text(
              '$selectedCardId번 상품권 구매하기',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
