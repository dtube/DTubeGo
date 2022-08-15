class APINodeConfig {
// node discovery & api node configs

  static bool useDevNodes =
      false; //activate for new features which has not been integrated

  static List<String> apiNodesDev = [
    // development nodes for new features
    // 'https://dtube.club/mainnetapi',
    'https://testnetapi.avalonblocks.com'
    //'https://avalon.tibfox.com'
  ];

  static List<String> apiNodes = [
    // common api nodes
    'https://avalon.tibfox.com',
    'https://avalon.d.tube',
    // 'https://dtube.club/mainnetapi',
    'https://avalon.oneloved.tube',
    'https://dtube.fso.ovh'
  ];

// node discovery & api node configs
  static Duration nodeDescoveryTimeout = Duration(milliseconds: 200);
}
