import 'package:flutter/material.dart';

import '../pallete.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton(
      {super.key, required this.text, required this.onPress});
  final String text;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Pallet.gradient1, Pallet.gradient2, Pallet.gradient3],
              begin: Alignment.bottomLeft),
          borderRadius: BorderRadius.circular(7)),
      child: ElevatedButton(
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
            fixedSize: const Size(337, 50),
            backgroundColor: Colors.transparent),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
        ),
      ),
    );
  }
}
