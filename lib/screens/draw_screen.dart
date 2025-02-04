import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lindi/lindi.dart';
import 'package:painter/painter.dart';
import 'package:photo_editor/helper/app_color_picker.dart';
import 'package:photo_editor/helper/pixel_color_image.dart';
import 'package:photo_editor/lindi/image_viewholder.dart';
import 'package:screenshot/screenshot.dart';

class DrawScreen extends StatefulWidget {
  const DrawScreen({Key? key}) : super(key: key);

  @override
  State<DrawScreen> createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {

  late ImageViewHolder imageViewHolder;
  Uint8List? currentImage;
  ScreenshotController screenshotController = ScreenshotController();
  final PainterController _controller = PainterController();

  @override
  void initState() {
    imageViewHolder = LindiInjector.get<ImageViewHolder>();
    _controller.thickness = 5.0;
    _controller.backgroundColor = Colors.transparent;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: const Text('Draw'),
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
                  currentImage = imageViewHolder.currentImage;
                  return Screenshot(
                    controller: screenshotController,
                    child: Stack(
                      children: [
                        Image.memory(imageViewHolder.currentImage!),
                        Positioned.fill(
                          child: Painter(_controller)
                        )
                      ],
                    )
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
                      SizedBox(
                        width: 20,
                        child: Center(
                          child: Icon(
                            Icons.circle,
                            color: Colors.white,
                            size: _controller.thickness + 3,
                          ),
                        ),
                      ),
                      Expanded(
                        child: slider(
                            value: _controller.thickness,
                            onChanged: (value){
                              setState(() {
                                _controller.thickness = value;
                              });
                            }
                        ),
                      ),
                    ],
                  )
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: RotatedBox(
                  quarterTurns: _controller.eraseMode ? 2 : 0,
                  child: _bottomBarItem(Icons.create,
                      onPress: () {
                        setState(() {
                          _controller.eraseMode = !_controller.eraseMode;
                        });
                      }
                  ),
                ),
              ),
              Expanded(
                child: _bottomBarItem(Icons.color_lens_outlined,
                    onPress: () {
                      AppColorPicker().show(
                          context,
                          backgroundColor: _controller.drawColor,
                          alpha: true,
                          onPick: (color){
                            setState(() {
                              _controller.drawColor = color;
                            });
                          }
                      );
                    }
                ),
              ),
              Expanded(
                child: _bottomBarItem(Icons.colorize,
                    onPress: () {
                      PixelColorImage().show(
                          context,
                          backgroundColor: _controller.drawColor,
                          image: currentImage,
                          onPick: (color){
                            setState(() {
                              _controller.drawColor = color;
                            });
                          }
                      );
                    }
                ),
              ),
              Expanded(
                child: _bottomBarItem(Icons.undo,
                    onPress: () {
                      _controller.undo();
                    }
                ),
              ),
              Expanded(
                child: _bottomBarItem(Icons.delete,
                    onPress: () {
                      _controller.clear();
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomBarItem(IconData icon, {required onPress}) {
    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget slider({value, onChanged}) {
    return Slider(
        label: '${value.toStringAsFixed(2)}',
        value: value,
        max: 20,
        min: 1,
        onChanged: onChanged
    );
  }

}
