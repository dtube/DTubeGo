import 'package:dtube_togo/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_togo/ui/widgets/AccountAvatar.dart';
import 'package:dtube_togo/ui/pages/post/widgets/ReplyButton.dart';
import 'package:dtube_togo/ui/pages/post/widgets/VoteButtons.dart';

import 'package:dtube_togo/bloc/postdetails/postdetails_bloc_full.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Create the Widget for the row
class CommentDisplay extends StatelessWidget {
  const CommentDisplay(this.entry, this.defaultVoteWeight, this._currentVT,
      this.parentAuthor, this.parentLink, this.defaultVoteTip);
  final Comment entry;
  final double defaultVoteWeight;
  final double defaultVoteTip;
  final String parentAuthor;
  final String parentLink;
  final int _currentVT;

  // This function recursively creates the multi-level list rows.
  Widget _buildTiles(Comment root) {
    if (root.childComments == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 30,
                height: 30,
                child: AccountAvatarBase(
                    username: root.author, size: 30, showVerified: true),
              ),
              SizedBox(
                width: 8,
              ),
              Container(
                width: 300,
                child: Text(
                  root.commentjson.description,
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
            ],
          ),
          Stack(
            children: [
              VotingButtons(
                author: root.author,
                link: root.link,
                alreadyVoted: root.alreadyVoted,
                alreadyVotedDirection: root.alreadyVotedDirection,
                upvotes: root.upvotes,
                downvotes: root.downvotes,
                defaultVotingWeight: defaultVoteWeight,
                defaultVotingTip: defaultVoteTip,
                currentVT: _currentVT,
                scale: 0.8,
                isPost: false,
                focusVote: false,
              ),
              Align(
                alignment: Alignment.topRight,
                child: BlocProvider(
                  create: (context) =>
                      TransactionBloc(repository: TransactionRepositoryImpl()),
                  child: ReplyButton(
                    icon: FaIcon(FontAwesomeIcons.comments),
                    author: root.author,
                    link: root.link,
                    parentAuthor: parentAuthor,
                    parentLink: parentLink,
                    votingWeight: defaultVoteWeight,
                    scale: 0.8,
                    focusOnNewComment: false,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            SizedBox(
              width: 30,
              height: 30,
              child: AccountAvatarBase(
                  username: root.author, size: 30, showVerified: true),
            ),
            SizedBox(
              width: 8,
            ),
            Container(
              width: 300,
              child: Text(
                root.commentjson.description,
                style: TextStyle(fontSize: 12.0),
              ),
            ),
          ],
        ),
        Stack(
          children: [
            VotingButtons(
              author: root.author,
              link: root.link,
              alreadyVoted: root.alreadyVoted,
              alreadyVotedDirection: root.alreadyVotedDirection,
              upvotes: root.upvotes,
              downvotes: root.downvotes,
              defaultVotingWeight: defaultVoteWeight,
              defaultVotingTip: defaultVoteTip,
              currentVT: _currentVT,
              scale: 0.8,
              isPost: false,
              focusVote: false,
            ),
            Align(
              alignment: Alignment.topRight,
              child: BlocProvider(
                create: (context) =>
                    TransactionBloc(repository: TransactionRepositoryImpl()),
                child: ReplyButton(
                  icon: FaIcon(FontAwesomeIcons.comments),
                  author: root.author,
                  link: root.link,
                  parentAuthor: parentAuthor,
                  parentLink: parentLink,
                  votingWeight: defaultVoteWeight,
                  scale: 0.8,
                  focusOnNewComment: false,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Column(
            children: root.childComments!.map<Widget>(_buildTiles).toList(),
          ),
        ),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("comment display");
    return _buildTiles(
      entry,
    );
  }
}
