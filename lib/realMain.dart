import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:sizer/sizer.dart';

import 'package:dtube_togo/bloc/transaction/transaction_bloc.dart';
import 'package:dtube_togo/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_togo/ui/widgets/customSnackbar.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

// this file is needed until bs85 is null safety
import 'package:flutter/services.dart';
import 'package:dtube_togo/bloc/auth/auth_bloc.dart';
import 'package:dtube_togo/bloc/auth/auth_repository.dart';
import 'package:dtube_togo/style/ThemeData.dart';
import 'package:dtube_togo/ui/startup/Startup.dart';
import 'package:dtube_togo/utils/AppBuilder.dart';

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
  runApp(Phoenix(
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late TransactionBloc txBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBuilder(
      builder: (context) {
        return BlocProvider<TransactionBloc>(
            create: (context) =>
                TransactionBloc(repository: TransactionRepositoryImpl()),
            child: Sizer(builder: (context, orientation, deviceType) {
              return MaterialApp(
                builder: (context, widget) => ResponsiveWrapper.builder(
                    BouncingScrollWrapper.builder(context, widget!),
                    maxWidth: 1200,
                    minWidth: 480,
                    defaultScale: true,
                    breakpoints: [
                      ResponsiveBreakpoint.resize(480, name: MOBILE),
                      ResponsiveBreakpoint.autoScale(800, name: TABLET),
                      ResponsiveBreakpoint.resize(1000, name: DESKTOP),
                    ],
                    background: Container(color: Color(0xFFF5F5F5))),
                title: 'DTube',
                debugShowCheckedModeBanner: false,
                theme: dtubeDarkTheme,
                home: BlocProvider<AuthBloc>(
                  create: (context) {
                    return AuthBloc(repository: AuthRepositoryImpl())
                      ..add(AppStartedEvent());
                  },
                  child: StartUp(),
                ),
              );
            }));
      },
    );
  }
}
