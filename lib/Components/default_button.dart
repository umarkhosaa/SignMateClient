import 'package:flutter/material.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
class DefaultButton extends StatelessWidget {
  final VoidCallback press;
  final String? text;
  final bool loading;
   DefaultButton({Key? key, required this.press, this.text,this.loading=false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14)
          )
        ),
        onPressed: press,
        child: Center(
          child:loading? const CircularProgressIndicator(backgroundColor: Colors.white,color: Colors.green, strokeWidth: 5,):Text(
            '$text',
            style: const TextStyle(
            fontSize: 18,
              color: Colors.white
          ),
          ),
        ),
      ),
    );
  }
}
