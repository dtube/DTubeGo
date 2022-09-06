import 'package:dtube_go/ui/pages/user/Pages/Layouts/ProfileSettingsDesktop.dart';
import 'package:dtube_go/ui/pages/user/Pages/Layouts/ProfileSettingsMobile.dart';
import 'package:dtube_go/ui/widgets/system/ColorChangeCircularProgressIndicator.dart';
import 'package:dtube_go/utils/GlobalStorage/globalVariables.dart' as globals;

import 'package:dtube_go/bloc/thirdpartyloader/thirdpartyloader_bloc_full.dart';
import 'package:dtube_go/res/Config/secretConfigValues.dart' as secretConfig;
import 'package:dtube_go/ui/pages/user/Widgets/ConnectYTChannelDialog.dart';
import 'package:dtube_go/utils/Layout/ResponsiveLayout.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:decorated_icon/decorated_icon.dart';
import 'package:dtube_go/bloc/ThirdPartyUploader/ThirdPartyUploader_bloc.dart';
import 'package:dtube_go/bloc/ThirdPartyUploader/ThirdPartyUploader_bloc_full.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/bloc/user/user_bloc.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/bloc/user/user_response_model.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:dtube_go/ui/widgets/UnsortedCustomWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSettingsContainer extends StatelessWidget {
  ProfileSettingsContainer({Key? key, required this.userBloc})
      : super(key: key);
  final UserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopBody: ProfileSettingsDesktop(userBloc: userBloc),
      tabletBody: ProfileSettingsDesktop(userBloc: userBloc),
      mobileBody: ProfileSettingsMobile(userBloc: userBloc),
    );
  }
}
