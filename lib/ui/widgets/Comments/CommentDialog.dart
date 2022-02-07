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

class CommentDialog extends StatefulWidget {
  CommentDialog(
      {Key? key,
      required this.originAuthor,
      required this.txBloc,
      required this.originLink,
      required this.defaultCommentVote,
      this.okCallback,
      this.cancelCallback})
      : super(key: key);
  TransactionBloc txBloc;
  String originAuthor;
  String originLink;
  double defaultCommentVote;
  VoidCallback? okCallback;
  VoidCallback? cancelCallback;

  @override
  _CommentDialogState createState() => _CommentDialogState();
}

class _CommentDialogState extends State<CommentDialog> {
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
        titleWidgetPadding: 5.w,
        titleWidgetSize: 20.w,
        callbackOK: () {},
        titleWidget: FaIcon(
          FontAwesomeIcons.comments,
          size: 20.w,
          color: globalBGColor,
        ),
        showTitleWidget: true,
        child: Builder(builder: (context) {
          return BlocBuilder<UserBloc, UserState>(
            bloc: _userBloc,
            builder: (context, state) {
              if (state is UserInitialState) {
                return DtubeLogoPulseWithSubtitle(
                    subtitle: "loading your balance...", size: 30.w);
              } else if (state is UserDTCVPLoadingState) {
                return DtubeLogoPulseWithSubtitle(
                    subtitle: "loading your balance...", size: 30.w);
              } else if (state is UserDTCVPLoadedState) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 1.h, bottom: 2.h, left: 2.w, right: 2.w),
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
                  ),
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
