import 'package:flutter/material.dart';

class InputTextWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final IconData? iconData;
  final String? assetRefrence;
  final String lableString;
  final bool isObscure;

  const InputTextWidget(
    {super.key, 
      required this.textEditingController,
      this.iconData,
      this.assetRefrence,
      required this.lableString,
      required this.isObscure,
    }
  );

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        labelText: lableString,
        prefixIcon: iconData != null  
          ? Icon(iconData)
          : Padding(
              padding: const EdgeInsets.all(8),
              child: Image.asset(assetRefrence!, width: 10,),
          ),
        labelStyle: const TextStyle(
          fontSize: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(
            color: Colors.grey
          )
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(
            color: Colors.grey
          )
        ),
      ),
    );
  }
}