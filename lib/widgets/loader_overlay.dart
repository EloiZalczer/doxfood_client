import 'package:flutter/material.dart';

class LoaderOverlay extends StatelessWidget {
  final double? height;
  final double? width;

  const LoaderOverlay({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? MediaQuery.of(context).size.height,
      width: width ?? MediaQuery.of(context).size.width,
      color: Colors.transparent,
      child: Center(
        child: SizedBox(
          height: 60.0,
          width: 60.0,
          child:
          //Image.asset('assets/images/loader.gif',fit: BoxFit.fill,) // use you custom loader or default loader
          CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.blue), strokeWidth: 5.0),
        ),
      ),
    );
  }
}
