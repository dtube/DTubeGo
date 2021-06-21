import 'package:dtube_togo/ui/pages/post/widgets/ReplyButton.dart';
import 'package:dtube_togo/ui/pages/post/widgets/VoteButtons.dart';

import 'package:dtube_togo/bloc/postdetails/postdetails_bloc_full.dart';

import 'package:flutter/material.dart';

// Create the Widget for the row
class CommentDisplay extends StatelessWidget {
  const CommentDisplay(this.entry, this.defaultVoteWeight);
  final Comment entry;
  final double defaultVoteWeight;

  // This function recursively creates the multi-level list rows.
  Widget _buildTiles(Comment root) {
    if (root.childComments == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            root.author + ': ' + root.commentjson.description,
            style: TextStyle(fontSize: 12.0),
          ),
          Stack(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VotingButtons(
                author: root.author,
                link: root.link,
                alreadyVoted: root.alreadyVoted,
                alreadyVotedDirection: root.alreadyVotedDirection,
                upvotes: root.upvotes,
                downvotes: root.downvotes,
                defaultVotingWeight: defaultVoteWeight,
              ),
              Align(
                alignment: Alignment.topRight,
                child: ReplyButton(
                  title: "reply comment",
                  author: root.author,
                  link: root.link,
                  votingWeight: defaultVoteWeight,
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          root.author + ': ' + root.commentjson.description,
          style: TextStyle(fontSize: 12.0),
        ),
        Stack(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VotingButtons(
              author: root.author,
              link: root.link,
              alreadyVoted: root.alreadyVoted,
              alreadyVotedDirection: root.alreadyVotedDirection,
              upvotes: root.upvotes,
              downvotes: root.downvotes,
              defaultVotingWeight: defaultVoteWeight,
            ),
            Align(
              alignment: Alignment.topRight,
              child: ReplyButton(
                title: "reply comment",
                author: root.author,
                link: root.link,
                votingWeight: defaultVoteWeight,
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
