
import 'package:flutter/material.dart';

class ErrorBody extends StatelessWidget {
  final String errorMsg;

 const ErrorBody({
    Key? key,
    required this.errorMsg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
            height: w,
            width: w,
            child: Image.asset(
              "assets/images/error.gif",
              fit: BoxFit.cover,
            )),
        SizedBox(
          height: h * 0.02,
        ),
        Text(
          errorMsg,
          style: TextStyle(fontSize: w * 0.06, color: Colors.red),
        )
      ],
    );
  }
}
