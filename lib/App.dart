import 'package:dtube_go/bloc/auth/auth_bloc_full.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/startup/Startup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/utils/GlobalStorage/SecureStorage.dart' as sec;

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    // sec.deleteAllSettings(); // uncomment of you need to reset the secure storage
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
