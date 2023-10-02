import 'package:flutter/material.dart';
import 'package:photo_editor/providers/app_image_provider.dart';
import 'package:photo_editor/screens/adjust_screen.dart';
import 'package:photo_editor/screens/blur_screen.dart';
import 'package:photo_editor/screens/crop_screen.dart';
import 'package:photo_editor/screens/draw_screen.dart';
import 'package:photo_editor/screens/filter_screen.dart';
import 'package:photo_editor/screens/fit_screen.dart';
import 'package:photo_editor/screens/home_screen.dart';
import 'package:photo_editor/screens/mask_screen.dart';
import 'package:photo_editor/screens/start_screen.dart';
import 'package:photo_editor/screens/sticker_screen.dart';
import 'package:photo_editor/screens/text_screen.dart';
import 'package:photo_editor/screens/tint_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AppImageProvider())
    ],
    child: const MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Editor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xff111111),
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          color: Colors.black,
          centerTitle: true,
          elevation: 0
        ),
        sliderTheme: const SliderThemeData(
          showValueIndicator: ShowValueIndicator.always
        )
      ),
      routes: <String, WidgetBuilder>{
        '/': (_) => const StartScreen(),
        '/home': (_) => const HomeScreen(),
        '/crop': (_) => const CropScreen(),
        '/filter': (_) => const FilterScreen(),
        '/adjust': (_) => const AdjustScreen(),
        '/fit': (_) => const FitScreen(),
        '/tint': (_) => const TintScreen(),
        '/blur': (_) => const BlurScreen(),
        '/sticker': (_) => const StickerScreen(),
        '/text': (_) => const TextScreen(),
        '/draw': (_) => const DrawScreen(),
        '/mask': (_) => const MaskScreen()
      },
      initialRoute: '/',
    );
  }
}
