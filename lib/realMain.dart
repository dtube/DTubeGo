import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:dtube_go/bloc/auth/auth_bloc.dart';
import 'package:dtube_go/bloc/auth/auth_repository.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/startup/Startup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/auth/auth_event.dart';

const MaterialColor kPrimaryColor = const MaterialColor(
  0xFF223154,
  const <int, Color>{
    50: const Color(0xFF223154),
    100: const Color(0xFF223154),
    200: const Color(0xFF223154),
    300: const Color(0xFF223154),
    400: const Color(0xFF223154),
    500: const Color(0xFF223154),
    600: const Color(0xFF223154),
    700: const Color(0xFF223154),
    800: const Color(0xFF223154),
    900: const Color(0xFF223154),
  },
);

void realMain() {
  // deactivate landscape mode
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  /////////////
  runApp(
    // embedding MyApp into a Pheonix widget to be able to restart the app from within the app itself
    // used for saving the global settings to reinitialize everything based on those settings
    Phoenix(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    //sec.deleteAllSettings(); // uncomment of you need to reset the secure storage
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return BlocProvider<TransactionBloc>(
            create: (context) =>
                TransactionBloc(repository: TransactionRepositoryImpl()),
            child: MaterialApp(
              title: 'DTube',
              debugShowCheckedModeBanner: false,
              theme: dtubeDarkTheme,
              home: BlocProvider<AuthBloc>(
                create: (context) {
                  // add the AppStartedEvent to try to login with perhaps existing login credentails and forward to the startup "dialog"
                  return AuthBloc(repository: AuthRepositoryImpl())
                    ..add(AppStartedEvent());
                },
                child: StartUp(),
              ),
            ));
      },
    );
  }
}
