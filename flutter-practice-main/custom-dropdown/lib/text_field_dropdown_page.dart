import 'package:custom_drop_box/custom_email_dropdown.dart';
import 'package:flutter/material.dart';


class _CustomTestDropdownPage extends StatefulWidget {
  const _CustomTestDropdownPage({Key? key}) : super(key: key);

  @override
  State<_CustomTestDropdownPage> createState() => __CustomTestDropdownPageState();
}

class __CustomTestDropdownPageState extends State<_CustomTestDropdownPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final _currentFocus = FocusScope.of(context);
        if(!_currentFocus.hasPrimaryFocus){
          _currentFocus.unfocus();
        }
      },
      child: Scaffold(body: Center(child: _emailTextField(),),),
    )
  }
  _emailTextField() {


  }
}




class CustomTextFieldDropdownPage extends StatefulWidget {
  const CustomTextFieldDropdownPage({Key? key}) : super(key: key);

  @override
  State<CustomTextFieldDropdownPage> createState() => _CustomTextFieldDropdownPageState();
}

class _CustomTextFieldDropdownPageState extends State<CustomTextFieldDropdownPage> {
  // 이메일.
  late TextEditingController _emailController;
  late FocusNode _emailFocusNode;
  OverlayEntry? _overlayEntry; // 이메일 자동 추천 드롭 박스.
  final LayerLink _layerLink = LayerLink();

  // 이메일 드롭박스 해제.
  void _removeEmailOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _emailFocusNode = FocusNode()
      ..addListener(() {
        if (!_emailFocusNode.hasFocus) {
          _removeEmailOverlay();
        }
      });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _overlayEntry?.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final _currentFocus = FocusScope.of(context);
        if (!_currentFocus.hasPrimaryFocus) {
          _currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: Center(
          child: _emailTextField(),
        ),
      ),
    );
  }



  // 이메일 자동 입력창.
  OverlayEntry _emailListOverlayEntry() {
    return customDropdown.emailRecommendation(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      layerLink: _layerLink,
      controller: _emailController,
      onPressed: () {
        setState(() {
          _emailFocusNode.unfocus();
          _removeEmailOverlay();
        });
      },
    );
  }
}
