import 'package:dtube_go/ui/pages/wallet/Pages/KeyManagement/Widgets/newKeyDialog.dart';
import 'package:dtube_go/ui/pages/wallet/Pages/KeyManagement/Widgets/removeKeyDialog.dart';
import 'package:dtube_go/ui/pages/wallet/Pages/KeyManagement/Widgets/resetMasterKeyDialog.dart';
import 'package:dtube_go/utils/GlobalStorage/globalVariables.dart' as globals;

export 'package:dtube_go/bloc/auth/auth_repository.dart';

import 'package:dtube_go/utils/GlobalStorage/SecureStorage.dart' as sec;

import 'package:dtube_go/bloc/config/txTypes.dart';
import 'package:dtube_go/ui/widgets/UnsortedCustomWidgets.dart';
import 'package:dtube_go/utils/Crypto/crypto_convert.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:dtube_go/ui/widgets/system/customSnackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KeyManagementPage extends StatefulWidget {
  const KeyManagementPage({
    Key? key,
  }) : super(key: key);

  @override
  _KeyManagementPageState createState() => _KeyManagementPageState();
}

class _KeyManagementPageState extends State<KeyManagementPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TransactionBloc _transactionBloc;
  String _currentPub = "";
  @override
  void initState() {
    super.initState();
    _transactionBloc = BlocProvider.of<TransactionBloc>(context);
    _tabController = new TabController(length: 1, vsync: this);
    getCurrentPub();
  }

  void getCurrentPub() async {
    String _currentPrivKey = await sec.getPrivateKey();
    setState(() {
      _currentPub = privToPub(_currentPrivKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionBloc, TransactionState>(
      listener: (context, state) {
        if (state is TransactionError) {
          showCustomFlushbarOnError(state.message, context);
        }
        if (state is TransactionSent) {
          showCustomFlushbarOnSuccess(state, context);
          BlocProvider.of<UserBloc>(context).add(FetchMyAccountDataEvent());
        }
      },
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InputChip(
                  isEnabled: globals.keyPermissions.contains(10),
                  label: Text("new custom key",
                      style: Theme.of(context).textTheme.headline6),
                  backgroundColor: globalRed,
                  onPressed: () {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => NewKeyDialog(
                        txBloc: _transactionBloc,
                      ),
                    );
                  },
                ),
                InputChip(
                  isEnabled: globals.keyPermissions.contains(12),
                  label: Text("change master key",
                      style: Theme.of(context).textTheme.headline6),
                  backgroundColor: globalRed,
                  onPressed: () {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) =>
                          ResetMasterKeyDialog(txBloc: _transactionBloc),
                    );
                  },
                ),
              ],
            ),
            Text(
              "Custom Keys",
              style: Theme.of(context).textTheme.headline6,
            ),
            Expanded(
              // height: 20.h,
              child: SingleChildScrollView(
                child:
                    BlocBuilder<UserBloc, UserState>(builder: (context, state) {
                  if (state is UserInitialState || state is UserLoadingState) {
                    return buildLoading(context);
                  } else if (state is UserLoadedState) {
                    return buildKeyList(state.user);
                  } else {
                    return Text("test");
                  }
                }),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildLoading(BuildContext context) {
    return Center(
      child: DtubeLogoPulseWithSubtitle(
        subtitle: "loading feed..",
        size: 40.w,
      ),
    );
  }

  Widget buildKeyList(User user) {
    double labelWidth = 20.w;
    return ListView.builder(
        key: new PageStorageKey('keystore_listview'),
        //addAutomaticKeepAlives: true,
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: user.keys.length,
        itemBuilder: (ctx, pos) {
          return DTubeFormCard(
              childs: [
                Stack(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            width: 25.w,
                            child: Text(
                              "Name:",
                              style: Theme.of(context).textTheme.headline6,
                            )),
                        Padding(
                          padding: EdgeInsets.only(left: 2.w),
                          child: Container(
                            width: 60.w,
                            child: Text(
                              user.keys[pos].id,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                        ),
                      ],
                    ),
                    _currentPub != "" && _currentPub != user.keys[pos].pub
                        ? Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                                iconSize: 4.w,
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                onPressed: () {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        RemoveKeyDialog(
                                      txBloc: _transactionBloc,
                                      keyId: user.keys[pos].id,
                                    ),
                                  );
                                },
                                icon: FaIcon(
                                  FontAwesomeIcons.times,
                                )))
                        : Container(),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 25.w,
                        child: Text("Public Key:"),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 2.w),
                        child: Container(
                            width: 60.w, child: Text(user.keys[pos].pub)),
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: Text("Granted Permissions:")),
                Wrap(
                  spacing: 3.0,
                  runSpacing: 3.0,
                  children: List<Widget>.generate(user.keys[pos].types.length,
                      (int index) {
                    return Chip(
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      backgroundColor: globalBGColorHalfOpacity,
                      label: Text(
                        txTypes[user.keys[pos].types[index]]!.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(fontSize: 10),
                      ),
                    );
                  }),
                ),
              ],
              avoidAnimation: globals.disableAnimations,
              waitBeforeFadeIn: Duration(
                milliseconds: pos * 200,
              ));
        });
  }
}
