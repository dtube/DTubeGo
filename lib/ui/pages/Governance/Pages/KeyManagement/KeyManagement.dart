import 'package:dtube_go/ui/pages/Governance/Pages/KeyManagement/Layouts/KeyManagementDesktop.dart';
import 'package:dtube_go/ui/pages/Governance/Pages/KeyManagement/Layouts/KeyManagementMobile.dart';
import 'package:dtube_go/ui/pages/Governance/Pages/KeyManagement/Layouts/KeyManagementTablet.dart';
import 'package:dtube_go/ui/pages/Governance/Pages/KeyManagement/Widgets/newKeyDialog.dart';
import 'package:dtube_go/ui/pages/Governance/Pages/KeyManagement/Widgets/removeKeyDialog.dart';
import 'package:dtube_go/ui/pages/Governance/Pages/KeyManagement/Widgets/resetMasterKeyDialog.dart';
import 'package:dtube_go/utils/GlobalStorage/globalVariables.dart' as globals;

export 'package:dtube_go/bloc/auth/auth_repository.dart';

import 'package:dtube_go/utils/GlobalStorage/SecureStorage.dart' as sec;

import 'package:dtube_go/bloc/config/txTypes.dart';
import 'package:dtube_go/ui/widgets/UnsortedCustomWidgets.dart';
import 'package:dtube_go/utils/Crypto/crypto_convert.dart';
import 'package:dtube_go/utils/Layout/ResponsiveLayout.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:dtube_go/ui/widgets/system/customSnackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KeyManagementPage extends StatelessWidget {
  const KeyManagementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopBody: KeyManagementDesktop(),
      mobileBody: KeyManagementMobile(),
      tabletBody: KeyManagementTablet(),
    );
  }
}
