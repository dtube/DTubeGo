import 'package:dtube_go/utils/globalVariables.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:dtube_go/bloc/config/txTypes.dart';
import 'package:dtube_go/bloc/hivesigner/hivesigner_bloc.dart';
import 'package:dtube_go/bloc/hivesigner/hivesigner_bloc_full.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/bloc/user/user_response_model.dart';
import 'package:dtube_go/utils/SecureStorage.dart' as sec;
import 'package:bloc/bloc.dart';
import 'package:dtube_go/bloc/transaction/transaction_event.dart';
import 'package:dtube_go/bloc/transaction/transaction_repository.dart';

import 'package:dtube_go/bloc/transaction/transaction_state.dart';

import 'package:dtube_go/utils/randomPermlink.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionRepository repository;

  TransactionBloc({required this.repository})
      : super(TransactionInitialState());

  // @override
  // TransactionState get initialState => TransactionInitialState();

  @override
  Stream<TransactionState> mapEventToState(TransactionEvent event) async* {
    final String _avalonApiNode = await sec.getNode();
    final String? _applicationUser = await sec.getUsername();
    final String? _privKey = await sec.getPrivateKey();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    if (event is SetInitState) {
      yield TransactionInitialState();
    }
    if (event is TransactionPreprocessing) {
      yield TransactionPreprocessingState(txType: event.txType);
    }
    if (event is TransactionPreprocessingFailed) {
      yield TransactionError(
          message: "error preparing transaction\n" + event.errorMessage);
    }

    if (event is SignAndSendTransactionEvent) {
      String result = "";
      //for (var i = 0; i < 5; i++) {
      //yield TransactionSinging(tx: event.tx);
      try {
        result = "";
        result = await repository
            .sign(event.tx, _applicationUser!, _privKey!)
            .then((value) => repository.send(_avalonApiNode, value));

        if (int.tryParse(result) != null) {
          yield TransactionSent(
              block: int.parse(result),
              successMessage: txTypeFriendlyDescriptionActions[event.tx.type]!
                  .replaceAll(
                      '##DTCAMOUNT',
                      (event.tx.data.amount != null
                              ? event.tx.data.amount! / 100
                              : 0)
                          .toString())
                  .replaceAll('##TIPAMOUNT', event.tx.data.tip.toString())
                  .replaceAll('##USERNAME', event.tx.data.target.toString()),
              txType: event.tx.type,
              isParentContent:
                  (event.tx.data.pa == "" || event.tx.data.pa == null) &&
                      (event.tx.type == 4 || event.tx.type == 13));
        } else {
          yield TransactionError(message: result);
        }
      } catch (e) {
        yield TransactionError(message: e.toString());
      }
    }

    if (event is ChangeProfileData) {
      int _txType = 6;
      User _userData = event.userData;
      yield TransactionPreprocessingState(txType: _txType);
      Map<String, dynamic> jsonMetadata = {};

      TxData _txData = new TxData(
        jsonmetadata: _userData.jsonString!.toJson(),
      );

// change profile
      Transaction _tx = new Transaction(type: _txType, data: _txData);

      int _block = 0;
      String result = "";

      try {
        result = "";
        result = await repository
            .sign(_tx, _applicationUser!, _privKey!)
            .then((value) => repository.send(_avalonApiNode, value));
      } catch (e) {
        yield TransactionError(message: e.toString());
      }

      yield TransactionSent(
          block: _block,
          isParentContent: false,
          successMessage: "profile updated",
          txType: _txType);
    }

    if (event is SendCommentEvent) {
      String _hiveAuthor = await sec.getHiveSignerUsername();
      UploadData _upload = event.uploadData;
      String result = "";

      if (_upload.link == "") {
        _upload.link = randomPermlink(11);
      }
      Map<String, dynamic> jsonMetadata = {};
      // dummy tx
      TxData _txData = new TxData(
        link: _upload.link,
      );

      //no video location => comment
      if (_upload.videoLocation == "") {
        jsonMetadata = {
          "title": _upload.title,
          "description": _upload.description,
          "tag": _upload.tag,
          "app": "dtube.go.app_" +
              packageInfo.version +
              '+' +
              packageInfo.buildNumber
        };

        _txData = new TxData(
            link: _upload.link,
            vt: _upload.isEditing
                ? 1
                : (_upload.vpBalance * _upload.vpPercent / 100).floor(),
            tag: _upload.tag,
            pa: _upload.parentAuthor,
            pp: _upload.parentPermlink,
            jsonmetadata: jsonMetadata);

        if (_upload.isPromoted) {
          _txData = new TxData(
              link: _upload.link,
              vt: _upload.isEditing
                  ? 1
                  : (_upload.vpBalance * _upload.vpPercent / 100).floor(),
              tag: _upload.tag,
              jsonmetadata: jsonMetadata,
              pa: _upload.parentAuthor,
              pp: _upload.parentPermlink,
              burn: _upload.burnDtc.floor());
        }
      }
      // video location => post
      if (_upload.videoLocation != "") {
        // we have a source hash => ipfs uploaded video
        if (_upload.videoSourceHash != "") {
          // we have NO thumbnail location defined => ipfs uploaded image
          if (_upload.thumbnailLocation == "") {
            jsonMetadata = {
              "files": {
                "ipfs": {
                  "vid": {
                    "240": _upload.video240pHash,
                    "480": _upload.video480pHash,
                    "src": _upload.videoSourceHash
                  },
                  "img": {
                    "118": _upload.thumbnail210Hash,
                    "360": _upload.thumbnail640Hash,
                    "spr": _upload.videoSpriteHash
                  },
                  "gw": "https://player.d.tube"
                },
              },
              "title": _upload.title,
              "description": _upload.description,
              "dur": _upload.duration,
              "tag": _upload.tag,
              "hide": _upload.unlistVideo ? 1 : 0,
              "nsfw": _upload.nSFWContent ? 1 : 0,
              "oc": _upload.originalContent ? 1 : 0,
              "app": "dtube.go.app_" +
                  packageInfo.version +
                  '+' +
                  packageInfo.buildNumber,
              "refs": [
                _upload.crossPostToHive
                    ? "hive/" + _hiveAuthor + "/" + _upload.link
                    : null
              ]
            };
          } else {
            // we have a thumbnail location defined => no ipfs uploaded image so third party thumbnail
            jsonMetadata = {
              "files": {
                "ipfs": {
                  "vid": {
                    "240": _upload.video240pHash,
                    "480": _upload.video480pHash,
                    "src": _upload.videoSourceHash
                  },
                  "img": {"spr": _upload.videoSpriteHash},
                  "gw": "https://player.d.tube"
                },
              },
              "title": _upload.title,
              "description": _upload.description,
              "dur": _upload.duration,
              "tag": _upload.tag,
              "hide": _upload.unlistVideo ? 1 : 0,
              "nsfw": _upload.nSFWContent ? 1 : 0,
              "oc": _upload.originalContent ? 1 : 0,
              "thumbnailUrlExternal": _upload.thumbnailLocation,
              "thumbnailUrl": _upload.thumbnailLocation,
              "app": "dtube.go.app_" +
                  packageInfo.version +
                  '+' +
                  packageInfo.buildNumber,
              "refs": [
                _upload.crossPostToHive
                    ? "hive/" + _hiveAuthor + "/" + _upload.link
                    : null
              ]
            };
          }
        } else {
          // we have NO source hash => third party video
          // and we have A defined thumbnail location => take the uploaded thumbnail
          if (_upload.thumbnailLocation != "" && !_upload.localThumbnail) {
            jsonMetadata = {
              "files": {"youtube": _upload.videoLocation},
              "title": _upload.title,
              "description": _upload.description,
              "dur": _upload.duration,
              "tag": _upload.tag,
              "hide": _upload.unlistVideo ? 1 : 0,
              "nsfw": _upload.nSFWContent ? 1 : 0,
              "oc": _upload.originalContent ? 1 : 0,
              "thumbnailUrlExternal": _upload.thumbnailLocation,
              "thumbnailUrl": _upload.thumbnailLocation,
              "app": "dtube.go.app_" +
                  packageInfo.version +
                  '+' +
                  packageInfo.buildNumber,
              "refs": [
                _upload.crossPostToHive
                    ? "hive/" + _hiveAuthor + "/" + _upload.link
                    : null
              ]
            };
          } else {
            // we have NO source hash => third party video
            // and we have NO defined thumbnail location => take the youtube thumbnail (default)
            jsonMetadata = {
              "files": {"youtube": _upload.videoLocation},
              "title": _upload.title,
              "description": _upload.description,
              "dur": _upload.duration,
              "tag": _upload.tag,
              "hide": _upload.unlistVideo ? 1 : 0,
              "nsfw": _upload.nSFWContent ? 1 : 0,
              "oc": _upload.originalContent ? 1 : 0,
              "app": "dtube.go.app_" +
                  packageInfo.version +
                  '+' +
                  packageInfo.buildNumber,
              "refs": [
                _upload.crossPostToHive
                    ? "hive/" + _hiveAuthor + "/" + _upload.link
                    : null
              ]
            };
          }
        }

        _txData = new TxData(
            link: _upload.link,
            vt: _upload.isEditing
                ? 1
                : (_upload.vpBalance * _upload.vpPercent / 100).floor(),
            tag: _upload.tag,
            pa: _upload.parentAuthor != "" ? _upload.parentAuthor : null,
            pp: _upload.parentPermlink != "" ? _upload.parentPermlink : null,
            jsonmetadata: jsonMetadata);

        if (_upload.isPromoted) {
          _txData = new TxData(
              link: _upload.link,
              vt: _upload.isEditing
                  ? 1
                  : (_upload.vpBalance * _upload.vpPercent / 100).floor(),
              tag: _upload.tag,
              jsonmetadata: jsonMetadata,
              pa: _upload.parentAuthor != "" ? _upload.parentAuthor : null,
              pp: _upload.parentPermlink != "" ? _upload.parentPermlink : null,
              burn: _upload.burnDtc.floor());
        }
      }

      Transaction _tx =
          new Transaction(type: _upload.isPromoted ? 13 : 4, data: _txData);

      try {
        result = "";
        result = await repository
            .sign(_tx, _applicationUser!, _privKey!)
            .then((value) => repository.send(_avalonApiNode, value));
        print(result);
        if (int.tryParse(result) != null) {
          yield TransactionSent(
              block: int.parse(result),
              successMessage: txTypeFriendlyDescriptionActions[_tx.type]!,
              txType: _tx.type,
              isParentContent: (_tx.data.pa == "" || _tx.data.pa == null) &&
                  (_tx.type == 4 || _tx.type == 13),
              authorPerm: (_tx.data.pa == "" || _tx.data.pa == null) &&
                      (_tx.type == 4 || _tx.type == 13) &&
                      _tx.data.link != null
                  ? _applicationUser + '/' + _tx.data.link!
                  : null);
          if (_upload.crossPostToHive) {
            HivesignerBloc _hiveSignerBloc =
                HivesignerBloc(repository: HivesignerRepositoryImpl());
            if (_upload.thumbnailLocation.contains('img.youtube')) {
              _hiveSignerBloc.add(SendPostToHive(
                  postTitle: _upload.title,
                  postBody: _upload.description,
                  permlink: _upload.link,
                  dtubeUrl: _upload.link,
                  thumbnailUrl: _upload.thumbnailLocation,
                  videoUrl: _upload.videoSourceHash,
                  storageType: "youtube",
                  tag: _upload.tag));
            } else {
              _hiveSignerBloc.add(SendPostToHive(
                  postTitle: _upload.title,
                  postBody: _upload.description,
                  permlink: _upload.link,
                  dtubeUrl: _upload.link,
                  thumbnailUrl: _upload.thumbnailLocation,
                  videoUrl: _upload.videoSourceHash,
                  storageType: "ipfs",
                  tag: _upload.tag));
            }
          }
        } else {
          yield TransactionError(message: result);
        }
      } catch (e) {
        yield TransactionError(message: e.toString());
      }
    }
  }
}
