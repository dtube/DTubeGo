import 'package:dtube_go/ui/pages/Governance/Pages/DAO/DAO/Layouts/DAODesktop.dart';
import 'package:dtube_go/ui/pages/Governance/Pages/DAO/DAO/Layouts/DAOMobile.dart';
import 'package:dtube_go/utils/Layout/ResponsiveLayout.dart';
import 'package:flutter/material.dart';

class DAO extends StatelessWidget {
  const DAO({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopBody: DAODesktop(),
      tabletBody: DAODesktop(),
      mobileBody: DAOMobile(),
    );
  }
}
