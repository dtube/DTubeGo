import 'dart:async';

import 'package:dtube_togo/bloc/auth/auth_bloc_full.dart';
import 'package:dtube_togo/bloc/config/txTypes.dart';
import 'package:dtube_togo/bloc/search/search_bloc_full.dart';
import 'package:dtube_togo/bloc/user/user_bloc_full.dart';
import 'package:dtube_togo/style/ThemeData.dart';
import 'package:dtube_togo/style/styledCustomWidgets.dart';
import 'package:dtube_togo/ui/widgets/AccountAvatar.dart';
import 'package:dtube_togo/utils/navigationShortcuts.dart';
import 'package:dtube_togo/utils/shortBalanceStrings.dart';

import 'package:intl/intl.dart';
import 'package:dtube_togo/bloc/notification/notification_bloc_full.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();

  SearchScreen({
    Key? key,
  }) : super(key: key);
}

class _SearchScreenState extends State<SearchScreen> {
  late SearchBloc searchBloc;
  late TextEditingController searchTextController;
  final _debouncer = Debounce(milliseconds: 700);
  String currentSearch = "";
  @override
  void initState() {
    super.initState();
    searchBloc = BlocProvider.of<SearchBloc>(context);
    searchTextController = TextEditingController();
    searchTextController.addListener(_sendRequest);
    //  searchBloc.add(FetchNotificationsEvent([])); // statements;
  }

  @override
  void dispose() {
    searchTextController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void _sendRequest() {
    if (searchTextController.text.length >= 3 &&
        searchTextController.text != currentSearch) {
      _debouncer.run(() {
        currentSearch = searchTextController.text;
        searchBloc.add(FetchSearchResultsEvent(searchTextController.text));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: dtubeSubAppBar(true, "", context, null),
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchTextController,
                //maxLength: 100
                //autofocus: true,
                cursorColor: globalRed,
                maxLines: 1,
              ),
            ),
            Container(
              height: 500,
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchInitialState) {
                    return buildLoading();
                  } else if (state is SearchLoadingState) {
                    return buildLoading();
                  } else if (state is SearchLoadedState) {
                    return buildResultsList(state.searchResults);
                  } else if (state is SearchErrorState) {
                    return buildErrorUi(state.message);
                  } else {
                    return buildErrorUi('test');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildErrorUi(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget buildResultsList(SearchResults searchResults) {
    return ListView.builder(
      itemCount: searchResults.hits!.hits!.length,
      itemBuilder: (ctx, pos) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: InkWell(
            child: CustomListItem(
              id: searchResults.hits!.hits![pos].sId,
              name: searchResults.hits!.hits![pos].sSource!.name,
              dtcBalance: searchResults.hits!.hits![pos].sSource!.balance,
              vpBalance: searchResults.hits!.hits![pos].sSource!.vt,
            ),

            // onTap: () {
            //   List<int> navigatableTxsUser = [1, 2, 7, 8];
            //   List<int> navigatableTxsPost = [4, 5, 13, 19]
            //   if (navigatableTxsUser.contains(notifications[pos].tx.type)) {
            //     //load user and navigate
            //   }
            //   if (navigatableTxsPost.contains(notifications[pos].tx.type)) {
            //     //load post and navigate to it

            //     //           Navigator.push(context, MaterialPageRoute(builder: (context) {
            //     // return PostDetailPage(
            //     //   post: postData,
            //     // );
            //   }
            //},
          ),
        );
      },
    );
  }
}

class CustomListItem extends StatelessWidget {
  const CustomListItem({
    Key? key,
    required this.id,
    required this.name,
    required this.dtcBalance,
    required this.vpBalance,
  }) : super(key: key);

  final String id;
  final String name;
  final int dtcBalance;
  final int vpBalance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigateToUserDetailPage(context, name);
      },
      child: Card(
        // height: 35,
        margin: EdgeInsets.all(8.0),
        color: globalBlue,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  BlocProvider<UserBloc>(
                    create: (BuildContext context) =>
                        UserBloc(repository: UserRepositoryImpl()),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: AccountAvatar(username: name, size: 40),
                    ),
                  ),
                  Text(
                    name,
                    style: Theme.of(context).textTheme.headline4,
                  )
                ],
              ),
              Column(
                children: [
                  Text(
                    shortDTC(dtcBalance) + 'DTC',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(
                    shortDTC(vpBalance) + 'VP',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Debounce {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debounce({required this.milliseconds});

  void initState() {}
  run(VoidCallback action) {
    if (_timer != null) _timer!.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
