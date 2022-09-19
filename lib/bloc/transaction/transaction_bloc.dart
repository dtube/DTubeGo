import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:image_compression_flutter/image_compression_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:dtube_go/bloc/config/txTypes.dart';
import 'package:dtube_go/bloc/hivesigner/hivesigner_bloc_full.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/bloc/user/user_response_model.dart';
import 'package:dtube_go/utils/GlobalStorage/SecureStorage.dart' as sec;
import 'package:bloc/bloc.dart';
import 'package:dtube_go/utils/Random/randomPermlink.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionRepository repository;

  TransactionBloc({required this.repository})
      : super(TransactionInitialState()) {
// TODO: big files
// big files: https://stackoverflow.com/questions/70079208/how-to-upload-large-files-in-flutter-web
// https://pub.dev/packages/large_file_uploader

    Future<String> uploadThumbnailFromWeb(
        Uint8List bytes, String filename) async {
      String _url = "https://api.imgur.com/3/image";
      String authHeader = "Client-ID fc2dde68a83c037";

      var dio = Dio();
      dio.options.headers["Authorization"] = authHeader;

      FormData data = FormData.fromMap({
        "image": MultipartFile.fromBytes(
          bytes,
          filename: filename,
        ),
      });

      var response = await dio.post(
        _url,
        data: data,
      );

      if (response.statusCode == 200) {
        print(response);
        var uploadedUrl = response.data['data']['link'];
        // var uploadedUrl = "";

        return uploadedUrl;
      } else {
        throw Exception();
      }
    }

    Future<String> uploadThumbnail(String localFilePath) async {
      //String _url = endpoint;
      String _url = "https://api.imgur.com/3/image";

      String authHeader = "Client-ID fc2dde68a83c037";

      var dio = Dio();
      dio.options.headers["Authorization"] = authHeader;
      String fileName = localFilePath.split('/').last;

      FormData data = FormData.fromMap({
        "image": await MultipartFile.fromFile(
          localFilePath,
          filename: fileName,
        ),
      });

      var response = await dio.post(
        _url,
        data: data,
      );

      if (response.statusCode == 200) {
        var uploadedUrl = response.data['data']['link'];

        return uploadedUrl;
      } else {
        throw Exception();
      }
    }

    on<SetInitState>((event, emit) async {
      emit(TransactionInitialState());
    });

    on<TransactionPreprocessing>((event, emit) async {
      emit(TransactionPreprocessingState(txType: event.txType));
    });
    on<TransactionPreprocessingFailed>((event, emit) async {
      emit(TransactionError(
          message: "error preparing transaction\n" + event.errorMessage,
          txType: event.txType,
          isParentContent: false));
    });

    on<SignAndSendTransactionEvent>((event, emit) async {
      emit(TransactionSinging(tx: event.tx));
      final String _avalonApiNode = await sec.getNode();
      String? _applicationUser = await sec.getUsername();
      String? _privKey = await sec.getPrivateKey();
      if (event.administrativePrivateKey != null) {
        _privKey = event.administrativePrivateKey;
        _applicationUser = event.administrativeUsername;
      }

      String result = "";

      try {
        result = "";
        result = await repository
            .sign(event.tx, _applicationUser!, _privKey!)
            .then((value) => repository.send(_avalonApiNode, value));

        if (int.tryParse(result) != null) {
          emit(TransactionSent(
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
              isDownvote: event.tx.type == 5 &&
                      event.tx.data.vt != null &&
                      event.tx.data.vt! < 0
                  ? true
                  : false,
              isParentContent:
                  (event.tx.data.pa == "" || event.tx.data.pa == null) &&
                      (event.tx.type == 4 || event.tx.type == 13)));
        } else {
          emit(TransactionError(
              message: result,
              txType: event.tx.type,
              isParentContent:
                  ((event.tx.data.pa == "" || event.tx.data.pa == null) &&
                      (event.tx.type == 4 || event.tx.type == 13))));
        }
      } catch (e) {
        emit(TransactionError(
            message: e.toString(),
            txType: event.tx.type,
            isParentContent:
                ((event.tx.data.pa == "" || event.tx.data.pa == null) &&
                    (event.tx.type == 4 || event.tx.type == 13))));
      }
    });

    on<SignAndSendDAOTransactionEvent>((event, emit) async {
      emit(DAOTransactionSinging(tx: event.tx));
      final String _avalonApiNode = await sec.getNode();
      String? _applicationUser = await sec.getUsername();
      String? _privKey = await sec.getPrivateKey();
      if (event.administrativePrivateKey != null) {
        _privKey = event.administrativePrivateKey;
        _applicationUser = event.administrativeUsername;
      }

      String result = "";

      try {
        result = "";
        result = await repository
            .signDAO(event.tx, _applicationUser!, _privKey!)
            .then((value) => repository.sendDAO(_avalonApiNode, value));

        if (int.tryParse(result) != null) {
          emit(TransactionSent(
              block: int.parse(result),
              successMessage: "success",
              txType: event.tx.type,
              isDownvote: event.tx.data.amount! < 0 ? true : false,
              isParentContent: false));
        } else {
          emit(TransactionError(
              message: result, txType: event.tx.type, isParentContent: false));
        }
      } catch (e) {
        emit(TransactionError(
            message: e.toString(),
            txType: event.tx.type,
            isParentContent: false));
      }
    });

    on<ChangeProfileData>((event, emit) async {
      final String _avalonApiNode = await sec.getNode();
      final String? _applicationUser = await sec.getUsername();
      final String? _privKey = await sec.getPrivateKey();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      int _txType = 6;
      User _userData = event.userData;
      emit(TransactionPreprocessingState(txType: _txType));
      Map<String, dynamic> jsonMetadata = {};

      TxData _txData = new TxData(
        jsonmetadata: _userData.jsonString!.toJson(),
      );

      Transaction _tx = new Transaction(type: _txType, data: _txData);

      int _block = 0;
      String result = "";

      try {
        result = "";
        result = await repository
            .sign(_tx, _applicationUser!, _privKey!)
            .then((value) => repository.send(_avalonApiNode, value));
      } catch (e) {
        emit(TransactionError(
            message: e.toString(),
            txType: _tx.type,
            isParentContent: ((_tx.data.pa == "" || _tx.data.pa == null) &&
                (_tx.type == 4 || _tx.type == 13))));
      }

      emit(TransactionSent(
          block: _block,
          isParentContent: false,
          successMessage: "profile updated",
          txType: _txType));
      Phoenix.rebirth(event.context);
    });

    on<SendCommentEvent>((event, emit) async {
      final String _avalonApiNode = await sec.getNode();
      final String? _applicationUser = await sec.getUsername();
      final String? _privKey = await sec.getPrivateKey();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      bool errorOnUpload = false;
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
          "description": _upload.description,
          "title": _upload.title,
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
                : (_upload.vpBalance * _upload.vpPercent / 100).floor() < 1
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
                  : (_upload.vpBalance * _upload.vpPercent / 100).floor() < 1
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
          errorOnUpload = false;

          var fileJson = {};
          var vidJson = {};

          if (_upload.video480pHash != "" && _upload.video240pHash != "") {
            vidJson = {
              "240": _upload.video240pHash,
              "480": _upload.video480pHash,
              "src": _upload.videoSourceHash
            };
          } else if (_upload.video480pHash != "") {
            vidJson = {
              "480": _upload.video480pHash,
              "src": _upload.videoSourceHash
            };
          } else if (_upload.video240pHash != "") {
            vidJson = {
              "240": _upload.video240pHash,
              "src": _upload.videoSourceHash
            };
          } else {
            vidJson = {"src": _upload.videoSourceHash};
          }

          if (_upload.videoLocation == "Skynet") {
            if (_upload.videoSpriteHash != "") {
              fileJson = {
                "sia": {
                  "vid": vidJson,
                  "img": {"spr": _upload.videoSpriteHash},
                }
              };
            } else {
              fileJson = {
                "sia": {
                  "vid": vidJson,
                }
              };
            }
          } else {
            if (_upload.videoSpriteHash != "") {
              fileJson = {
                "ipfs": {
                  "vid": vidJson,
                  "img": {"spr": _upload.videoSpriteHash},
                  "gw": _upload.ipfsGateway == null
                      ? "https://player.d.tube"
                      : _upload.ipfsGateway
                }
              };
            } else {
              fileJson = {
                "ipfs": {
                  "vid": vidJson,
                  "gw": _upload.ipfsGateway == null
                      ? "https://player.d.tube"
                      : _upload.ipfsGateway
                }
              };
            }
          }

          // we have NO thumbnail location defined => ipfs uploaded image
          if (_upload.thumbnailLocation == "") {
            jsonMetadata = {
              "files": fileJson,
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
              "refs": (_upload.crossPostToHive == false)
                  ? []
                  : ["hive/" + _hiveAuthor + "/" + _upload.link]
            };
          } else {
            // we have a thumbnail location defined => no ipfs uploaded image so third party thumbnail

            // TODO: use the thirdpartyupload bloc!
            String _thumbUrl = "";
            if (!_upload.thumbnailLocation.contains("http")) {
              if (kIsWeb) {
                _thumbUrl = await uploadThumbnailFromWeb(
                    _upload.thumbBytes!, _upload.thumbnailLocation);
              } else {
                _thumbUrl = await uploadThumbnail(_upload.thumbnailLocation);
              }
            } else {
              _thumbUrl = _upload.thumbnailLocation;
            }

            jsonMetadata = {
              "files": fileJson,
              "title": _upload.title,
              "description": _upload.description,
              "dur": _upload.duration,
              "tag": _upload.tag,
              "hide": _upload.unlistVideo ? 1 : 0,
              "nsfw": _upload.nSFWContent ? 1 : 0,
              "oc": _upload.originalContent ? 1 : 0,
              "thumbnailUrlExternal": _thumbUrl,
              "thumbnailUrl": _thumbUrl,
              "app": "dtube.go.app_" +
                  packageInfo.version +
                  '+' +
                  packageInfo.buildNumber,
              "refs": (_upload.crossPostToHive == false)
                  ? []
                  : ["hive/" + _hiveAuthor + "/" + _upload.link]
            };
          }
        } else {
          // we have NO source hash => third party video
          // double check: if there is no path in _videoLocation because of upload issues
          if (!_upload.videoLocation.contains("/")) {
            // and we have A defined thumbnail location => take the uploaded thumbnail
            if (_upload.thumbnailLocation != "") {
              // TODO: use the thirdpartyupload bloc!
              String _thumbUrl = "";
              if (!_upload.thumbnailLocation.contains("http")) {
                if (kIsWeb) {
                  _thumbUrl = await uploadThumbnailFromWeb(
                      _upload.thumbBytes!, _upload.thumbnailLocation);
                } else {
                  _thumbUrl = await uploadThumbnail(_upload.thumbnailLocation);
                }
              } else {
                _thumbUrl = _upload.thumbnailLocation;
              }
              jsonMetadata = {
                "files": {"youtube": _upload.videoLocation},
                "title": _upload.title,
                "description": _upload.description,
                "dur": _upload.duration,
                "tag": _upload.tag,
                "hide": _upload.unlistVideo ? 1 : 0,
                "nsfw": _upload.nSFWContent ? 1 : 0,
                "oc": _upload.originalContent ? 1 : 0,
                "thumbnailUrlExternal": _thumbUrl,
                "thumbnailUrl": _thumbUrl,
                "app": "dtube.go.app_" +
                    packageInfo.version +
                    '+' +
                    packageInfo.buildNumber,
                "refs": (_upload.crossPostToHive == false)
                    ? []
                    : ["hive/" + _hiveAuthor + "/" + _upload.link]
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
                "refs": (_upload.crossPostToHive == false)
                    ? []
                    : ["hive/" + _hiveAuthor + "/" + _upload.link]
              };
            }
          } else {
            // if there is a path in the videoLocation -> upload probably failed silently
            errorOnUpload = true;
          }
        }
        if (!errorOnUpload) {
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
                pp: _upload.parentPermlink != ""
                    ? _upload.parentPermlink
                    : null,
                burn: _upload.burnDtc.floor());
          }
        }
      }
      if (_upload.videoLocation == "" || !errorOnUpload) {
        Transaction _tx =
            new Transaction(type: _upload.isPromoted ? 13 : 4, data: _txData);

        try {
          result = "";
          result = await repository
              .sign(_tx, _applicationUser!, _privKey!)
              .then((value) => repository.send(_avalonApiNode, value));
          print(result);
          if (!result.contains("error") && int.tryParse(result) != null) {
            emit(TransactionSent(
                block: int.parse(result),
                successMessage: txTypeFriendlyDescriptionActions[_tx.type]!,
                txType: _tx.type,
                isParentContent: (_tx.data.pa == "" || _tx.data.pa == null) &&
                    (_tx.type == 4 || _tx.type == 13),
                authorPerm: (_tx.data.pa == "" || _tx.data.pa == null) &&
                        (_tx.type == 4 || _tx.type == 13) &&
                        _tx.data.link != null
                    ? _applicationUser + '/' + _tx.data.link!
                    : null));

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
                    tag: _upload.tag,
                    dtubeuser: _applicationUser));
              } else {
                _hiveSignerBloc.add(SendPostToHive(
                    postTitle: _upload.title,
                    postBody: _upload.description,
                    permlink: _upload.link,
                    dtubeUrl: _upload.link,
                    thumbnailUrl: _upload.thumbnailLocation,
                    videoUrl: _upload.videoSourceHash,
                    storageType: "ipfs",
                    tag: _upload.tag,
                    dtubeuser: _applicationUser));
              }
            }
          } else {
            emit(TransactionError(
                message: result,
                txType: 3,
                isParentContent: event.uploadData.parentPermlink == ""));
          }
        } catch (e) {
          emit(TransactionError(
              message: e.toString(),
              txType: 3,
              isParentContent: event.uploadData.parentPermlink == ""));
        }
      } else {
        emit(TransactionError(
            message: "Upload failed - please try again",
            txType: 3,
            isParentContent: event.uploadData.parentPermlink == ""));
      }
    });
  }
}
