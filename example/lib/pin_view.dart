import 'package:flutter/material.dart';
import 'package:pin_ui/pin_ui.dart';

class PinView extends StatefulWidget {
  const PinView({super.key});

  @override
  State<PinView> createState() => _PinViewState();
}

class _PinViewState extends State<PinView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Spacer(),
          const Pinput(),
          const SizedBox(height: 64),
          Pinpad(
            onKeyTap: (text) {},
            onEraseButtonTap: () {},
          ),
          const SizedBox(height: 64),
          const Text('Forgot PIN?'),
          const Spacer(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
