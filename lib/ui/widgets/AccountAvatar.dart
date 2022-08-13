import 'package:dtube_go/ui/widgets/system/ColorChangeCircularProgressIndicator.dart';
import 'package:dtube_go/utils/GlobalStorage/globalVariables.dart' as globals;

import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayText.dart';
import 'package:dtube_go/utils/Navigation/navigationShortcuts.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/style/OpenableHyperlink.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  final double size;

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

class AccountNameBase extends StatelessWidget {
  AccountNameBase(
      {Key? key,
      required this.username,
      required this.width,
      required this.height,
      required this.mainStyle,
      required this.subStyle})
      : super(key: key);
  final String username;
  final double width;
  final double height;
  final TextStyle mainStyle;
  final TextStyle subStyle;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => UserBloc(repository: UserRepositoryImpl())
          ..add(username == "you"
              ? FetchMyAccountDataEvent()
              : FetchAccountDataEvent(username: username)),
        child: AccountName(
          width: width,
          height: height,
          mainStyle: mainStyle,
          subStyle: subStyle,
        ));
  }
}

class AccountIconBase extends StatelessWidget {
  const AccountIconBase({
    Key? key,
    required this.username,
    required this.avatarSize,
    required this.showVerified,
    this.showBorder,
  }) : super(key: key);
  final String username;
  final double avatarSize;
  final bool showVerified;
  final bool? showBorder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => UserBloc(repository: UserRepositoryImpl())
          ..add(username == "you"
              ? FetchMyAccountDataEvent()
              : FetchAccountDataEvent(username: username)),
        child: AccountIcon(
          avatarSize: avatarSize,
          showVerified: showVerified,
          showBorder: showBorder != null ? showBorder! : false,
        ));
  }
}

class AccountIcon extends StatefulWidget {
  AccountIcon(
      {Key? key,
      required this.avatarSize,
      required this.showVerified,
      required this.showBorder})
      : super(key: key);

  final double avatarSize;
  final bool showVerified;
  final bool showBorder;

  @override
  State<AccountIcon> createState() => _AccountIconState();
}

class _AccountIconState extends State<AccountIcon> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoadingState) {
          return Container(
              width: widget.avatarSize,
              height: widget.avatarSize,
              child: Center(child: ColorChangeCircularProgressIndicator()));
        } else if (state is UserLoadedState) {
          try {
            return Container(
              width: widget.avatarSize,
              height: widget.avatarSize,
              child: Stack(
                children: [
                  widget.showBorder
                      ? CircleAvatar(
                          backgroundColor: globalAlmostWhite,
                          maxRadius: (widget.avatarSize / 2) + 0.5.w,
                          child: state.user.jsonString != null &&
                                  state.user.jsonString?.profile != null &&
                                  state.user.jsonString?.profile?.avatar != ""
                              ? CachedNetworkImage(
                                  imageUrl: state
                                      .user.jsonString!.profile!.avatar!
                                      .replaceAll("http:", "https:"),
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    width: widget.avatarSize - 1.w,
                                    height: widget.avatarSize - 1.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  placeholder: (context, url) => Container(
                                      width: widget.avatarSize,
                                      height: widget.avatarSize,
                                      child: AvatarLoadingPlaceholder(
                                          size: widget.avatarSize)),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                          width: widget.avatarSize,
                                          height: widget.avatarSize,
                                          child: AvatarLoadingPlaceholder(
                                              size: widget.avatarSize)),
                                )
                              : AvatarLoadingPlaceholder(
                                  size: widget.avatarSize,
                                ),
                        )
                      : state.user.jsonString != null &&
                              state.user.jsonString?.profile != null &&
                              state.user.jsonString?.profile?.avatar != ""
                          ? CachedNetworkImage(
                              imageUrl: state.user.jsonString!.profile!.avatar!
                                  .replaceAll("http:", "https:"),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: widget.avatarSize,
                                height: widget.avatarSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              placeholder: (context, url) => Container(
                                  width: widget.avatarSize,
                                  height: widget.avatarSize,
                                  child: AvatarLoadingPlaceholder(
                                      size: widget.avatarSize)),
                              errorWidget: (context, url, error) => Container(
                                  width: widget.avatarSize,
                                  height: widget.avatarSize,
                                  child: AvatarLoadingPlaceholder(
                                      size: widget.avatarSize)),
                            )
                          : AvatarLoadingPlaceholder(
                              size: widget.avatarSize,
                            ),
                  state.verified && widget.showVerified
                      ? globals.disableAnimations
                          ? Align(
                              alignment: Alignment.bottomRight,
                              child: CircleAvatar(
                                  maxRadius: widget.avatarSize / 8,
                                  backgroundColor: globalRed,
                                  child: FaIcon(
                                    FontAwesomeIcons.check,
                                    color: globalAlmostWhite,
                                    size: widget.avatarSize / 8,
                                  )),
                            )
                          : BounceIn(
                              preferences: AnimationPreferences(
                                  offset: Duration(milliseconds: 1000)),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: CircleAvatar(
                                    maxRadius: widget.avatarSize / 8,
                                    backgroundColor: globalRed,
                                    child: FaIcon(
                                      FontAwesomeIcons.check,
                                      color: globalAlmostWhite,
                                      size: widget.avatarSize / 8,
                                    )),
                              ),
                            )
                      : SizedBox(height: 0),
                ],
              ),
            );
          } catch (e) {
            return AvatarLoadingPlaceholder(
              size: widget.avatarSize,
            );
          }
        } else if (state is UserErrorState) {
          print(state.toString() + " happened for");
          return AvatarLoadingPlaceholder(size: widget.avatarSize);
        } else {
          print(state.toString() + " happened");
          return AvatarLoadingPlaceholder(size: widget.avatarSize);
        }
      },
    );
  }
}

class AccountName extends StatefulWidget {
  AccountName(
      {Key? key,
      required this.width,
      required this.height,
      required this.mainStyle,
      required this.subStyle})
      : super(key: key);

  final double width;
  final double height;
  final TextStyle mainStyle;
  final TextStyle subStyle;
  @override
  State<AccountName> createState() => _AccountNameState();
}

class _AccountNameState extends State<AccountName> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoadingState) {
          return Container(
              width: widget.width,
              height: widget.height,
              child: Center(child: ColorChangeCircularProgressIndicator()));
        } else if (state is UserLoadedState) {
          return Container(
              width: widget.width,
              height: widget.height,
              child: state.user.jsonString != null &&
                      state.user.jsonString!.additionals != null &&
                      state.user.jsonString!.additionals!.displayName != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.user.jsonString!.additionals!.displayName!,
                          overflow: TextOverflow.ellipsis,
                          style: widget.mainStyle,
                        ),
                        Text(
                          "@" + state.user.name,
                          overflow: TextOverflow.ellipsis,
                          style: widget.subStyle,
                        )
                      ],
                    )
                  : Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        state.user.name,
                        overflow: TextOverflow.ellipsis,
                        style: widget.mainStyle,
                      ),
                    ));
        }
        return ColorChangeCircularProgressIndicator();
      },
    );
  }
}

class AccountNavigationChip extends StatelessWidget {
  const AccountNavigationChip({
    Key? key,
    required this.author,
  }) : super(key: key);

  final String author;

  @override
  Widget build(BuildContext context) {
    return InputChip(
      label: Container(
        width: 40.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AccountIconBase(
              username: author,
              avatarSize: 12.w,
              showVerified: true,
            ),
            AccountNameBase(
              username: author,
              width: 25.w,
              height: 5.h,
              mainStyle: Theme.of(context).textTheme.headline6!,
              subStyle: Theme.of(context).textTheme.bodyText1!,
            ),
          ],
        ),
      ),
      onPressed: () {
        navigateToUserDetailPage(context, author, () {});
      },
    );
  }
}
