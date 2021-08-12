import 'package:dtube_togo/bloc/hivesigner/hivesigner_bloc.dart';
import 'package:dtube_togo/bloc/hivesigner/hivesigner_bloc_full.dart';
import 'package:dtube_togo/bloc/ipfsUpload/ipfsUpload_bloc.dart';
import 'package:dtube_togo/bloc/ipfsUpload/ipfsUpload_bloc_full.dart';
import 'package:dtube_togo/bloc/settings/settings_bloc_full.dart';
import 'package:dtube_togo/bloc/thirdpartyloader/thirdpartyloader_bloc_full.dart';
import 'package:dtube_togo/bloc/thirdpartyloader/thirdpartyloader_repository.dart';
import 'package:dtube_togo/bloc/transaction/transaction_bloc.dart';
import 'package:dtube_togo/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_togo/bloc/user/user_bloc.dart';
import 'package:dtube_togo/bloc/user/user_bloc_full.dart';
import 'package:dtube_togo/style/ThemeData.dart';
import 'package:dtube_togo/style/styledCustomWidgets.dart';
import 'package:dtube_togo/ui/pages/upload/3rdparty.dart';
import 'package:dtube_togo/ui/pages/upload/ipfs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UploaderMainPage extends StatefulWidget {
  UploaderMainPage({Key? key}) : super(key: key);

  @override
  _UploaderMainPageState createState() => _UploaderMainPageState();
}

class _UploaderMainPageState extends State<UploaderMainPage>
    with SingleTickerProviderStateMixin {
  List<String> uploadOptions = ["IPFS", "3rd Party"];

// TODO: only forward ipfs and tx bloc here to the upload form -> to react on state changes within upload button from the background upload

  late TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: dtubeSubAppBar(true, "", context, null),
      resizeToAvoidBottomInset: true,
      body: Column(
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
                        create: (context) => IPFSUploadBloc(
                            repository: IPFSUploadRepositoryImpl()),
                      ),
                      BlocProvider(
                        create: (context) => TransactionBloc(
                            repository: TransactionRepositoryImpl()),
                      ),
                      BlocProvider(
                        create: (context) => HivesignerBloc(
                            repository: HivesignerRepositoryImpl()),
                      ),
                    ],
                    child: WizardIPFS(),
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
                        create: (context) => TransactionBloc(
                            repository: TransactionRepositoryImpl()),
                      ),
                      BlocProvider(
                        create: (context) => HivesignerBloc(
                            repository: HivesignerRepositoryImpl()),
                      ),
                    ],
                    child: Wizard3rdParty(),
                  ),
                ],
                controller: _tabController,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
