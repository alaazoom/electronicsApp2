import 'package:flutter/material.dart';

import '../../configs/theme/theme_exports.dart';

class OtpInputField extends StatefulWidget {
  @override
  _OtpInputFieldState createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  final int length = 4;
  final TextEditingController controller = TextEditingController();
  List<String> inputs = [];
  String correctCode = "1234"; // هذا الكود الصح
  List<bool?> isCorrect = [];
  List<FocusNode> focusNodes = [];

  @override
  void initState() {
    super.initState();
    inputs = List.filled(length, '');
    isCorrect = List.filled(
      length,
      null,
    ); // null = فارغ، true = صح، false = غلط
    focusNodes = List.generate(length, (_) => FocusNode());
  }

  void checkOtp() {
    setState(() {
      for (int i = 0; i < length; i++) {
        if (inputs[i].isEmpty) {
          isCorrect[i] = null;
        } else if (inputs[i] == correctCode[i]) {
          isCorrect[i] = true;
        } else {
          isCorrect[i] = false;
        }
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (index) {
        Color borderColor;
        if (isCorrect[index] == null) {
          borderColor = colors.text; // فارغ
        } else if (isCorrect[index] == true) {
          borderColor = colors.mainColor; // صحيح
        } else {
          borderColor = colors.error; // غلط
        }

        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            width: 56,
            height: 56,
            child: TextField(
              focusNode: focusNodes[index],

              onChanged: (value) {
                inputs[index] = value;
                checkOtp();

                // إذا كتب رقم انتقل للخانة اللي بعدها
                if (value.isNotEmpty && index < length - 1) {
                  FocusScope.of(context).requestFocus(focusNodes[index + 1]);
                }
              },
              maxLength: 1,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                counterText: "",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: borderColor, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: borderColor, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: borderColor, width: 1),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
