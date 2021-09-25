import 'package:dtube_go/bloc/thirdpartyloader/thirdpartyloader_response_model.dart';
import 'package:dtube_go/utils/SecureStorage.dart' as sec;

import 'package:youtube_explode_dart/youtube_explode_dart.dart';

abstract class ThirdPartyMetadataRepository {
  Future<ThirdPartyMetadata> getMetadata(String foreignUrl);
}

class ThirdPartyMetadataRepositoryImpl implements ThirdPartyMetadataRepository {
  @override
  Future<ThirdPartyMetadata> getMetadata(String foreignUrl) async {
    String votingWeight = await sec.getDefaultVote();

    try {
      // TODO: implement more foreign systems
      var yt = YoutubeExplode();

      var video = await yt.videos.get(foreignUrl);
      print(video.title);
      ThirdPartyMetadata _meta = new ThirdPartyMetadata(
          sId: video.id.value,
          title: video.title,
          description: video.description,
          thumbUrl: video.thumbnails.standardResUrl,
          duration: video.duration!,
          videoUrl: foreignUrl,
          votingWeight: double.parse(votingWeight),
          oc: false,
          nsfw: false,
          unlist: false,
          burnDTC: 0.0);
      yt.close();
      return _meta;
    } catch (e) {
      print(e.toString());
      throw Exception();
    }
  }
}
