import 'package:dtube_togo/style/ThemeData.dart';
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

class DTubeFormCard extends StatelessWidget {
  DTubeFormCard({Key? key, required this.childs}) : super(key: key);
  List<Widget> childs;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: globalBlue,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: childs),
      ),
    );
  }
}
