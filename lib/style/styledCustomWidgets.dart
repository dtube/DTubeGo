import 'package:flutter/material.dart';

AppBar dtubeSubAppBar() {
  return AppBar(
    centerTitle: true,
    title: DTubeLogo(
      size: 60,
    ),
    //   actions: <Widget>[
    //     IconButton(
    //       icon: Icon(Icons.refresh),
    //       onPressed: () {
    //         notificationBloc.add(FetchnotificationsEvent());
    //       },
    //     ),
    //     IconButton(
    //       icon: Icon(Icons.info),
    //       onPressed: () {
    //         navigateToAoutPage(context);
    //       },
    //     )
    //   ],
  );
}

class DTubeLogo extends StatelessWidget {
  double size;
  DTubeLogo({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/dtube_logo_white.png',
      fit: BoxFit.fitWidth,
      width: size,
    );
  }
}
