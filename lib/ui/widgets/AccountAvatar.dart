import 'package:cached_network_image/cached_network_image.dart';

import 'package:dtube_togo/bloc/user/user_bloc_full.dart';
import 'package:dtube_togo/style/ThemeData.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AccountAvatarBase extends StatelessWidget {
  const AccountAvatarBase(
      {Key? key,
      required this.username,
      required this.size,
      required this.showVerified})
      : super(key: key);
  final String username;
  final double size;
  final bool showVerified;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc(repository: UserRepositoryImpl()),
      child: AccountAvatar(
          username: username, size: size, showVerified: showVerified),
    );
  }
}

class AccountAvatar extends StatefulWidget {
  const AccountAvatar(
      {Key? key,
      required this.username,
      required this.size,
      required this.showVerified})
      : super(key: key);
  final String username;
  final double size;
  final bool showVerified;

  @override
  _AccountAvatarState createState() => _AccountAvatarState();
}

class _AccountAvatarState extends State<AccountAvatar> {
  late UserBloc _userBlocAvatar;
  @override
  void initState() {
    super.initState();
    _userBlocAvatar = BlocProvider.of<UserBloc>(context);
    _userBlocAvatar.add(FetchAccountDataEvent(username: widget.username));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      bloc: _userBlocAvatar,
      builder: (context, state) {
        if (state is UserLoadingState) {
          return CircularProgressIndicator();
        } else if (state is UserLoadedState &&
                state.user.jsonString != null &&
                state.user.jsonString?.profile != null &&
                state.user.jsonString?.profile?.avatar != ""
            //  &&
            // state.user.name == widget.username
            ) {
          try {
            return Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: state.user.jsonString!.profile!.avatar!
                      .replaceAll("http:", "https:"),
                  imageBuilder: (context, imageProvider) => Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: (context, url) => Container(
                      width: widget.size,
                      height: widget.size,
                      child: AvatarLoadingPlaceholder(size: widget.size)),
                  errorWidget: (context, url, error) => Container(
                      width: widget.size,
                      height: widget.size,
                      child: AvatarLoadingPlaceholder(size: widget.size)),
                ),
                state.verified && widget.showVerified
                    ? Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                            maxRadius: widget.size / 5,
                            backgroundColor: globalRed,
                            child: FaIcon(
                              FontAwesomeIcons.check,
                              color: globalAlmostWhite,
                              size: widget.size / 5,
                            )),
                      )
                    : SizedBox(height: 0),
              ],
            );
          } catch (e) {
            return AvatarLoadingPlaceholder(
              size: widget.size,
            );
          }
        } else if (state is UserErrorState) {
          return AvatarLoadingPlaceholder(size: widget.size);
        } else {
          return AvatarLoadingPlaceholder(size: widget.size);
        }
      },
    );
  }
}

class AvatarErrorPlaceholder extends StatelessWidget {
  const AvatarErrorPlaceholder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: 50.0,
      height: 50.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
            image: Image.asset('assets/images/Flag_of_None.svg.png').image,
            fit: BoxFit.cover),
      ),
    );
  }
}

class AvatarLoadingPlaceholder extends StatelessWidget {
  AvatarLoadingPlaceholder({Key? key, required this.size}) : super(key: key);
  double size;

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
            image: Image.asset('assets/images/appicon.png').image,
            fit: BoxFit.cover),
      ),
    );
  }
}
