import 'package:dtube_go/bloc/postdetails/postdetails_bloc.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/ui/pages/post/widgets/ReplyButton.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';

class ShareAndCommentChips extends StatelessWidget {
  const ShareAndCommentChips({
    Key? key,
    required this.author,
    required this.directFocus,
    required this.link,
    required this.postBloc,
    required this.txBloc,
    required double defaultVoteWeightComments,
  })  : _defaultVoteWeightComments = defaultVoteWeightComments,
        super(key: key);

  final String author;
  final String link;
  final double _defaultVoteWeightComments;
  final String directFocus;
  final PostBloc postBloc;
  final TransactionBloc txBloc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(),
        Stack(
          // mainAxisAlignment: MainAxisAlignment.end,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: InputChip(
                label: FaIcon(FontAwesomeIcons.shareNodes),
                onPressed: () {
                  Share.share('https://d.tube/#!/v/' + author + '/' + link);
                },
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: ReplyButton(
                  icon: FaIcon(FontAwesomeIcons.comment),
                  author: author,
                  link: link,
                  parentAuthor: author,
                  parentLink: link,
                  votingWeight: _defaultVoteWeightComments,
                  scale: 1,
                  focusOnNewComment: directFocus == "newcomment",
                  isMainPost: true,
                  postBloc: postBloc,
                  txBloc: txBloc),
            ),
          ],
        ),
      ],
    );
  }
}
