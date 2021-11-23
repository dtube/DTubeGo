import 'package:dtube_go/utils/SecureStorage.dart' as sec;

import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/style/OpenableHyperlink.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/DialogTemplates/DialogWithTitleLogo.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayIcon.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayText.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/DTubeLogo.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:dtube_go/utils/shortBalanceStrings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UserBlockButton extends StatefulWidget {
  UserBlockButton({Key? key, required this.user}) : super(key: key);

  User user;

  @override
  State<UserBlockButton> createState() => _UserBlockButtonState();
}

class _UserBlockButtonState extends State<UserBlockButton> {
  late UserBloc _userBloc;
  late User myUserData;
  @override
  void initState() {
    _userBloc = BlocProvider.of<UserBloc>(context);
    _userBloc.add(FetchMyAccountDataEvent());
    super.initState();
  }

  void persistNewBlockedUserList(List<String> blockList) async {
    await sec.persistBlockedUsers(blockList.join(","));
  }

  @override
  Widget build(BuildContext context) {
    BuildContext parentContext = context;
    return BlocBuilder<UserBloc, UserState>(
        bloc: _userBloc,
        builder: (context, state) {
          if (state is UserLoadingState || state is UserInitialState) {
            return Container();
          } else if (state is UserLoadedState) {
            return IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return PopUpDialogWithTitleLogo(
                            titleWidget: Center(
                              child: FaIcon(
                                FontAwesomeIcons.flag,
                                size: 8.h,
                              ),
                            ),
                            callbackOK: () {},
                            titleWidgetPadding: 10.w,
                            titleWidgetSize: 10.w,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    children: [
                                      Text("Flag / block",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4),
                                      Text(widget.user.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                              "Flagging a user will result in a block of this users posts and comments for you.",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1),
                                          SizedBox(
                                            height: 2.h,
                                          ),
                                          Text("This can not be reverted!",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(color: globalRed)),
                                          SizedBox(
                                            height: 2.h,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  InkWell(
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            top: 20.0, bottom: 20.0),
                                        decoration: BoxDecoration(
                                          color: globalRed,
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20.0),
                                              bottomRight:
                                                  Radius.circular(20.0)),
                                        ),
                                        child: Text(
                                          "OK block this user!",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      onTap: () async {
                                        User _saveUserData = new User(
                                            sId: state.user.sId,
                                            name: state.user.name,
                                            pub: state.user.pub,
                                            balance: state.user.balance,
                                            keys: state.user.keys,
                                            alreadyFollowing: false,
                                            jsonString: new JsonString(
                                                node:
                                                    state.user.jsonString?.node,
                                                profile: new Profile(
                                                    about: state
                                                        .user
                                                        .jsonString!
                                                        .profile
                                                        ?.about,
                                                    avatar: state
                                                        .user
                                                        .jsonString!
                                                        .profile
                                                        ?.avatar,
                                                    coverImage: state
                                                        .user
                                                        .jsonString!
                                                        .profile
                                                        ?.coverImage,
                                                    hive: state.user.jsonString!
                                                        .profile?.hive,
                                                    location: state
                                                        .user
                                                        .jsonString!
                                                        .profile
                                                        ?.location,
                                                    steem: state
                                                        .user
                                                        .jsonString!
                                                        .profile
                                                        ?.steem,
                                                    website: state
                                                        .user
                                                        .jsonString!
                                                        .profile
                                                        ?.website),
                                                additionals: new Additionals(
                                                  accountType: state
                                                      .user
                                                      .jsonString!
                                                      .additionals
                                                      ?.accountType,
                                                  displayName: state
                                                      .user
                                                      .jsonString!
                                                      .additionals
                                                      ?.displayName,
                                                  blocking: state
                                                                  .user
                                                                  .jsonString!
                                                                  .additionals !=
                                                              null &&
                                                          state
                                                                  .user
                                                                  .jsonString!
                                                                  .additionals!
                                                                  .blocking !=
                                                              null
                                                      ? state
                                                              .user
                                                              .jsonString!
                                                              .additionals!
                                                              .blocking! +
                                                          [widget.user.name]
                                                      : [widget.user.name],
                                                )));

                                        persistNewBlockedUserList(state
                                                        .user
                                                        .jsonString!
                                                        .additionals !=
                                                    null &&
                                                state
                                                        .user
                                                        .jsonString!
                                                        .additionals!
                                                        .blocking !=
                                                    null
                                            ? state.user.jsonString!
                                                    .additionals!.blocking! +
                                                [widget.user.name]
                                            : [widget.user.name]);

                                        BlocProvider.of<TransactionBloc>(
                                                context)
                                            .add(ChangeProfileData(
                                                _saveUserData, parentContext));

                                        // state.user

                                        Navigator.of(context).pop();
                                        FocusScope.of(context).unfocus();
                                      }),
                                ],
                              ),
                            ));
                      });
                },
                icon: ShadowedIcon(
                    size: globalIconSizeSmall,
                    icon: FontAwesomeIcons.flag,
                    color: globalRed,
                    shadowColor: Colors.black));
          } else {
            return DTubeLogoPulse(size: 40.w);
          }
        });
  }
}
