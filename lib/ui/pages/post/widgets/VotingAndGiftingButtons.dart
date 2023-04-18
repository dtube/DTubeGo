import 'package:dtube_go/bloc/postdetails/postdetails_bloc_full.dart';
import 'package:dtube_go/bloc/settings/settings_bloc_full.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/post/widgets/VoteButtons.dart';
import 'package:dtube_go/ui/widgets/gifts/GiftBoxWidget.dart';
import 'package:dtube_go/utils/GlobalStorage/SecureStorage.dart' as sec;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VotingAndGiftBButtons extends StatefulWidget {
  VotingAndGiftBButtons({
    required this.author,
    required this.link,
    Key? key,
  }) : super(key: key);

  final String author;
  final String link;

  @override
  State<VotingAndGiftBButtons> createState() => _VotingAndGiftBButtonsState();
}

class _VotingAndGiftBButtonsState extends State<VotingAndGiftBButtons> {
  late double _defaultVoteWeightPosts = 0.0;
  late double _defaultVoteTipPosts = 0.0;
  late double _defaultVoteWeightComments = 0.0;
  late bool _fixedDownvoteActivated = false;
  late double _fixedDownvoteWeight = 0.0;

  TransactionBloc txBloc =
      new TransactionBloc(repository: TransactionRepositoryImpl());

  PostBloc postBloc = new PostBloc(repository: PostRepositoryImpl());

  @override
  void initState() {
    super.initState();
    postBloc.add(FetchPostEvent(
        widget.author, widget.link, "VotingAndGiftingButtons.dart"));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
          if (state is SettingsLoadedState) {
            _defaultVoteWeightPosts = double.parse(
                state.settings[sec.settingKey_defaultVotingWeight]!);
            _defaultVoteTipPosts = double.parse(
                state.settings[sec.settingKey_defaultVotingWeight]!);
            _defaultVoteWeightComments = double.parse(
                state.settings[sec.settingKey_defaultVotingWeightComments]!);
            _fixedDownvoteActivated =
                state.settings[sec.settingKey_FixedDownvoteActivated] == "true";
            _fixedDownvoteWeight = double.parse(
                state.settings[sec.settingKey_FixedDownvoteWeight]!);
            return MultiBlocProvider(
              providers: [
                BlocProvider<TransactionBloc>.value(
                  value: txBloc,
                ),
                BlocProvider<PostBloc>.value(value: postBloc),
                BlocProvider<UserBloc>(
                    create: (BuildContext context) =>
                        UserBloc(repository: UserRepositoryImpl())),
              ],
              child: VotingButtons(
                defaultVotingWeight: _defaultVoteWeightPosts,
                defaultVotingTip: _defaultVoteTipPosts,
                scale: 1,
                isPost: true,
                iconColor: globalAlmostWhite,
                focusVote: "false",
                fadeInFromLeft: false,
                fixedDownvoteActivated: _fixedDownvoteActivated,
                fixedDownvoteWeight: _fixedDownvoteWeight,
              ),
            );
          } else {
            return SizedBox(height: 0);
          }
        }),
        SizedBox(width: 8),
        GiftboxWidget(
          receiver: widget.author,
          link: widget.link,
          txBloc: BlocProvider.of<TransactionBloc>(context),
        ),
      ],
    );
  }
}
