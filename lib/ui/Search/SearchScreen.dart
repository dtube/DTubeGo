import 'dart:async';

import 'package:dtube_togo/bloc/config/txTypes.dart';
import 'package:dtube_togo/bloc/search/search_bloc_full.dart';
import 'package:dtube_togo/bloc/user/user_bloc_full.dart';
import 'package:dtube_togo/style/ThemeData.dart';
import 'package:dtube_togo/style/styledCustomWidgets.dart';
import 'package:dtube_togo/ui/widgets/AccountAvatar.dart';

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

  @override
  void initState() {
    super.initState();
    searchBloc = BlocProvider.of<SearchBloc>(context);
    searchTextController = TextEditingController();
    //  searchBloc.add(FetchNotificationsEvent([])); // statements;
  }

  late Timer searchOnStoppedTyping;
  _onChangeHandler(value) {
    const duration = Duration(
        milliseconds:
            800); // set the duration that you want call search() after that.
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping.cancel()); // clear timer
    }
    setState(
        () => searchOnStoppedTyping = new Timer(duration, () => search(value)));
  }

  search(value) {
    print('hello world from search . the value is $value');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: dtubeSubAppBar(true, "", context, null),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
                controller: searchTextController,
                //maxLength: 100
                autofocus: true,
                cursorColor: globalRed,
                maxLines: 1,
                onChanged: _onChangeHandler),
          ),
          Container(
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

  Widget buildResultsList(List<SearchResult> searchResults) {
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (ctx, pos) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: InkWell(
            child: CustomListItem(id: searchResults[pos].sId, name: "test"),
            // onTap: () {
            //   List<int> navigatableTxsUser = [1, 2, 7, 8];
            //   List<int> navigatableTxsPost = [4, 5, 13, 19];
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
  }) : super(key: key);

  final String id;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 35,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BlocProvider<UserBloc>(
              create: (BuildContext context) =>
                  UserBloc(repository: UserRepositoryImpl()),
              child: AccountAvatar(username: name, size: 30),
            ),
            Text(id.toString())
          ],
        ),
      ),
    );
  }
}
