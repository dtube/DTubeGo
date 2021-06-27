import 'package:cached_network_image/cached_network_image.dart';

import 'package:dtube_togo/bloc/user/user_bloc_full.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';

class AccountAvatarBase extends StatelessWidget {
  const AccountAvatarBase({Key? key, required this.username}) : super(key: key);
  final String username;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc(repository: UserRepositoryImpl()),
      child: AccountAvatar(
        username: username,
      ),
    );
  }
}

class AccountAvatar extends StatefulWidget {
  const AccountAvatar({Key? key, required this.username}) : super(key: key);
  final username;

  @override
  _AccountAvatarState createState() => _AccountAvatarState();
}

class _AccountAvatarState extends State<AccountAvatar> {
  late UserBloc _userBlocAvatar;
  @override
  void initState() {
    super.initState();
    _userBlocAvatar = BlocProvider.of<UserBloc>(context);
    _userBlocAvatar.add(FetchAccountDataEvent(widget.username));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      bloc: _userBlocAvatar,
      builder: (context, state) {
        if (state is UserLoadingState) {
          return CircularProgressIndicator();
        } else if (state is UserLoadedState &&
            state.user.json_string != null &&
            state.user.json_string?.profile != null &&
            state.user.json_string?.profile?.avatar != "" &&
            state.user.name == widget.username) {
          try {
            return CachedNetworkImage(
              imageUrl: state.user.json_string!.profile!.avatar!
                  .replaceAll("http:", "https:"),
              imageBuilder: (context, imageProvider) => Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              placeholder: (context, url) => Container(
                  height: 50,
                  width: 50,
                  child: new CircularProgressIndicator()),
              errorWidget: (context, url, error) => new Icon(Icons.error),
            );
          } catch (e) {
            return Icon(Icons.error);
          }
        } else if (state is UserErrorState) {
          return new Icon(Icons.error);
        } else {
          return new Icon(Icons.error);
        }
      },
    );
  }
}
