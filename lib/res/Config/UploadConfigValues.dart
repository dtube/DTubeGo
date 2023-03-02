class UploadConfig {
// storage providers and upload endpoints
  static String ipfsVideoUrl = "https://ipfs.d.tube/ipfs/";
  static String siaVideoUrl = "https://siasky.net/";
  static String ipfsUploadUrl = "https://ipfs.d.tube/ipfs/";

  static List<String> btfsUploadEndpoints = [
    "https://1.btfsu.d.tube",
    "https://2.btfsu.d.tube",
    "https://3.btfsu.d.tube",
    "https://4.btfsu.d.tube"
  ];

  static List<Map<String, String>> web3StorageEndpoints = [{"api": "https://upload.dtube.fso.ovh:5082",
  "tus": "http://upload.dtube.fso.ovh:1080"}];
  static String web3StorageGateway = "https://ipfs.io";
  static int maxUploadRetries = 2;

  static String ipfsSnapUrl = 'https://snap1.d.tube/ipfs/';
  static String ipfsSnapUploadUrl = 'https://snap1.d.tube';
}
