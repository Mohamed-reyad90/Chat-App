import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final String hintText;
  final Function(String) onChanged;
  final bool isPasswordField;
  final TextInputType keyboardType;

  const MyTextField({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.isPasswordField = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _isObscure = true; // جعل المتغير داخليًا في الـ State لتحديثه بسهولة
  final FocusNode _focusNode = FocusNode(); // ✅ إنشاء FocusNode

  @override
  void dispose() {
    _focusNode.dispose(); // ✅ تأكد من تحرير الذاكرة عند إنهاء الـ Widget
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        focusNode: _focusNode,
        obscureText: widget.isPasswordField ? _isObscure : false,
        onChanged: widget.onChanged,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(fontFamily: 'Tajawal'),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 20.0,
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          suffixIcon:
              widget.isPasswordField
                  ? IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure; // ✅ تحديث حالة الإخفاء
                      });
                    },
                  )
                  : null,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
    );
  }
}
