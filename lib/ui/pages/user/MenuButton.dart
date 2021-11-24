import 'package:dtube_go/bloc/ThirdPartyUploader/ThirdPartyUploader_bloc_full.dart';
import 'package:dtube_go/bloc/accountHistory/accountHistory_bloc_full.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/ui/pages/accountHistory/AccountHistory.dart';
import 'package:dtube_go/ui/pages/user/ProfileSettings.dart';
import 'package:dtube_go/ui/pages/wallet/transferDialog.dart';

import 'package:responsive_sizer/responsive_sizer.dart';
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
          child: CircleAvatar(
            backgroundColor: globalBlueShades[2],
            radius: globalIconSizeMedium + 2.w,
            foregroundColor: globalAlmostWhite,
            child: FaIcon(FontAwesomeIcons.cogs, size: globalIconSizeMedium),
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return BlocProvider<ThirdPartyUploaderBloc>(
                  create: (BuildContext context) => ThirdPartyUploaderBloc(
                      repository: ThirdPartyUploaderRepositoryImpl()),
                  child: ProfileSettingsContainer(userBloc: userBloc));
            }));
          }),
      SpeedDialChild(
          child: CircleAvatar(
            backgroundColor: globalBlueShades[2],
            radius: globalIconSizeMedium + 2.w,
            foregroundColor: globalAlmostWhite,
            child: FaIcon(FontAwesomeIcons.history, size: globalIconSizeMedium),
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return BlocProvider<AccountHistoryBloc>(
                  create: (context) => AccountHistoryBloc(
                      repository: AccountHistoryRepositoryImpl()),
                  child: AccountHistoryScreen(
                    username: user.name,
                  ));
            }));
          }),
      SpeedDialChild(
          child: CircleAvatar(
            backgroundColor: globalBlueShades[2],
            radius: globalIconSizeMedium + 2.w,
            foregroundColor: globalAlmostWhite,
            child:
                FaIcon(FontAwesomeIcons.signOutAlt, size: globalIconSizeMedium),
          ),
          onTap: () {
            BlocProvider.of<AuthBloc>(context)
                .add(SignOutEvent(context: context));
          }),
    ];
  } else {
    mainMenuButtonOptions = [
      SpeedDialChild(
          child: CircleAvatar(
            backgroundColor: globalBlueShades[2],
            radius: globalIconSizeMedium + 2.w,
            foregroundColor: globalAlmostWhite,
            child: FaIcon(FontAwesomeIcons.history, size: globalIconSizeMedium),
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return BlocProvider<AccountHistoryBloc>(
                  create: (context) => AccountHistoryBloc(
                      repository: AccountHistoryRepositoryImpl()),
                  child: AccountHistoryScreen(
                    username: user.name,
                  ));
            }));
          }),
      SpeedDialChild(
          child: CircleAvatar(
            backgroundColor: globalBlueShades[2],
            radius: globalIconSizeMedium + 2.w,
            foregroundColor: globalAlmostWhite,
            child: FaIcon(FontAwesomeIcons.exchangeAlt,
                size: globalIconSizeMedium),
          ),
          onTap: () {
            showDialog<String>(
                context: context,
                builder: (BuildContext context) => TransferDialog(
                      receiver: user.name,
                      txBloc: BlocProvider.of<TransactionBloc>(context),
                    ));
          }),
      SpeedDialChild(
          child: CircleAvatar(
            backgroundColor: globalBlueShades[2],
            radius: globalIconSizeMedium + 2.w,
            foregroundColor: globalAlmostWhite,
            child: FaIcon(
                user.alreadyFollowing
                    ? FontAwesomeIcons.usersSlash
                    : FontAwesomeIcons.userFriends,
                size: globalIconSizeMedium),
          ),
          onTap: () async {
            TxData txdata = TxData(
              target: user.name,
            );
            Transaction newTx =
                Transaction(type: user.alreadyFollowing ? 8 : 7, data: txdata);
            BlocProvider.of<TransactionBloc>(context)
                .add(SignAndSendTransactionEvent(newTx));
          }),
    ];
  }

  return SpeedDial(
      child: CircleAvatar(
        backgroundColor: globalRed,
        radius: 10.w,
        foregroundColor: globalAlmostWhite,
        child: FaIcon(FontAwesomeIcons.bars, size: 8.w),
      ),
      activeIcon: FontAwesomeIcons.chevronLeft,
      direction: SpeedDialDirection.up,
      visible: true,
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.white,
      overlayOpacity: 0,
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      tooltip: 'menu',
      heroTag: 'user menu button' + ownUser.toString(),
      backgroundColor: globalBlueShades[2],
      foregroundColor: Colors.white,
      elevation: 0.0,
      shape: CircleBorder(),
      gradientBoxShape: BoxShape.circle,
      children: mainMenuButtonOptions);
}
