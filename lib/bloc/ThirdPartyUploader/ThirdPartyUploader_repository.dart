import 'package:dtube_togo/res/appConfigValues.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

abstract class ThirdPartyUploaderRepository {
  Future<String> getUploadServiceEndpoint();

  Future<String> uploadFile(String localFilePath, String endpoint);
}

class ThirdPartyUploaderRepositoryImpl implements ThirdPartyUploaderRepository {
  @override
  Future<String> getUploadServiceEndpoint() async {
    // todo: support other providers
    return "https://api.imgur.com/3/image";
  }

// TODO: error handling
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
