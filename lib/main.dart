import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shofar/constants.dart';
import 'package:shofar/providers/providers.dart';
import 'package:shofar/ui/pages/add_campaign_screen.dart';
import 'package:shofar/ui/pages/home_srceen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Color(0xfffefefe),
      statusBarIconBrightness: Brightness.dark,
      /* set Status bar icons color in Android devices.*/

      statusBarBrightness:
          Brightness.dark, /* set Status bar icon color in iOS. */
    ),
  );
  await Firebase.initializeApp();
  await Providers.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.cabinSketchTextTheme()
              .copyWith(
                bodyText1: GoogleFonts.openSansTextTheme().bodyText1,
                bodyText2: GoogleFonts.openSansTextTheme().bodyText2,
              )
              .apply(
                displayColor: secText,
                bodyColor: priText,
              )),
      home: HomeScreenScaffold(),
    );
  }
}

class HomeScreenScaffold extends StatelessWidget {
  const HomeScreenScaffold({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: HomeScreen(),
        backgroundColor: Color(0xfffefefe),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddCampaignScreen()),
            );
          },
          child: Icon(Icons.library_add),
          tooltip: "Add campaign!",
        ),
      ),
    );
  }
}

/*
Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddCampaignScreen()),
            );
 */
