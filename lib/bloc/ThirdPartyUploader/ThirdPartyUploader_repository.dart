import 'package:dio/dio.dart';

abstract class ThirdPartyUploaderRepository {
  Future<String> getUploadServiceEndpoint(String provider);

  Future<String> uploadFile(String localFilePath, String endpoint);
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
}
