import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:dtube_go/utils/Navigation/navigationShortcuts.dart';
import 'package:flutter/foundation.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/ui/widgets/AccountAvatar.dart';
import 'package:dtube_go/ui/pages/post/widgets/ReplyButton.dart';
import 'package:dtube_go/ui/pages/post/widgets/VoteButtons.dart';

import 'package:dtube_go/bloc/postdetails/postdetails_bloc_full.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CommentContainer extends StatelessWidget {
  const CommentContainer(
      {Key? key,
      required this.defaultVoteWeightComments,
      //required this.currentVT,
      required this.defaultVoteTipComments,
      required this.blockedUsers,
      required this.fixedDownvoteActivated,
      required this.fixedDownvoteWeight,
      required this.postBloc,
      required this.txBloc,
      required this.height,
      required this.avatarSize,
      required this.shrinkButtons})
      : super(key: key);

  final double defaultVoteWeightComments;
  //final int currentVT;
  final double defaultVoteTipComments;
  final String blockedUsers;
  final bool fixedDownvoteActivated;
  final double fixedDownvoteWeight;
  final PostBloc postBloc;
  final TransactionBloc txBloc;
  final double height;
  final double avatarSize;
  final bool shrinkButtons;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
        bloc: postBloc,
        builder: (context, state) {
          if (state is PostLoadingState) {
            return Center(
              child: DtubeLogoPulseWithSubtitle(
                subtitle: "loading comments...",
                size: kIsWeb ? 10.w : 30.w,
              ),
            );
          } else if (state is PostLoadedState) {
            return BlocListener<TransactionBloc, TransactionState>(
                bloc: txBloc,
                listener: (context, txState) {
                  if (txState is TransactionSent) {
                    print(state.post.author + '/' + state.post.link);
                    postBloc.add(FetchPostEvent(
                        state.post.author, state.post.link, "Comments.dart 1"));
                  }
                },
                child: Column(
                  children: [
                    Text("Comments (" +
                        state.post.comments!.length.toString() +
                        ")"),
                    Container(
                      // height will be max 50.h
                      height: height,
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: ListView.builder(
                          itemCount: state.post.comments!.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (BuildContext context, int index) =>
                              Column(
                            children: [
                              CommentDisplay(
                                avatarSize: avatarSize,
                                entry: state.post.comments![index],
                                defaultVoteWeight: defaultVoteWeightComments,
                                // currentVT: currentVT,
                                parentAuthor: state.post.author,
                                parentLink: state.post.link,
                                defaultVoteTip: defaultVoteTipComments,
                                parentContext: context,
                                blockedUsers: blockedUsers.split(","),
                                fixedDownvoteActivated: fixedDownvoteActivated,
                                fixedDownvoteWeight: fixedDownvoteWeight,
                                postBloc: new PostBloc(
                                    repository: PostRepositoryImpl()),
                                txBloc: txBloc,
                                shrinkButtons: shrinkButtons,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ));
          }
          return Center(
            child: DtubeLogoPulseWithSubtitle(
              subtitle: "loading comments...",
              size: kIsWeb ? 10.w : 30.w,
            ),
          );
        });
  }
}

// Create the Widget for the row
class CommentDisplay extends StatelessWidget {
  const CommentDisplay(
      {required this.entry,
      required this.defaultVoteWeight,
      //  required this.currentVT,
      required this.parentAuthor,
      required this.parentLink,
      required this.defaultVoteTip,
      required this.parentContext,
      required this.blockedUsers,
      required this.fixedDownvoteActivated,
      required this.fixedDownvoteWeight,
      required this.postBloc,
      required this.txBloc,
      required this.avatarSize,
      required this.shrinkButtons});
  final Comment entry;
  final double defaultVoteWeight;
  final double defaultVoteTip;
  final bool fixedDownvoteActivated;
  final double fixedDownvoteWeight;
  final double avatarSize;

  final String parentAuthor;
  final String parentLink;
  //final int currentVT;
  final BuildContext parentContext;
  final List<String> blockedUsers;
  final PostBloc postBloc;
  final TransactionBloc txBloc;
  final bool shrinkButtons;

  // This function recursively creates the multi-level list rows.
  Widget _buildTiles(Comment root) {
    final PostBloc subPostBloc = new PostBloc(repository: PostRepositoryImpl())
      ..add(FetchPostEvent(root.author, root.link, "Comments.dart 2"));
    final TransactionBloc subTxBloc =
        new TransactionBloc(repository: TransactionRepositoryImpl());

    if (root.childComments == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommentItem(
              blockedUsers: blockedUsers,
              parentContext: parentContext,
              txBloc: txBloc,
              subPostBloc: subPostBloc,
              defaultVoteWeight: defaultVoteWeight,
              defaultVoteTip: defaultVoteTip,
              fixedDownvoteActivated: fixedDownvoteActivated,
              fixedDownvoteWeight: fixedDownvoteWeight,
              comment: root,
              avatarSize: avatarSize,
              shrinkButtons: shrinkButtons),
          Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: BlocProvider.value(
                  value: txBloc,
                  child: ReplyButton(
                      icon: FaIcon(FontAwesomeIcons.comments),
                      author: root.author,
                      link: root.link,
                      parentAuthor: parentAuthor,
                      parentLink: parentLink,
                      votingWeight: defaultVoteWeight,
                      scale: shrinkButtons ? 0.8 : 1,
                      focusOnNewComment: false,
                      isMainPost: false,
                      postBloc: subPostBloc,
                      txBloc: txBloc),
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CommentItem(
              blockedUsers: blockedUsers,
              parentContext: parentContext,
              txBloc: txBloc,
              subPostBloc: subPostBloc,
              defaultVoteWeight: defaultVoteWeight,
              defaultVoteTip: defaultVoteTip,
              fixedDownvoteActivated: fixedDownvoteActivated,
              fixedDownvoteWeight: fixedDownvoteWeight,
              comment: root,
              avatarSize: avatarSize,
              shrinkButtons: shrinkButtons,
            ),
            Align(
              alignment: Alignment.topRight,
              child: BlocProvider.value(
                value: txBloc,
                child: ReplyButton(
                    icon: FaIcon(FontAwesomeIcons.comments),
                    author: root.author,
                    link: root.link,
                    parentAuthor: parentAuthor,
                    parentLink: parentLink,
                    votingWeight: defaultVoteWeight,
                    scale: 0.8,
                    focusOnNewComment: false,
                    isMainPost: false,
                    postBloc: subPostBloc,
                    txBloc: txBloc),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 4.w),
              child: Column(
                children: root.childComments!.map<Widget>(_buildTiles).toList(),
              ),
            ),
          ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}

class CommentItem extends StatelessWidget {
  const CommentItem(
      {Key? key,
      required this.blockedUsers,
      required this.parentContext,
      required this.txBloc,
      required this.subPostBloc,
      required this.defaultVoteWeight,
      required this.defaultVoteTip,
      required this.fixedDownvoteActivated,
      required this.fixedDownvoteWeight,
      required this.comment,
      required this.avatarSize,
      required this.shrinkButtons})
      : super(key: key);

  final List<String> blockedUsers;
  final BuildContext parentContext;
  final TransactionBloc txBloc;
  final PostBloc subPostBloc;
  final double defaultVoteWeight;
  final double defaultVoteTip;
  final bool fixedDownvoteActivated;
  final double fixedDownvoteWeight;
  final Comment comment;
  final double avatarSize;
  final bool shrinkButtons;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        !blockedUsers.contains(comment.author)
            ? GestureDetector(
                onTap: () {
                  navigateToUserDetailPage(
                      parentContext, comment.author, () {});
                },
                child: AccountIconBase(
                  username: comment.author,
                  avatarSize: avatarSize,
                  showVerified: true,
                  // showName: true,
                  // width: 65.w,
                  // height: 8.h,
                ),
              )
            : AvatarErrorPlaceholder(),
        Expanded(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 2.w),
                    child: Text(comment.author,
                        style: Theme.of(parentContext).textTheme.headline6),
                  ),
                  MultiBlocProvider(
                    providers: [
                      BlocProvider<TransactionBloc>.value(value: txBloc),
                      BlocProvider<PostBloc>.value(value: subPostBloc),
                      BlocProvider<UserBloc>(
                          create: (BuildContext context) =>
                              UserBloc(repository: UserRepositoryImpl())),
                    ],
                    child: VotingButtons(
                      defaultVotingWeight: defaultVoteWeight,
                      defaultVotingTip: defaultVoteTip,
                      scale: shrinkButtons ? 0.8 : 1,
                      isPost: false,
                      iconColor: globalAlmostWhite,
                      focusVote: "",
                      fadeInFromLeft: false,
                      fixedDownvoteActivated: fixedDownvoteActivated,
                      fixedDownvoteWeight: fixedDownvoteWeight,
                    ),
                  ),
                ],
              ),
              Container(
                width: 80.w,
                child: Text(
                  !blockedUsers.contains(comment.author)
                      ? comment.commentjson.description
                      : "author is blocked",
                  style: !blockedUsers.contains(comment.author)
                      ? Theme.of(parentContext).textTheme.bodyText2
                      : Theme.of(parentContext)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: globalRed),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
