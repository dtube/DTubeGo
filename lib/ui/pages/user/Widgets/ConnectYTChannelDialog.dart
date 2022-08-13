import 'package:dtube_go/bloc/thirdpartyloader/thirdpartyloader_bloc_full.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/res/Config/secretConfigValues.dart' as secretConfig;
import 'package:flutter/services.dart';

import 'package:dtube_go/ui/widgets/DialogTemplates/DialogWithTitleLogo.dart';
import 'package:dtube_go/utils/Random/randomGenerator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

typedef ListOfString2VoidFunc = void Function(List<String>);

class ConnectYTChannelDialog extends StatefulWidget {
  ConnectYTChannelDialog(
      {Key? key, required this.user, required this.connectCallback})
      : super(key: key);
  User user;
  ListOfString2VoidFunc connectCallback;
  @override
  _ConnectYTChannelDialogState createState() => _ConnectYTChannelDialogState();
}

class _ConnectYTChannelDialogState extends State<ConnectYTChannelDialog> {
  late TextEditingController _channelIdController;
  late TextEditingController _verificationCodeController;

  late TransactionBloc _txBloc;
  bool _copyClicked = false;
  bool _channelVerified = false;

  void getNewCode() async {
    List<String> keys = generateNewKeyPair();
    setState(() {
      _verificationCodeController.text = keys[0];
    });
  }

  @override
  void initState() {
    super.initState();
    _channelIdController = new TextEditingController();
    _verificationCodeController = new TextEditingController();

    getNewCode();
  }

  @override
  Widget build(BuildContext context) {
    return PopUpDialogWithTitleLogo(
      titleWidgetPadding: 5.w,
      titleWidgetSize: 20.w,
      callbackOK: () {},
      titleWidget: FaIcon(
        FontAwesomeIcons.youtube,
        size: 20.w,
        color: globalRed,
      ),
      showTitleWidget: true,
      child: Builder(
        builder: (context) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Connect Youtube",
                      style: Theme.of(context).textTheme.headline4,
                    )),
                // Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Text(
                //       "To prevent users to share youtube videos from other channels you have to connect your youtube channel to your DTube account.",
                //       style: Theme.of(context).textTheme.bodyText1,
                //     )),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "1. Enter the channel ID of the youtube channel you want to connect:",
                      style: Theme.of(context).textTheme.bodyText1,
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    style: Theme.of(context).textTheme.bodyText1,
                    decoration:
                        new InputDecoration(labelText: "YT Channel ID*"),
                    controller: _channelIdController,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        child: Text("how to find my channel id?",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.blue)),
                        onTap: () {
                          launch(
                              "https://support.google.com/youtube/answer/3250431");
                        },
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "2. copy the code below and paste it into the bio of the desired youtube channel:",
                      style: Theme.of(context).textTheme.bodyText1,
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 50.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("code for channel bio:"),
                            Text(
                              _verificationCodeController.value.text,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                      Container(
                          width: 22.w,
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _copyClicked = true;
                                });
                                Clipboard.setData(ClipboardData(
                                    text: _verificationCodeController
                                        .value.text));
                              },
                              child: Center(child: Text("copy code")))),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "3. Click \"Check\" and after that \"Connect\"",
                      style: Theme.of(context).textTheme.bodyText1,
                    )),
                BlocBuilder<ThirdPartyMetadataBloc, ThirdPartyMetadataState>(
                  builder: (context, state) {
                    if (state is ThirdPartyMetadataErrorState) {
                      return InkWell(
                        child: Container(
                          padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0)),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "this was not a channel id",
                                style: Theme.of(context).textTheme.headline6,
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "Try again!",
                                style: Theme.of(context).textTheme.headline4,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        onTap: _copyClicked &&
                                _channelIdController.value.text != ""
                            ? () async {
                                BlocProvider.of<ThirdPartyMetadataBloc>(context)
                                    .add(
                                        CheckIfBioContainsVerificationCodeEvent(
                                            channelId:
                                                _channelIdController.value.text,
                                            code: _verificationCodeController
                                                .value.text));
                              }
                            : null,
                      );
                    } else if (state is ThirdPartyMetadataLoadingState) {
                      // Check is clicked - bloc is loading
                      return Container(
                        padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                        decoration: BoxDecoration(
                          color: globalRed,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0)),
                        ),
                        child: Text(
                          "Verifying ...",
                          style: Theme.of(context).textTheme.headline4,
                          textAlign: TextAlign.center,
                        ),
                      );
                    } else if (state
                        is ThirdPartyMetadataBioContainsCodeLoadedState) {
                      // Check is clicked - bloc is finished loading
                      if (state.value) {
                        return InkWell(
                          child: Container(
                            padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20.0),
                                  bottomRight: Radius.circular(20.0)),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "everything is fine",
                                  style: Theme.of(context).textTheme.headline6,
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  "Connect!",
                                  style: Theme.of(context).textTheme.headline4,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          onTap: _copyClicked &&
                                  _channelIdController.value.text != ""
                              ? () async {
                                  String encryptedChannelID =
                                      secretConfig.encryptYTChannelId(
                                          widget.user,
                                          _channelIdController.value.text);
                                  print(encryptedChannelID);
                                  widget.connectCallback([
                                    _channelIdController.value.text,
                                    encryptedChannelID
                                  ]);
                                  Navigator.of(context).pop();
                                }
                              : null,
                        );
                      } else {
                        return InkWell(
                          child: Container(
                            padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20.0),
                                  bottomRight: Radius.circular(20.0)),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "code not found",
                                  style: Theme.of(context).textTheme.headline6,
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  "Try again!",
                                  style: Theme.of(context).textTheme.headline4,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          onTap: _copyClicked &&
                                  _channelIdController.value.text != ""
                              ? () async {
                                  BlocProvider.of<ThirdPartyMetadataBloc>(
                                          context)
                                      .add(
                                          CheckIfBioContainsVerificationCodeEvent(
                                              channelId: _channelIdController
                                                  .value.text,
                                              code: _verificationCodeController
                                                  .value.text));
                                }
                              : null,
                        );
                      }
                    } else {
                      // Check is not clicked
                      return InkWell(
                        child: Container(
                          padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                          decoration: BoxDecoration(
                            color: _copyClicked &&
                                    _channelIdController.value.text != ""
                                ? globalRed
                                : Colors.grey,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0)),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "click this first to",
                                style: Theme.of(context).textTheme.headline6,
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "Check!",
                                style: Theme.of(context).textTheme.headline4,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        onTap: _copyClicked &&
                                _channelIdController.value.text != ""
                            ? () {
                                BlocProvider.of<ThirdPartyMetadataBloc>(context)
                                    .add(
                                        CheckIfBioContainsVerificationCodeEvent(
                                            channelId:
                                                _channelIdController.value.text,
                                            code: _verificationCodeController
                                                .value.text));
                              }
                            : null,
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
