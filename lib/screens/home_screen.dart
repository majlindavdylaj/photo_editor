import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:photo_editor/providers/app_image_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late AppImageProvider appImageProvider;

  @override
  void initState() {
    appImageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }

  _savePhoto() async {
    final result = await ImageGallerySaver.saveImage(
        appImageProvider.currentImage!,
        quality: 100,
        name: "${DateTime.now().millisecondsSinceEpoch}");
    if(!mounted) return false;
    if(result['isSuccess']){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image saved to Gallery'),
        )
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong!'),
          )
      );
    }
  }

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
            onPressed: (){
              _savePhoto();
            },
            child: const Text('Save')
          )
        ],
      ),
      body: Stack(
        children: [
          Center(
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
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black
              ),
              child: Consumer<AppImageProvider>(
                builder: (context, value, child) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          appImageProvider.undo();
                        },
                        icon: Icon(Icons.undo,
                            color: value.canUndo ? Colors.white : Colors.white10
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          appImageProvider.redo();
                        },
                        icon: Icon(Icons.redo,
                            color: value.canRedo ? Colors.white : Colors.white10
                        ),
                      ),
                    ],
                  );
                }
              ),
            ),
          )
        ],
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
                _bottomBatItem(Icons.star_border, 'Mask',
                    onPress: () {
                      Navigator.of(context).pushNamed('/mask');
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
