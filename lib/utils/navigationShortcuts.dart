import 'package:dtube_togo/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_togo/bloc/user/user_bloc_full.dart';
import 'package:dtube_togo/ui/pages/post/postDetailPageV2.dart';
import 'package:dtube_togo/ui/pages/user/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void navigateToPostDetailPage(
    BuildContext context, String author, String link, String directFocus) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return PostDetailPage(
      author: author,
      link: link,
      recentlyUploaded: false,
      directFocus: directFocus,
    );
  }));
}

void navigateToUserDetailPage(BuildContext context, String username) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    // return BlocProvider<UserBloc>(
    //   create: (context) {
    //     return UserBloc(repository: UserRepositoryImpl())

    //   },
    //   child:
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (BuildContext context) =>
              UserBloc(repository: UserRepositoryImpl())
                ..add(FetchAccountDataEvent(username)),
        ),
        BlocProvider<TransactionBloc>(
          create: (BuildContext context) =>
              TransactionBloc(repository: TransactionRepositoryImpl()),
        ),
      ],
      child: UserPage(
        username: username,
        ownUserpage: false,
      ),
    );
  }));
}
