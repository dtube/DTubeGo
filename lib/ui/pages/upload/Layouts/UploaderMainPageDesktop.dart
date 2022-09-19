import 'package:dtube_go/bloc/ThirdPartyUploader/ThirdPartyUploader_bloc_full.dart';
import 'package:dtube_go/bloc/hivesigner/hivesigner_bloc_full.dart';
import 'package:dtube_go/bloc/settings/settings_bloc_full.dart';
import 'package:dtube_go/bloc/thirdpartyloader/thirdpartyloader_bloc_full.dart';

import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/upload/providers/3rdparty.dart';
import 'package:dtube_go/ui/pages/upload/providers/Custom.dart';
import 'package:dtube_go/ui/pages/upload/providers/IpfsDTube.dart';
import 'package:dtube_go/ui/pages/upload/PresetSelection/Widgets/PresetCards.dart';
import 'package:dtube_go/ui/widgets/AppBar/DTubeSubAppBarDesktop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UploaderMainPageDesktop extends StatefulWidget {
  UploaderMainPageDesktop(
      {Key? key, required this.callback, required this.preset})
      : super(key: key);

  final VoidCallback callback;
  final Preset preset;

  @override
  _UploaderMainPageDesktopState createState() =>
      _UploaderMainPageDesktopState();
}

class _UploaderMainPageDesktopState extends State<UploaderMainPageDesktop>
    with SingleTickerProviderStateMixin {
  List<String> uploadOptions = ["File Upload", "3rd Party", "Peer-to-Peer"];

  late TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          unselectedLabelColor: Colors.grey,
          labelColor: globalAlmostWhite,
          indicatorColor: globalRed,
          isScrollable: true,
          tabs: [
            Tab(
              text: 'File Upload',
            ),
            Tab(
              text: '3rd Party',
            ),
            Tab(
              text: 'Peer-to-Peer',
            )
          ],
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TabBarView(
              children: [
                MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => SettingsBloc(),
                    ),
                    BlocProvider(
                      create: (context) =>
                          UserBloc(repository: UserRepositoryImpl()),
                    ),
                    BlocProvider(
                      create: (context) => HivesignerBloc(
                          repository: HivesignerRepositoryImpl()),
                    ),
                    BlocProvider(
                      create: (context) => ThirdPartyUploaderBloc(
                          repository: ThirdPartyUploaderRepositoryImpl()),
                    ),
                  ],
                  child: WizardIPFS(
                    uploaderCallback: widget.callback,
                    preset: widget.preset,
                  ),
                ),
                MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => SettingsBloc(),
                    ),
                    BlocProvider(
                      create: (context) =>
                          UserBloc(repository: UserRepositoryImpl()),
                    ),
                    BlocProvider(
                      create: (context) => ThirdPartyMetadataBloc(
                          repository: ThirdPartyMetadataRepositoryImpl()),
                    ),
                    BlocProvider(
                      create: (context) => HivesignerBloc(
                          repository: HivesignerRepositoryImpl()),
                    ),
                    BlocProvider(
                      create: (context) => ThirdPartyUploaderBloc(
                          repository: ThirdPartyUploaderRepositoryImpl()),
                    ),
                  ],
                  child: Wizard3rdParty(
                    uploaderCallback: widget.callback,
                    preset: widget.preset,
                  ),
                ),
                MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => SettingsBloc(),
                    ),
                    BlocProvider(
                      create: (context) =>
                          UserBloc(repository: UserRepositoryImpl()),
                    ),
                    BlocProvider(
                      create: (context) => HivesignerBloc(
                          repository: HivesignerRepositoryImpl()),
                    ),
                    BlocProvider(
                      create: (context) => ThirdPartyUploaderBloc(
                          repository: ThirdPartyUploaderRepositoryImpl()),
                    ),
                  ],
                  child: CustomWizard(
                    uploaderCallback: widget.callback,
                    preset: widget.preset,
                  ),
                ),
              ],
              controller: _tabController,
            ),
          ),
        ),
      ],
    );
  }
}
