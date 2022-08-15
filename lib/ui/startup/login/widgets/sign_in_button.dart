import 'package:dtube_go/ui/widgets/system/ColorChangeCircularProgressIndicator.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:dtube_go/ui/startup/login/services/firebase_service.dart';
import 'package:dtube_go/ui/startup/login/services/ressources.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SignInButton extends StatefulWidget {
  final FaIcon faIcon;
  final LoginType loginType;
  final bool activated;
  final Function loggedInCallback;

  SignInButton(
      {Key? key,
      required this.faIcon,
      required this.loginType,
      required this.activated,
      required this.loggedInCallback})
      : super(key: key);

  @override
  _SignInButtonState createState() => _SignInButtonState();
}

class _SignInButtonState extends State<SignInButton> {
  bool isLoading = false;
  FirebaseService service = new FirebaseService();
  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? ElevatedButton(
            child: Container(
                width: 10.w, child: Center(child: this.widget.faIcon)),
            onPressed: !widget.activated
                ? null
                : () async {
                    setState(() {
                      isLoading = true;
                    });
                    await this.loginWithProviders();
                    setState(() {
                      isLoading = false;
                    });
                  },
          )
        : ElevatedButton(
            child: Container(
              width: 10.w,
              child: Center(child: ColorChangeCircularProgressIndicator()),
            ),
            onPressed: null,
          );
  }

  void showMessage(FirebaseAuthException e) {
    showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(e.message!),
          );
        });
  }

  Future<void> loginWithProviders() async {
    String? displayName;
    String _provider;
    Resource? result = Resource(status: Status.Error);
    UserCredential? usercred;
    try {
      switch (this.widget.loginType) {
        case LoginType.Google:
          if (kIsWeb) {
            usercred = await service.signInWithGoogleWeb();
          } else {
            displayName = (await service.signInwithGoogleMobile());
          }
          _provider = "google";
          break;
        case LoginType.Twitter:
          if (kIsWeb) {
            usercred = await service.signInWithTwitterWeb();
          } else {
            result = await service.signInWithTwitterMobile();
          }
          _provider = "twitter";
          break;
        case LoginType.Github:
          if (kIsWeb) {
            usercred = await service.signInWithGithubWeb();
          } else {
            usercred = await service.signInWithGitHubMobile(context);
          }
          //

          _provider = "github";
          break;
        case LoginType.Facebook:
          service.signInWithFacebookMobile();
          _provider = "facebook";
          break;
      }
      //if (result!.status == Status.Success || displayName != null) {
      if (FirebaseAuth.instance.currentUser != null) {
        widget.loggedInCallback(
            FirebaseAuth.instance.currentUser!.uid, _provider);
      }
    } on Exception catch (e) {
      if (e is FirebaseAuthException) {
        showMessage(e);
      }
    }
  }
}
