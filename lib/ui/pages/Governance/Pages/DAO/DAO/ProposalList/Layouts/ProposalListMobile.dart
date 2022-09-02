import 'package:dtube_go/bloc/dao/dao_bloc_full.dart';
import 'package:dtube_go/ui/pages/Governance/Pages/DAO/DAO/Widgets/ProposalCard/ProposalCard.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProposalListMobile extends StatefulWidget {
  const ProposalListMobile(
      {Key? key,
      required this.daoState,
      required this.daoType,
      required this.daoVotingThreshold,
      required this.daoVotingPeriod})
      : super(key: key);
  final String daoState;
  final String daoType;
  final int daoVotingThreshold;
  final int daoVotingPeriod;

  @override
  _ProposalListMobileState createState() => _ProposalListMobileState();
}

class _ProposalListMobileState extends State<ProposalListMobile> {
  late DaoBloc _daoBloc;

  @override
  void initState() {
    super.initState();
    _daoBloc = BlocProvider.of<DaoBloc>(context);
    _daoBloc
        .add(FetchDaoEvent(daoState: widget.daoState, daoType: widget.daoType));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DaoBloc, DaoState>(
      builder: (context, state) {
        if (state is DaoLoadingState) {
          return DtubeLogoPulseWithSubtitle(
            subtitle: "loading decentralized autonomous organization..",
            size: 30.w,
          );
        }
        if (state is DaoLoadedState) {
          List<DAOItem> _daoItems = state.daoList;
          if (_daoItems.isEmpty) {
            return Center(
                child: Text(
              "no proposals found.",
              style: Theme.of(context).textTheme.bodyText1,
            ));
          } else {
            return ListView.builder(
                padding: EdgeInsets.zero,
                addAutomaticKeepAlives: true,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                key: new PageStorageKey('daos' + widget.daoState + 'listview'),
                itemCount: _daoItems.length,
                itemBuilder: (ctx, pos) {
                  return ProposalCard(
                      daoItem: _daoItems[pos],
                      daoThreshold: widget.daoVotingThreshold);
                });
          }
        }
        return DtubeLogoPulseWithSubtitle(
          subtitle: "loading decentralized autonomous organization..",
          size: 30.w,
        );
      },
    );
  }
}
