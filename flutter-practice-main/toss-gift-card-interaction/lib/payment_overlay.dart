// import 'package:flutter/cupertino.dart';

// class PaymentOverlay extends StatelessWidget {
//   const PaymentOverlay({Key? key}) : super(key: key);
//   // stateful widget

//   late final OverlayEntry overlayEntry =
//       OverlayEntry(builder: _overlayEntryBuilder);

//   @override
//   void dispose() {
//     overlayEntry.dispose();
//     super.dispose();
//   }

//   void insertOverlay() {
//     // 적절한 타이밍에 호출
//     if (!overlayEntry.mounted) {
//       OverlayState overlayState = Overlay.of(context);
//       overlayState.insert(overlayEntry);
//     }
//   }

//   void removeOverlay() {
//     // 적절한 타이밍에 호출
//     if (overlayEntry.mounted) {
//       overlayEntry.remove();
//     }
//   }

//   Widget _overlayEntryBuilder(BuildContext context) {
//     Offset position = _getOverlayEntryPosition();
//     Size size = _getOverlayEntrySize();

//     return Positioned(
//       left: position.dx,
//       top: position.dy,
//       width: Get.size.width - MyConstants.SCREEN_HORIZONTAL_MARGIN.horizontal,
//       child: AutoCompleteKeywordList(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
