import 'package:flutter/material.dart';


class PrimaryCustomButton extends StatelessWidget {
  final String label;
  final void Function()? onPressed;
  final bool isDisabled;
  final bool loading;

  PrimaryCustomButton({
    required this.label,
    required this.onPressed,
    this.isDisabled = false,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return 
    SizedBox(
                  width: double.infinity,
                  child:

          ElevatedButton(
  onPressed: onPressed,
  style: ElevatedButton.styleFrom(
    elevation: 5,
    surfaceTintColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white, // Set the text color (applies to foreground)
    textStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700, 
    ),
    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40), // Set the padding
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)), // Set the border radius
            side: BorderSide(
        color: Colors.white,
        width: 2,
      ),
    ),
  ),
  child: 
    loading ? 
      CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF232428)), // Change the progress color
    backgroundColor: Color(0xFFC3C3C3), // Change the background color
  ) :
  Text(
    label
  ),
),
);
  }
}