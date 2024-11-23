import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;

  const Button({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = Colors.green,
  });

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  //Outline when clicked
  bool isOutlined = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              return isOutlined ? Colors.transparent : Colors.green.shade300;
            },
          ),
          elevation: WidgetStateProperty.resolveWith<double>(
            (Set<WidgetState> states) {
              return isOutlined ? 0 : 4;
            },
          ),
          side: WidgetStateProperty.resolveWith<BorderSide>(
            (Set<WidgetState> states) {
              return isOutlined 
                  ? BorderSide(color: Colors.green.shade300, width: 2)
                  : BorderSide.none;
            },
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        onPressed: () {
          setState(() {
            isOutlined = !isOutlined;
          });
          widget.onPressed();
        },
        child: Text(
          widget.text,
          style: TextStyle(
            color: isOutlined ? Colors.green.shade300 : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
