import 'package:dtube_go/ui/pages/post/Layouts/postDetailsDesktop.dart';
import 'package:dtube_go/ui/pages/post/Layouts/postDetailsMobile.dart';
import 'package:dtube_go/ui/pages/post/Layouts/postDetailsTablet.dart';

import 'package:dtube_go/ui/MainContainer/NavigationContainer.dart';

import 'package:dtube_go/utils/Layout/ResponsiveLayout.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter/material.dart';
import 'package:dtube_go/bloc/auth/auth_bloc_full.dart';
import 'package:dtube_go/bloc/settings/settings_bloc_full.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/bloc/postdetails/postdetails_bloc_full.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostDetailPage extends StatefulWidget {
  String link;
  String author;
  bool recentlyUploaded;
  String directFocus;
  VoidCallback? onPop;

  PostDetailPage(
      {required this.link,
      required this.author,
      required this.recentlyUploaded,
      required this.directFocus,
      this.onPop});

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  int reloadCount = 0;
  bool flagged = false;

  Future<bool> _onWillPop() async {
    if (widget.recentlyUploaded) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => MultiBlocProvider(providers: [
                    BlocProvider<UserBloc>(
                      create: (BuildContext context) =>
                          UserBloc(repository: UserRepositoryImpl()),
                    ),
                    BlocProvider<AuthBloc>(
                      create: (BuildContext context) =>
                          AuthBloc(repository: AuthRepositoryImpl()),
                    ),
                  ], child: NavigationContainer())),
          (route) => false);
    } else {
      Navigator.pop(context);
    }
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PostBloc>(
          create: (BuildContext context) =>
              PostBloc(repository: PostRepositoryImpl())
                ..add(FetchPostEvent(
                    widget.author, widget.link, "PageDetailsPageV2.dart 1")),
        ),
        BlocProvider<UserBloc>(
            create: (BuildContext context) =>
                UserBloc(repository: UserRepositoryImpl())),
        BlocProvider<SettingsBloc>(
          create: (BuildContext context) =>
              SettingsBloc()..add(FetchSettingsEvent()),
        ),
      ],
      // child: WillPopScope(
      //     onWillPop: _onWillPop,
      child: new WillPopScope(
          onWillPop: () async {
            if (widget.onPop != null) {
              widget.onPop!();
              if (flagged) {
                await Future.delayed(Duration(seconds: 3));
                Phoenix.rebirth(context);
              }
            }

            return true;
          },
          child: ResponsiveLayout(
            desktopBody: PostDetailPageDesktop(
                link: widget.link,
                author: widget.author,
                recentlyUploaded: widget.recentlyUploaded,
                directFocus: widget.directFocus),
            mobileBody: PostDetailPageMobile(
                link: widget.link,
                author: widget.author,
                recentlyUploaded: widget.recentlyUploaded,
                directFocus: widget.directFocus),
            tabletBody: PostDetailPageTablet(
                link: widget.link,
                author: widget.author,
                recentlyUploaded: widget.recentlyUploaded,
                directFocus: widget.directFocus),
          )
          //)
          ),
    );
  }
}
