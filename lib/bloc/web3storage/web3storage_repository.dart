import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dtube_go/res/Config/UploadConfigValues.dart';
import 'package:dtube_go/utils/Crypto/crypto_convert.dart';
import 'package:dtube_go/utils/GlobalStorage/globalVariables.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dtube_go/bloc/transaction/sign_offchain_data.dart';
import 'package:dtube_go/utils/GlobalStorage/SecureStorage.dart' as sec;

//TODO: connect to local ipfs daemon:
// - https://github.com/hanerx/ipfs-dart
// - https://github.com/ngngardner/dart_ipfs_client
import 'package:tus_client/tus_client.dart';
import 'dart:io';
import 'package:video_compress/video_compress.dart';
import 'package:dtube_go/res/Config/secretConfigValues.dart' as secret;

abstract class Web3StorageRepository {
  Future<File> compressVideo(String localFilePath);
  Future<String> createThumbnailFromVideo(String localFilePath);
  Future<Map<String,String>> getUploadEndpoint();
  Future<String> uploadVideo(String localFilePath, Map<String,String> endpoint);
  Future<String> uploadThumbnail(String localFilePath);
  // Future<Map<String, dynamic>> monitorVideoUploadStatus(
  //     String token, String endpoint);
  // Future<Map> monitorThumbnailUploadStatus(String token);
}

class Web3StorageRepositoryImpl implements Web3StorageRepository {
  @override
  Future<File> compressVideo(String localFilePath) async {
    try {
      // await VideoCompress.setLogLevel(4);
      // MediaInfo? mediaInfo = await VideoCompress.compressVideo(localFilePath,
      //     //all qualities: https://github.com/jonataslaw/VideoCompress/blob/e6c936b9e78dcb5ece649d4960bfc739642a65a6/lib/src/video_compress/video_quality.dart
      //     quality: VideoQuality.DefaultQuality,
      //     includeAudio: true);

      // return File(mediaInfo!.path!);
      return File(localFilePath);
    } catch (e) {
      print(e.toString());
      throw Exception();
    }
  }

  Future<String> createThumbnailFromVideo(String localFilePath) async {
    try {
      //await VideoCompress.setLogLevel(4);
      File _thumb = await VideoCompress.getFileThumbnail(
        localFilePath,
      );

      return _thumb.path;
    } catch (e) {
      print(e.toString());
      throw Exception();
    }
  }

  Future<Map<String, String>> getUploadEndpoint() async {
    List<Map<String,String>> validWeb3StorageUploadEndpoints = [];
    for (var url in UploadConfig.web3StorageEndpoints) {
      //   var response = await http.get(Uri.parse(url + '/getStatus'));
      //   if (response.statusCode == 200) {
      //     validWeb3StorageUploadEndpoints.add(url);
      //   }
      // }
      validWeb3StorageUploadEndpoints.add(url);
    }
    validWeb3StorageUploadEndpoints.shuffle();

    if (validWeb3StorageUploadEndpoints.isNotEmpty) {
      return validWeb3StorageUploadEndpoints[0];
    } else {
      return {"tus": "", "api": ""};
    }
  }

  Future<String> uploadVideo(String localFilePath, Map<String, String> endpoint) async {
    Uri _url = Uri.parse(endpoint["tus"]! + '/upload');
    String apiKeyHeader = secret.web3ApiKey;
    String _privKey = await sec.getPrivateKey();
    String pubKey = privToPub(_privKey);
    int ts = DateTime.now().millisecondsSinceEpoch;
    DataSigner dataSigner = new DataSigner();
    SignData signedData = await dataSigner.signOffchainData(applicationUsername+"_"+ts.toString(), applicationUsername, ts);
    // print(jsonEncode(signedData));
    String localFileName = localFilePath.split("/")[localFilePath.split("/").length-1];
    print(localFileName);
    final xfile = XFile(localFilePath);
    print(await xfile.length());
    // print(base64UrlEncode(JSONToUTF8.convert(signedData.toJson().toString())));
    // print(signedData.toJson().toString());
    JsonUtf8Encoder JSONToUTF8 = new JsonUtf8Encoder();
    final client = TusClient(
        _url,
        xfile,
        store: TusMemoryStore(),
        headers: {
          'contentType': 'video/mp4',
          'apikey': apiKeyHeader,
          'username': applicationUsername,
          'ts': ts.toString(),
          'signature': base64Encode(JSONToUTF8.convert(signedData.toJson())),
          "pubkey": pubKey,
        },
        metadata: {
          "filename": localFileName,"filetype": "video/mp4",
          "username": applicationUsername, "pubkey": pubKey
        },
    );
    String cid = "";
    do {
      await client.upload(
        onComplete: () async {
          log("Complete!");
          String tmpUrl = client.uploadUrl.toString();
          String token = tmpUrl.split("/")[tmpUrl
              .split("/")
              .length - 1];
          String _tokenUrl = endpoint["api"]! + "/progress/" + token;

          BaseOptions options = new BaseOptions(
              connectTimeout: Duration(seconds: 60), // 60 seconds
              receiveTimeout: Duration(seconds: 60), // 60 seconds
              headers: {
                'contentType': 'video/mp4',
                'apikey': apiKeyHeader,
                'username': applicationUsername,
                'ts': ts.toString(),
                'signature': base64Encode(JSONToUTF8.convert(signedData.toJson())),
                "pubkey": pubKey,
            }
          );
          var dioToken = new Dio(options);
          dioToken.options.headers["apikey"] = apiKeyHeader;
          do {
            try {
              await Future.delayed(Duration(seconds: 15));
              print(_tokenUrl);
              var responseTokenQuery = await dioToken.get(_tokenUrl);
              if (responseTokenQuery.statusCode == 200) {
                print("progress checked");
                var progressData = responseTokenQuery.data;
                if (progressData["status"] == 'error') {
                  break;
                }
                if (progressData["progress"] == "uploaded") {
                  cid = progressData["cid"];
                  print("cid=" + cid);
                }
              }
            } on DioError catch (e) {
              if (e.response != null) {
                if (e.response?.statusCode != 404) {
                  throw e;
                }
              } else {
                throw e;
              }
            }
          } while (cid == "");
          // var url = client.uploadUrl.toString();
          log(cid);
          return cid;
          // var pathImageThumb = await getThumbnail(xfile.path);
        },
        onProgress: (progress) {
          log("Progress: $progress");
        },
      );
    } while (cid == "");
    return cid;
  /*
    var formData = FormData.fromMap({
      'video': await MultipartFile.fromFile(
        // localFilePath,
        filename: 'video.mp4',

      )

   */
    }
// TODO: support more providers
  Future<String> uploadThumbnail(String localFilePath) async {
    //String _url = endpoint;
    String _url = "https://api.imgur.com/3/upload";

    String authHeader = "Client-ID " + secret.imgurClientID;

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

  // Future<Map> monitorThumbnailUploadStatus(String token) async {
  //   var dio = Dio();

  //   String url = AppConfig.ipfsSnapUploadUrl + '/getProgressByToken/' + token;

  //   var response = await dio.get(url);
  //   print(response.statusCode);
  //   if (response.statusCode == 200) {
  //     var data = json.decode(response.data);

  //     return data;
  //   } else {
  //     throw Exception();
  //   }
  // }

  // Future<Map<String, dynamic>> monitorVideoUploadStatus(
  //     String token, String endpoint) async {
  //   var dio = Dio();
  //   int tsNow = DateTime.now().millisecondsSinceEpoch;
  //   String url =
  //       endpoint + '/getProgressByToken/' + token + '?_=' + tsNow.toString();
  //   var response = await dio.get(url);
  //   if (response.statusCode == 200) {
  //     var data = response.data;

  //     return data;
  //   } else {
  //     throw Exception();
  //   }
  // }
}
