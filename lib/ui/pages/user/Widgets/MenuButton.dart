import 'package:dtube_go/ui/pages/Governance/Pages/Wallet/transferDialog.dart';
import 'package:dtube_go/utils/GlobalStorage/globalVariables.dart' as globals;
import 'package:dtube_go/bloc/ThirdPartyUploader/ThirdPartyUploader_bloc_full.dart';
import 'package:dtube_go/bloc/accountHistory/accountHistory_bloc_full.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/ui/pages/accountHistory/AccountHistory.dart';
import 'package:dtube_go/ui/pages/user/Pages/ProfileSettings.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayIcon.dart';
import 'package:dtube_go/bloc/auth/auth_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget buildUserMenuSpeedDial(
    BuildContext context, User user, bool ownUser, UserBloc userBloc) {
  List<SpeedDialChild> mainMenuButtonOptions = [];
  if (ownUser) {
    mainMenuButtonOptions = [
      SpeedDialChild(
          child: ShadowedIcon(
              icon: FontAwesomeIcons.gears,
              color: globalAlmostWhite,
              shadowColor: Colors.black,
              size: globalIconSizeBig),
          elevation: 0,
          backgroundColor: Colors.transparent,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MultiBlocProvider(providers: [
                BlocProvider<ThirdPartyUploaderBloc>(
                    create: (BuildContext context) => ThirdPartyUploaderBloc(
                        repository: ThirdPartyUploaderRepositoryImpl())),
                BlocProvider<UserBloc>(
                    create: (BuildContext context) =>
                        UserBloc(repository: UserRepositoryImpl())),
              ], child: ProfileSettingsContainer(userBloc: userBloc));
            }));
          }),
      SpeedDialChild(
          child: ShadowedIcon(
              icon: FontAwesomeIcons.clockRotateLeft,
              color: globalAlmostWhite,
              shadowColor: Colors.black,
              size: globalIconSizeBig),
          elevation: 0,
          backgroundColor: Colors.transparent,
            // Start of temporary placeholder message ==>
            onTap: () {
              showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    backgroundColor: globalBGColor,
                    title: Text("Temporarily disabled"),
                    content: Text("Account history functionality is temporarily disabled, please, in the mean time, use avalonblocks.com explorer instead."),
                      actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: Text(
                          'Ok',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                      ],
                  ));
            // end of temporary placeholder message <==
            /*
            // Temporary disable account history button, as it is bugged.
            // Todo: fix and re-enable it, then remove above placeholder popup message.
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return BlocProvider<AccountHistoryBloc>(
                  create: (context) => AccountHistoryBloc(
                      repository: AccountHistoryRepositoryImpl()),
                  child: AccountHistoryScreen(
                    username: user.name,
                  ));
            }));
            */
          }),

      SpeedDialChild(
          child: ShadowedIcon(
              icon: FontAwesomeIcons.rightFromBracket,
              color: globalAlmostWhite,
              shadowColor: Colors.black,
              size: globalIconSizeBig),
          elevation: 0,
          backgroundColor: Colors.transparent,
          onTap: () {
            BlocProvider.of<AuthBloc>(context)
                .add(SignOutEvent(context: context));
          }),
    ];
  } else {
    mainMenuButtonOptions = [
      SpeedDialChild(
          child: ShadowedIcon(
              icon: FontAwesomeIcons.clockRotateLeft,
              color: globalAlmostWhite,
              shadowColor: Colors.black,
              size: globalIconSizeBig),
          elevation: 0,
          backgroundColor: Colors.transparent,
          onTap: () {
            // Start of temporary placeholder message ==>
            showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  backgroundColor: globalBGColor,
                  title: Text("Temporarily disabled"),
                  content: Text("Account history functionality is temporarily disabled, please, in the mean time, use avalonblocks.com explorer instead."),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: Text(
                        'Ok',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    )
                  ],
                ));
            // end of temporary placeholder message <==
            // Temporary disable account history button, as it is bugged.
            // Todo: fix and re-enable it, then remove above placeholder popup message.
            /*
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return BlocProvider<AccountHistoryBloc>(
                  create: (context) => AccountHistoryBloc(
                      repository: AccountHistoryRepositoryImpl()),
                  child: AccountHistoryScreen(
                    username: user.name,
                  ));
            }));
            */
          }),
      SpeedDialChild(
          child: ShadowedIcon(
              icon: FontAwesomeIcons.rightLeft,
              color: globalAlmostWhite,
              shadowColor: Colors.black,
              size: globalIconSizeBig),
          elevation: 0,
          backgroundColor: Colors.transparent,
          visible: globals.keyPermissions.contains(3),
          onTap: () {
            showDialog<String>(
                context: context,
                builder: (BuildContext context) => TransferDialog(
                      receiver: user.name,
                      txBloc: BlocProvider.of<TransactionBloc>(context),
                    ));
          }),
      SpeedDialChild(
          child: ShadowedIcon(
              icon: user.alreadyFollowing
                  ? FontAwesomeIcons.usersSlash
                  : FontAwesomeIcons.userGroup,
              color: globalAlmostWhite,
              shadowColor: Colors.black,
              size: globalIconSizeBig),
          elevation: 0,
          visible: user.alreadyFollowing
              ? globals.keyPermissions.contains(8)
              : globals.keyPermissions.contains(7),
          backgroundColor: Colors.transparent,
          onTap: () async {
            TxData txdata = TxData(
              target: user.name,
            );
            Transaction newTx =
                Transaction(type: user.alreadyFollowing ? 8 : 7, data: txdata);
            BlocProvider.of<TransactionBloc>(context)
                .add(SignAndSendTransactionEvent(tx: newTx));
          }),
    ];
  }

  return SpeedDial(
      child: ShadowedIcon(
          icon: FontAwesomeIcons.bars,
          color: globalAlmostWhite,
          shadowColor: Colors.transparent,
          size: globalIconSizeBig),
      activeIcon: FontAwesomeIcons.chevronLeft,
      direction: SpeedDialDirection.up,
      visible: true,
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      tooltip: 'menu',
      heroTag: 'user menu button' + ownUser.toString(),
      backgroundColor: globalRed,
      foregroundColor: globalAlmostWhite,
      elevation: 0.0,
      shape: CircleBorder(),
      gradientBoxShape: BoxShape.circle,
      children: mainMenuButtonOptions);
}
