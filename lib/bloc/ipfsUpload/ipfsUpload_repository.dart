//TODO: connect to local ipfs deamon:
// - https://github.com/hanerx/ipfs-dart
// - https://github.com/ngngardner/dart_ipfs_client

import 'dart:io';

import 'package:dtube_go/res/appConfigValues.dart';
import 'package:video_compress/video_compress.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:dio/dio.dart';

abstract class IPFSUploadRepository {
  Future<File> compressVideo(String localFilePath);
  Future<String> createThumbnailFromVideo(String localFilePath);
  Future<String> getUploadEndpoint();
  Future<String> uploadVideo(String localFilePath, String endpoint);
  Future<String> uploadThumbnail(String localFilePath);
  Future<Map> monitorVideoUploadStatus(String token, String endpoint);
  Future<Map> monitorThumbnailUploadStatus(String token);
}

class IPFSUploadRepositoryImpl implements IPFSUploadRepository {
  @override
  Future<File> compressVideo(String localFilePath) async {
    try {
      await VideoCompress.setLogLevel(4);
      MediaInfo? mediaInfo = await VideoCompress.compressVideo(localFilePath,
          //all qualities: https://github.com/jonataslaw/VideoCompress/blob/e6c936b9e78dcb5ece649d4960bfc739642a65a6/lib/src/video_compress/video_quality.dart
          quality: VideoQuality.DefaultQuality,
          includeAudio: true);

      return File(mediaInfo!.path!);
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

  Future<String> getUploadEndpoint() async {
    List<String> validBTFSUploadEndpoints = [];
    for (var url in AppConfig.btfsUploadEndpoints) {
      var response = await http.get(Uri.parse(url + '/getStatus'));
      if (response.statusCode == 200) {
        validBTFSUploadEndpoints.add(url);
      }
    }
    validBTFSUploadEndpoints.shuffle();

    if (validBTFSUploadEndpoints.isNotEmpty) {
      return validBTFSUploadEndpoints[0];
    } else {
      return "";
    }
  }

  Future<String> uploadVideo(String localFilePath, String endpoint) async {
    String _url = endpoint +
        '/uploadVideo?videoEncodingFormats=240p,480p,720p,1080p&sprite=true';

    var formData = FormData.fromMap({
      'files':
          await MultipartFile.fromFile(localFilePath, filename: 'video.mp4')
    });
    var dio = Dio();

    var response = await dio.post(_url, data: formData);
    if (response.statusCode == 200) {
      var data = response.data;
      String token = data["token"];
      return token;
    } else {
      throw Exception();
    }
  }

// TODO: support more providers
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

  Future<Map> monitorThumbnailUploadStatus(String token) async {
    var dio = Dio();

    String url = AppConfig.ipfsSnapUploadUrl + '/getProgressByToken/' + token;

    var response = await dio.get(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = json.decode(response.data);

      return data;
    } else {
      throw Exception();
    }
  }

  Future<Map> monitorVideoUploadStatus(String token, String endpoint) async {
    var dio = Dio();
    int tsNow = DateTime.now().millisecondsSinceEpoch;
    String url =
        endpoint + '/getProgressByToken/' + token + '?_=' + tsNow.toString();
    var response = await dio.get(url);
    if (response.statusCode == 200) {
      var data = response.data;

      return data;
    } else {
      throw Exception();
    }
  }
}
