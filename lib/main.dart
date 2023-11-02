import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gocabs_live/Screens/homescreen.dart';
import 'package:gocabs_live/config.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
          primaryColor: schemecolor,
          appBarTheme: AppBarTheme(
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: schemecolor,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: schemecolor,
              )),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                primary: schemecolor, onPrimary: Colors.white),
          ),
          textTheme: GoogleFonts.outfitTextTheme(
            Theme.of(context).textTheme,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: schemecolor,
          ),
          scaffoldBackgroundColor: bgcolor,
          fontFamily: GoogleFonts.outfit().fontFamily),
      darkTheme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: MyTabs(),
    );
  }
}
