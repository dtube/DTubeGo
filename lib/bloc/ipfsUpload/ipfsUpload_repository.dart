import 'package:path/path.dart';
//TODO: connect to local ipfs deamon:
// - https://github.com/hanerx/ipfs-dart
// - https://github.com/ngngardner/dart_ipfs_client

import 'dart:io';

import 'package:dtube_togo/res/strings/strings.dart';
import 'package:video_compress/video_compress.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

abstract class IPFSUploadRepository {
  Future<File> compressVideo(String localFilePath);
  Future<String> createThumbnailFromVideo(String localFilePath);
  Future<String> getUploadEndpoint();
  Future<String> uploadVideo(String localFilePath, String endpoint);
  Future<String> uploadThumbnail(
      String localFilePath, String generatedFilePath);
  Future<Map> monitorVideoUploadStatus(String token, String endpoint);
  Future<Map> monitorThumbnailUploadStatus(String token);
}

class IPFSUploadRepositoryImpl implements IPFSUploadRepository {
  @override
  Future<File> compressVideo(String localFilePath) async {
    try {
      //await VideoCompress.setLogLevel(4);
      MediaInfo? mediaInfo = await VideoCompress.compressVideo(
        localFilePath,
        quality: VideoQuality.DefaultQuality,
        deleteOrigin: false, // It's false by default
      );

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
    for (var url in AppStrings.btfsUploadEndpoints) {
      var response = await http.get(Uri.parse(url + '/getStatus'));
      if (response.statusCode == 200) {
        validBTFSUploadEndpoints.add(url);
      }
    }
    validBTFSUploadEndpoints.shuffle();

    if (validBTFSUploadEndpoints[0] != null) {
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

  Future<String> uploadThumbnail(
      String localThumbnail, String generatedThumbnail) async {
    String _url = AppStrings.ipfsSnapUploadUrl + '/uploadImage';
    String _filePath =
        localThumbnail != '' ? localThumbnail : generatedThumbnail;

    var formData = FormData.fromMap({
      'files':
          await MultipartFile.fromFile(_filePath, filename: basename(_filePath))
    });
    var dio = Dio();

    var response = await dio.post(_url, data: formData);

    if (response.statusCode == 200) {
      var data = json.decode(response.data);
      String token = data["token"];
      return token;
    } else {
      throw Exception();
    }
  }

  Future<Map> monitorThumbnailUploadStatus(String token) async {
    var dio = Dio();

    String url = AppStrings.ipfsSnapUploadUrl + '/getProgressByToken/' + token;

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
