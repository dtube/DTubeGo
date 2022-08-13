import 'package:dtube_go/utils/SecureStorage.dart' as sec;

import 'package:dtube_go/utils/Global/secureStorage.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:flutter/cupertino.dart';

import 'package:dtube_go/ui/startup/login/services/ressources.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:github_sign_in/github_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:twitter_login/twitter_login.dart';

// more flows:
// TODO: https://firebase.flutter.dev/docs/auth/social/ facebook, github, apple

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<String?> signInwithGoogleMobile() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<UserCredential?> linkProviders(
      UserCredential userCredential, AuthCredential newCredential) async {
    return await userCredential.user!.linkWithCredential(newCredential);
  }

  Future<Resource?> signInWithTwitterMobile() async {
    String _twitterApiKey = await sec.getLocalConfigString(settingKey_twaKey);
    String _twitterApiSecret =
        await sec.getLocalConfigString(settingKey_twaSec);

    final twitterLogin = TwitterLogin(
      apiKey: _twitterApiKey,
      apiSecretKey: _twitterApiSecret,
      redirectURI: "twitter-firebase-auth://",
    );
    final authResult = await twitterLogin.login();

    switch (authResult.status) {
      case TwitterLoginStatus.loggedIn:
        final AuthCredential twitterAuthCredential =
            TwitterAuthProvider.credential(
                accessToken: authResult.authToken!,
                secret: authResult.authTokenSecret!);

        final userCredential =
            await _auth.signInWithCredential(twitterAuthCredential);
        return Resource(status: Status.Success);
      case TwitterLoginStatus.cancelledByUser:
        return Resource(status: Status.Cancelled);
      case TwitterLoginStatus.error:
        return Resource(status: Status.Error);
      default:
        return null;
    }
  }

  Future<UserCredential?> signInWithGoogleWeb() async {
    // Create a new provider
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider
        .addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithPopup(googleProvider);
  }

  Future<UserCredential?> signInWithTwitterWeb() async {
    final userCredential =
        await FirebaseAuth.instance.signInWithPopup(TwitterAuthProvider());
    return userCredential;
  }

  Future<UserCredential?> signInWithGithubWeb() async {
    final userCredential =
        await FirebaseAuth.instance.signInWithPopup(GithubAuthProvider());
    return userCredential;
  }

  Future<UserCredential?> signInWithFacebookWeb() async {
// Create a new provider
    FacebookAuthProvider facebookProvider = FacebookAuthProvider();

    facebookProvider.addScope('email');
    facebookProvider.setCustomParameters({
      'display': 'popup',
    });

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithPopup(facebookProvider);
  }

  Future<UserCredential> signInWithGitHubMobile(BuildContext context) async {
    // Create a GitHubSignIn instance
    String _githubClientId = await sec.getLocalConfigString(settingKey_ghaCl);
    String _githubClientSecret =
        await sec.getLocalConfigString(settingKey_ghaSec);
    String _githubRedirectUrl =
        await sec.getLocalConfigString(settingKey_ghaRU);

    final GitHubSignIn gitHubSignIn = GitHubSignIn(
        clientId: _githubClientId,
        clientSecret: _githubClientSecret,
        redirectUrl: _githubRedirectUrl);

    final result = await gitHubSignIn.signIn(context);

    final githubAuthCredential = GithubAuthProvider.credential(result.token!);

    return await FirebaseAuth.instance
        .signInWithCredential(githubAuthCredential);
  }

  Future<UserCredential> signInWithFacebookMobile() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);
  }
}
