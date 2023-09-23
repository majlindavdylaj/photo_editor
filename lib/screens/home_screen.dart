import 'package:flutter/material.dart';
import 'package:photo_editor/providers/app_image_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Photo Editor"),
        leading: CloseButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        actions: [
          TextButton(
            onPressed: (){},
            child: const Text('Save')
          )
        ],
      ),
      body: Center(
        child: Consumer<AppImageProvider>(
          builder: (BuildContext context, value, Widget? child){
            if(value.currentImage != null){
              return Image.memory(
                  value.currentImage!,
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 60,
        color: Colors.black,
        child: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _bottomBatItem(Icons.crop_rotate, 'Crop',
                  onPress: () {
                    Navigator.of(context).pushNamed('/crop');
                  }
                ),
                _bottomBatItem(Icons.filter_vintage_outlined, 'Filters',
                  onPress: () {
                    Navigator.of(context).pushNamed('/filter');
                  }
                ),
                _bottomBatItem(Icons.tune, 'Adjust',
                    onPress: () {
                      Navigator.of(context).pushNamed('/adjust');
                    }
                ),
                _bottomBatItem(Icons.fit_screen_sharp, 'Fit',
                    onPress: () {
                      Navigator.of(context).pushNamed('/fit');
                    }
                ),
                _bottomBatItem(Icons.border_color_outlined, 'Tint',
                    onPress: () {
                      Navigator.of(context).pushNamed('/tint');
                    }
                ),
                _bottomBatItem(Icons.blur_circular, 'Blur',
                    onPress: () {
                      Navigator.of(context).pushNamed('/blur');
                    }
                ),
                _bottomBatItem(Icons.emoji_emotions_outlined, 'Sticker',
                    onPress: () {
                      Navigator.of(context).pushNamed('/sticker');
                    }
                ),
                _bottomBatItem(Icons.text_fields, 'Text',
                    onPress: () {
                      Navigator.of(context).pushNamed('/text');
                    }
                ),
                _bottomBatItem(Icons.draw, 'Draw',
                    onPress: () {
                      Navigator.of(context).pushNamed('/draw');
                    }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomBatItem(IconData icon, String title, {required onPress}){
    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(height: 3),
            Text(title,
              style: const TextStyle(
                color: Colors.white70
              ),
            )
          ],
        ),
      ),
    );
  }

}
