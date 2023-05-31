import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:data/bloc/bloc/note_bloc.dart';
import 'package:data/bloc/states/crud_state.dart';
import 'package:data/database/db_controller.dart';
import 'package:data/pref/shared_pref_controller.dart';
import 'package:data/screens/app/main_screen.dart';
import 'package:data/screens/auth/login_screen.dart';
import 'package:data/screens/auth/sign_up_screen.dart';
import 'package:data/screens/core/launch.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefController().initPreferences();
  await DbController().initDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NoteBloc(LoadingState()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
              elevation: 0,
              color: Colors.white,
              titleTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20,
              ),
              iconTheme: IconThemeData(
                color: Colors.black,
              )),
        ),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('ar'),
        ],
        // localizationsDelegates: AppLocalizations.localizationsDelegates,
        // supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        //Locale(Provider.of<LanguageProvider>(context, listen: true).language),

        initialRoute: '/launch',
        routes: {
          '/launch': (context) => const Launch(),
          '/login': (context) => const LoginScreen(),
          '/sign_up_screen': (context) => const SignUpScreen(),
          '/main': (context) => const MainScreen(),
        },
      ),
    );
  }
}
