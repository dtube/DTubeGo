import 'dart:io';

import 'package:video_compress/video_compress.dart';

abstract class IPFSUploadRepository {
  Future<File> compressVideo(String localFilePath);
  // Future<String> uploadFile(String localFilePath);
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
  // Future<String> uploadFile(String localFilePath) async {
  //   var response = await http.post(Uri.parse(AppStrings.ipfsUploadUrl));
  //   if (response.statusCode == 200) {
  //     var data = json.decode(response.body);

  //     List<FeedItem> feed = ApiResultModel.fromJson(data).feed;
  //     return feed;
  //   } else {
  //     throw Exception();
  //   }
  // }

}
