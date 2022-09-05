import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/ui/widgets/DialogTemplates/DialogWithTitleLogo.dart';
import 'package:dtube_go/ui/widgets/Inputs/OverlayInputs.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:flutter/material.dart';

class CommentDialogDesktop extends StatefulWidget {
  CommentDialogDesktop(
      {Key? key,
      required this.originAuthor,
      required this.txBloc,
      required this.originLink,
      required this.defaultCommentVote,
      this.okCallback,
      this.cancelCallback})
      : super(key: key);
  final TransactionBloc txBloc;
  final String originAuthor;
  final String originLink;
  final double defaultCommentVote;
  final VoidCallback? okCallback;
  final VoidCallback? cancelCallback;

  @override
  _CommentDialogDesktopState createState() => _CommentDialogDesktopState();
}

class _CommentDialogDesktopState extends State<CommentDialogDesktop> {
  late TextEditingController _commentController;

  late TransactionBloc _txBloc;
  late UserBloc _userBloc;

  @override
  void initState() {
    super.initState();

    _commentController = new TextEditingController();
    _userBloc = BlocProvider.of<UserBloc>(context);
    _userBloc.add(FetchDTCVPEvent());

    _txBloc = widget.txBloc;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.cancelCallback != null) {
          widget.cancelCallback!();
        }
        return true;
      },
      child: PopUpDialogWithTitleLogo(
        titleWidgetPadding: 25,
        titleWidgetSize: 50,
        height: 300,
        width: 400,
        callbackOK: () {},
        titleWidget: FaIcon(
          FontAwesomeIcons.comments,
          size: 50,
          color: globalBGColor,
        ),
        showTitleWidget: true,
        child: Builder(builder: (context) {
          return BlocBuilder<UserBloc, UserState>(
            bloc: _userBloc,
            builder: (context, state) {
              if (state is UserInitialState) {
                return DtubeLogoPulseWithSubtitle(
                    subtitle: "loading your balance...", size: 10.w);
              } else if (state is UserDTCVPLoadingState) {
                return DtubeLogoPulseWithSubtitle(
                    subtitle: "loading your balance...", size: 10.w);
              } else if (state is UserDTCVPLoadedState) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: OverlayTextInput(
                        autoFocus: true,
                        textEditingController: _commentController,
                        label: "New Comment",
                      ),
                    ),
                    InkWell(
                        child: Container(
                          padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                          decoration: BoxDecoration(
                            color: globalRed,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0)),
                          ),
                          child: Text(
                            "Send Comment",
                            style: Theme.of(context).textTheme.headline4,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        onTap: () {
                          UploadData _uploadData = new UploadData(
                              link: "",
                              parentAuthor: widget.originAuthor,
                              parentPermlink: widget.originLink,
                              title: "",
                              description: _commentController.value.text,
                              tag: "",
                              vpPercent: widget.defaultCommentVote,
                              vpBalance: state.vtBalance['v']!,
                              burnDtc: 0,
                              dtcBalance:
                                  0, // TODO promoted comment implementation missing
                              isPromoted: false,
                              duration: "",
                              thumbnailLocation: "",
                              localThumbnail: false,
                              videoLocation: "",
                              localVideoFile: false,
                              originalContent: false,
                              nSFWContent: false,
                              unlistVideo: false,
                              isEditing: false,
                              videoSourceHash: "",
                              video240pHash: "",
                              video480pHash: "",
                              videoSpriteHash: "",
                              thumbnail640Hash: "",
                              thumbnail210Hash: "",
                              uploaded: false,
                              crossPostToHive: false);

                          _txBloc.add(SendCommentEvent(_uploadData));
                          Navigator.of(context).pop();
                          if (widget.okCallback != null) {
                            widget.okCallback!();
                          }
                        }),
                  ],
                );
              }
              return DtubeLogoPulseWithSubtitle(
                  subtitle: "loading your balance...", size: 30.w);
            },
          );
        }),
      ),
    );
  }
}
