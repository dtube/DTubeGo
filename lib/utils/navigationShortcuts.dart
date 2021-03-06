import 'package:dtube_go/bloc/auth/auth_bloc_full.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/ui/pages/post/postDetailPageV2.dart';
import 'package:dtube_go/ui/pages/user/User.dart';
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
