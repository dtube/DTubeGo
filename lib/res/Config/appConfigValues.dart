// list of global static application configurations
class AppConfig {
  static String defaultWebsiteURL =
      "https://d.tube"; // used for generating links for sharing

// verified url schemes
  static String originalDtuberListUrl = "https://dtube.fso.ovh/oc/creators";
  static String originalDtuberCheckUrl =
      "https://dtube.fso.ovh/oc/creator/##USERNAME";

  static int minFreeSpaceRecordVideoInMB =
      50; // min free space to enable the user to record video in app

// urls for login screen
  static String signUpUrl = "https://signup.dtube.fso.ovh";
  static String readmoreUrl = "https://token.d.tube";
  static String discordUrl = "https://discord.gg/dtube";
  static String faqUrl = "https://d.tube/#!/wiki/faq/README";
  static String gitDTubeGoUrl = "https://github.com/dtube/DTubeGo";
  static String gitAvalonUrl = "https://github.com/dtube/avalon";
  static String gitDtubeUrl = "https://github.com/dtube/dtube";

  // activate/deactivate first user journey
  static bool faqStartup = true; // show on first startup
  static bool faqVisible = false; // make the FAQ videos visible

// only show moments of the last x days
  static int momentsPastXDays = -30;

// minimum user name length to save DTube coins
  static int usernameMinLength = 12;
}
