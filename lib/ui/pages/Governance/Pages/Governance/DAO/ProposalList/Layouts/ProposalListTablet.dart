import 'package:dtube_go/bloc/dao/dao_bloc_full.dart';
import 'package:dtube_go/ui/pages/Governance/Pages/Governance/DAO/Widgets/ProposalCard/ProposalCard.dart';
import 'package:dtube_go/ui/pages/Governance/Pages/Governance/DAO/Widgets/ProposalCard/ProposalCardDesktop.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProposalListTablet extends StatefulWidget {
  const ProposalListTablet(
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
  _ProposalListTabletState createState() => _ProposalListTabletState();
}

class _ProposalListTabletState extends State<ProposalListTablet> {
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
            size: 10.w,
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
            return MasonryGridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.zero,
                addAutomaticKeepAlives: true,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                key: new PageStorageKey('daos' + widget.daoState + 'listview'),
                itemCount: _daoItems.length,
                itemBuilder: (ctx, pos) {
                  return ProposalCardDesktop(
                      daoItem: _daoItems[pos],
                      daoThreshold: widget.daoVotingThreshold);
                });
          }
        }
        return DtubeLogoPulseWithSubtitle(
          subtitle: "loading decentralized autonomous organization..",
          size: 10.w,
        );
      },
    );
  }
}
