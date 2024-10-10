import 'package:flutter/material.dart';

class NormalDropdownPagePractice extends StatefulWidget {
  const NormalDropdownPagePractice({Key? key}) : super(key: key);

  @override
  State<NormalDropdownPagePractice> createState() =>
      _NormalDropdownPagePracticeState();
}

class _NormalDropdownPagePracticeState
    extends State<NormalDropdownPagePractice> {
  static const List<String> _dropdownList = [
    'One',
    'Two',
    'Three',
    'Four',
    'Five'
  ];
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  static const double _dropdownWidth = 200;
  static const double _dropdownHeight = 48;

  void _createOverlay() {
    _overlayEntry ??= customDropdown();
  }

  OverlayEntry customDropdown() {
    return OverlayEntry(maintainState: true,
    builder: (context) => Positioned(width: _dropdownWidth, height: _dropdownHeight,
    child: CompositedTransformFollower(link: ,)
    )

    }
    )

  @override
  void dispose() {
    _overlayEntry?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
