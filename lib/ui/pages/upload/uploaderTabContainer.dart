import 'package:dtube_go/bloc/ThirdPartyUploader/ThirdPartyUploader_bloc_full.dart';
import 'package:dtube_go/bloc/hivesigner/hivesigner_bloc.dart';
import 'package:dtube_go/bloc/hivesigner/hivesigner_bloc_full.dart';
import 'package:dtube_go/bloc/settings/settings_bloc_full.dart';
import 'package:dtube_go/bloc/thirdpartyloader/thirdpartyloader_bloc_full.dart';
import 'package:dtube_go/bloc/thirdpartyloader/thirdpartyloader_repository.dart';
import 'package:dtube_go/bloc/user/user_bloc.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/upload/3rdparty.dart';
import 'package:dtube_go/ui/pages/upload/ipfs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UploaderMainPage extends StatefulWidget {
  UploaderMainPage({Key? key, required this.callback}) : super(key: key);

  VoidCallback callback;

  @override
  _UploaderMainPageState createState() => _UploaderMainPageState();
}

class _UploaderMainPageState extends State<UploaderMainPage>
    with SingleTickerProviderStateMixin {
  List<String> uploadOptions = ["IPFS", "3rd Party"];

  late TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: dtubeSubAppBar(true, "", context, null),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.only(top: 90.0),
        child: Column(
          children: [
            TabBar(
              unselectedLabelColor: Colors.grey,
              labelColor: globalAlmostWhite,
              indicatorColor: globalRed,
              tabs: [
                Tab(
                  text: 'IPFS',
                ),
                Tab(
                  text: '3rd Party',
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
                      ),
                    ),
                  ],
                  controller: _tabController,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
