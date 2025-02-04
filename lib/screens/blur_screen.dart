import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lindi/lindi.dart';
import 'package:photo_editor/lindi/image_viewholder.dart';
import 'package:screenshot/screenshot.dart';

class BlurScreen extends StatefulWidget {
  const BlurScreen({Key? key}) : super(key: key);

  @override
  State<BlurScreen> createState() => _BlurScreenState();
}

class _BlurScreenState extends State<BlurScreen> {

  late ImageViewHolder imageViewHolder;
  ScreenshotController screenshotController = ScreenshotController();

  double sigmaX = 0.1;
  double sigmaY = 0.1;
  TileMode tileMode = TileMode.decal;

  @override
  void initState() {
    imageViewHolder = LindiInjector.get<ImageViewHolder>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: const Text('Blur'),
        actions: [
          IconButton(
              onPressed: () async {
                Uint8List? bytes = await screenshotController.capture();
                imageViewHolder.changeImage(bytes!);
                if(!mounted) return;
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.done)
          )
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: LindiBuilder(
              viewModel: imageViewHolder,
              builder: (BuildContext context) {
                if (imageViewHolder.currentImage != null) {
                  return Screenshot(
                    controller: screenshotController,
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(
                        sigmaX: sigmaX,
                        sigmaY: sigmaY,
                        tileMode: tileMode
                      ),
                      child: Image.memory(imageViewHolder.currentImage!)
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Text('X:',
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                      Expanded(
                        child: slider(
                            value: sigmaX,
                            onChanged: (value){
                              setState(() {
                                sigmaX = value;
                              });
                            }
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Y:',
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                      Expanded(
                        child: slider(
                            value: sigmaY,
                            onChanged: (value){
                              setState(() {
                                sigmaY = value;
                              });
                            }
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 100,
        color: Colors.black,
        child: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _bottomBarItem('Decal',
                    color: tileMode == TileMode.decal ? Colors.blue : null,
                    onPress: () {
                      setState(() {
                        tileMode = TileMode.decal;
                      });
                    }
                ),
                _bottomBarItem('Clamp',
                    color: tileMode == TileMode.clamp ? Colors.blue : null,
                    onPress: () {
                      setState(() {
                        tileMode = TileMode.clamp;
                      });
                    }
                ),
                _bottomBarItem('Mirror',
                    color: tileMode == TileMode.mirror ? Colors.blue : null,
                    onPress: () {
                      setState(() {
                        tileMode = TileMode.mirror;
                      });
                    }
                ),
                _bottomBarItem('Repeated',
                    color: tileMode == TileMode.repeated ? Colors.blue : null,
                    onPress: () {
                      setState(() {
                        tileMode = TileMode.repeated;
                      });
                    }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomBarItem(String title, {Color? color, required onPress}) {
    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(title,
          style: TextStyle(
              color: color ?? Colors.white70
          ),
        )
      ),
    );
  }

  Widget slider({value, onChanged}) {
    return Slider(
        label: '${value.toStringAsFixed(2)}',
        value: value,
        max: 10,
        min: 0.1,
        onChanged: onChanged
    );
  }
}
