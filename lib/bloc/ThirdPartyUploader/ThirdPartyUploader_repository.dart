import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

// reimplement all of the file uploads for web extra
// big files: https://stackoverflow.com/questions/70079208/how-to-upload-large-files-in-flutter-web

abstract class ThirdPartyUploaderRepository {
  Future<String> getUploadServiceEndpoint(String provider);

  Future<String> uploadFile(String localFilePath, String endpoint);
  Future<String> uploadFileFromWeb(String localFilePath, String endpoint);
}

class ThirdPartyUploaderRepositoryImpl implements ThirdPartyUploaderRepository {
  @override
  Future<String> getUploadServiceEndpoint(String provider) async {
    if (provider == "imgur") {
      return "https://api.imgur.com/3/image";
    }
    return "https://api.imgur.com/3/image";
  }

// TODO: support more providers
  Future<String> uploadFile(String localFilePath, String endpoint) async {
    String _url = endpoint;
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

// TODO: big files
// big files: https://stackoverflow.com/questions/70079208/how-to-upload-large-files-in-flutter-web
// https://pub.dev/packages/large_file_uploader
  Future<String> uploadFileFromWeb(
      String localFilePath, String endpoint) async {
    String _url = endpoint;
    String authHeader = "Client-ID fc2dde68a83c037";

    var dio = Dio();
    dio.options.headers["Authorization"] = authHeader;
    String fileName = localFilePath.split('/').last;

    var _fileBytes = await PickedFile(localFilePath).readAsBytes();

    FormData data = FormData.fromMap({
      "image": MultipartFile.fromBytes(
        _fileBytes,
        filename: fileName,
      ),
    });

    var response = await dio.post(
      _url,
      data: data,
    );

    if (response.statusCode == 200) {
      var uploadedUrl = response.data['data']['link'];
      // var uploadedUrl = "";

      return uploadedUrl;
    } else {
      throw Exception();
    }
  }
}
