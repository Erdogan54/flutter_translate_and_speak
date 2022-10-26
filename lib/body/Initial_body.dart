
import 'package:flutter/material.dart';

class InitialBody extends StatelessWidget {
  final Widget body;
  const InitialBody({
    Key? key,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return FutureBuilder(
      future: futureDelayed(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return initBody(h, w);
        } else {
          return body;
        }
      },
    );
  }

  Future<bool> futureDelayed() async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  initBody(double h, double w) {
    return Stack(
      children: [
        body,
        Container(
          height: h,
          width: w,
          color: Colors.black.withOpacity(0.9),
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: w * 0.5,
                  width: w * 0.8,
                  child: Image.asset(
                    "assets/images/loading.gif",
                  )),
              Text(
                "Yükleniyor...",
                style: TextStyle(fontSize: w * 0.1),
              )
            ],
          ),
        )
      ],
    );
  }
}
