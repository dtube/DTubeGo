import 'package:dtube_go/bloc/auth/auth_bloc_full.dart';
import 'package:dtube_go/bloc/dao/dao_bloc_full.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/ui/pages/post/postDetailPageV2.dart';
import 'package:dtube_go/ui/pages/user/User.dart';
import 'package:dtube_go/ui/pages/wallet/Pages/Governance/DAO/DetailsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void navigateToPostDetailPage(BuildContext context, String author, String link,
    String directFocus, bool recentlyUploaded, VoidCallback onPop) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return PostDetailPage(
      author: author,
      link: link,
      recentlyUploaded: recentlyUploaded,
      directFocus: directFocus,
      onPop: onPop,
    );
  }));
}

void navigateToDaoDetailPage(
    BuildContext context, DAOItem daoItem, int daoThreshold) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return BlocProvider<DaoBloc>(
        create: (context) {
          // add the AppStartedEvent to try to login with perhaps existing login credentails and forward to the startup "dialog"
          return DaoBloc(repository: DaoRepositoryImpl())
            ..add(FetchProsposalEvent(id: daoItem.iId!));
        },
        child: ProposalDetailPage(
          proposalId: daoItem.iId!,
          daoThreshold: daoThreshold,
        ));
  }));
}

void navigateToUserDetailPage(
    BuildContext context, String username, VoidCallback onPop) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (BuildContext context) =>
              UserBloc(repository: UserRepositoryImpl())
          //..add(FetchAccountDataEvent(username))
          ,
        ),
        BlocProvider<TransactionBloc>(
          create: (BuildContext context) =>
              TransactionBloc(repository: TransactionRepositoryImpl()),
        ),
        BlocProvider<AuthBloc>(
          create: (BuildContext context) =>
              AuthBloc(repository: AuthRepositoryImpl()),
        ),
      ],
      child: UserPage(
        username: username,
        ownUserpage: false,
        onPop: onPop,
      ),
    );
  }));
}
