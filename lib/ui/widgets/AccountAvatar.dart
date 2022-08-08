import 'package:dtube_go/utils/globalVariables.dart' as globals;

import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayText.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/style/OpenableHyperlink.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AccountAvatarBase extends StatelessWidget {
  AccountAvatarBase(
      {Key? key,
      required this.username,
      required this.avatarSize,
      required this.showVerified,
      required this.showName,
      this.nameFontSizeMultiply,
      this.showNameLeft,
      this.showFullUserInfo,
      required this.width,
      required this.height,
      this.showAvatar})
      : super(key: key);
  final String username;
  final double avatarSize;
  final bool showVerified;
  final bool showName;
  double? nameFontSizeMultiply;
  bool? showNameLeft;
  bool? showFullUserInfo;
  double width;
  double height;
  bool? showAvatar;

  @override
  Widget build(BuildContext context) {
    if (nameFontSizeMultiply == null) {
      nameFontSizeMultiply = 1;
    }
    if (showNameLeft == null) {
      showNameLeft = false;
    }
    if (showFullUserInfo == null) {
      showFullUserInfo = false;
    }
    if (showAvatar == null) {
      showAvatar = true;
    }

    return BlocProvider(
      create: (context) => UserBloc(repository: UserRepositoryImpl()),
      child: AccountAvatar(
        username: username,
        avatarSize: avatarSize,
        showVerified: showVerified,
        showName: showName,
        nameFontSizeMultiply: nameFontSizeMultiply!,
        showNameLeft: showNameLeft!,
        showFullUserInfo: showFullUserInfo!,
        width: width,
        height: height,
        showAvatar: showAvatar!,
      ),
    );
  }
}

class AccountAvatar extends StatefulWidget {
  const AccountAvatar(
      {Key? key,
      required this.username,
      required this.avatarSize,
      required this.showVerified,
      required this.showName,
      required this.nameFontSizeMultiply,
      required this.showNameLeft,
      required this.showFullUserInfo,
      required this.width,
      required this.height,
      required this.showAvatar})
      : super(key: key);
  final String username;
  final double avatarSize;
  final bool showVerified;
  final bool showName;
  final double nameFontSizeMultiply;
  final bool showNameLeft;
  final bool showFullUserInfo;
  final double width;
  final double height;
  final bool showAvatar;

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
          return Container(
              width: widget.width,
              height: widget.height,
              child: Center(child: CircularProgressIndicator()));
        } else if (state is UserLoadedState) {
          try {
            return Container(
              width: widget.width,
              height: widget.height,
              child: Row(
                mainAxisAlignment: !widget.showName
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  widget.showName && widget.showNameLeft
                      ? Row(
                          children: [
                            widget.showFullUserInfo
                                ? FullInfo(
                                    userData: state.user,
                                    nameFontSizeMultiply:
                                        widget.nameFontSizeMultiply,
                                    width:
                                        widget.width - widget.avatarSize - 5.w,
                                  )
                                : ShowName(
                                    userData: state.user,
                                    sizeMultiply: widget.nameFontSizeMultiply,
                                    width: widget.width,
                                  ),
                            SizedBox(width: 8)
                          ],
                        )
                      : SizedBox(
                          width: 0,
                        ),
                  widget.showAvatar
                      ? Stack(
                          children: [
                            state.user.jsonString != null &&
                                    state.user.jsonString?.profile != null &&
                                    state.user.jsonString?.profile?.avatar != ""
                                ? CachedNetworkImage(
                                    imageUrl: state
                                        .user.jsonString!.profile!.avatar!
                                        .replaceAll("http:", "https:"),
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      width: widget.avatarSize,
                                      height: widget.avatarSize,
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
                            state.verified && widget.showVerified
                                ? BounceIn(
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
                        )
                      : SizedBox(
                          width: 0,
                          height: 0,
                        ),
                  widget.showName && !widget.showNameLeft
                      ? Row(
                          children: [
                            SizedBox(width: 8),
                            widget.showFullUserInfo
                                ? FullInfo(
                                    userData: state.user,
                                    nameFontSizeMultiply:
                                        widget.nameFontSizeMultiply,
                                    width: widget.width - widget.avatarSize,
                                  )
                                : ShowName(
                                    userData: state.user,
                                    sizeMultiply: widget.nameFontSizeMultiply,
                                    width: widget.width - widget.avatarSize,
                                  ),
                          ],
                        )
                      : SizedBox(
                          width: 0,
                        )
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

class FullInfo extends StatelessWidget {
  const FullInfo(
      {Key? key,
      required this.userData,
      required this.nameFontSizeMultiply,
      required this.width})
      : super(key: key);

  final User userData;

  final double nameFontSizeMultiply;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShowName(
            userData: userData,
            sizeMultiply: nameFontSizeMultiply,
            width: width,
          ),
          userData.jsonString?.profile?.location != null
              ? FadeInLeft(
                  preferences: AnimationPreferences(
                      offset: Duration(milliseconds: 1400)),
                  child: OverlayText(
                    text: userData.jsonString!.profile!.location!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    sizeMultiply: 1,
                    // style:
                    //     Theme.of(context).textTheme.bodyText2,
                  ),
                )
              : SizedBox(
                  height: 0,
                ),
          userData.jsonString?.profile?.about != null
              ? FadeInLeft(
                  preferences: AnimationPreferences(
                      offset: Duration(milliseconds: 1700)),
                  child: OverlayText(
                    text: userData.jsonString!.profile!.about!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    // style:
                    //     Theme.of(context).textTheme.bodyText2,
                  ),
                )
              : SizedBox(
                  height: 0,
                ),
          userData.jsonString?.profile?.website != null
              ? FadeIn(
                  preferences: AnimationPreferences(
                      offset: Duration(milliseconds: 2200)),
                  child: OpenableHyperlink(
                    url: userData.jsonString!.profile!.website!,
                  ))
              : SizedBox(
                  height: 0,
                ),
        ],
      ),
    );
  }
}

class ShowName extends StatelessWidget {
  const ShowName(
      {Key? key,
      required this.userData,
      required this.sizeMultiply,
      required this.width})
      : super(key: key);

  final User userData;
  final double sizeMultiply;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width - 8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          userData.jsonString?.additionals?.displayName != null
              ? OverlayText(
                  text: userData.jsonString!.additionals!.displayName!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  sizeMultiply: sizeMultiply,
                )
              : SizedBox(
                  height: 0,
                ),
          OverlayText(
            text: userData.jsonString?.additionals?.displayName != null
                ? '(@' + userData.name + ')'
                : userData.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            sizeMultiply: userData.jsonString?.additionals?.displayName != null
                ? 0.8
                : sizeMultiply,
          ),
        ],
      ),
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
              child: Center(child: CircularProgressIndicator()));
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
