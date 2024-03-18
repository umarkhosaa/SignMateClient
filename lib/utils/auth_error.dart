import 'package:flutter/material.dart';

class AuthErrorMessage extends StatelessWidget {
  final String errorMessage;

  AuthErrorMessage({required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
      color: Colors.red,
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.white,
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: Text(
              errorMessage,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void showAuthErrorMessage(BuildContext context, String errorMessage) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: AuthErrorMessage(errorMessage: errorMessage),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.transparent,
    ),
  );
}
