import 'dart:typed_data';

import 'package:colorfilter_generator/addons.dart';
import 'package:colorfilter_generator/colorfilter_generator.dart';
import 'package:flutter/material.dart';
import 'package:photo_editor/providers/app_image_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class AdjustScreen extends StatefulWidget {
  const AdjustScreen({Key? key}) : super(key: key);

  @override
  State<AdjustScreen> createState() => _AdjustScreenState();
}

class _AdjustScreenState extends State<AdjustScreen> {

  double brightness = 0;
  double contrast = 0;
  double saturation = 0;
  double hue = 0;
  double sepia = 0;

  bool showBrightness = true;
  bool showContrast = false;
  bool showSaturation = false;
  bool showHue = false;
  bool showSepia = false;

  late ColorFilterGenerator adj;

  late AppImageProvider imageProvider;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    adjust();
    super.initState();
  }

  adjust({b, c, s, h, se}){
    adj = ColorFilterGenerator(
      name: 'Adjust',
      filters: [
        ColorFilterAddons.brightness(b ?? brightness),
        ColorFilterAddons.contrast(c ?? contrast),
        ColorFilterAddons.saturation(s ?? saturation),
        ColorFilterAddons.hue(h ?? hue),
        ColorFilterAddons.sepia(se ?? sepia),
      ]
    );
  }

  showSlider({b, c, s, h, se}){
    setState(() {
      showBrightness = b != null ? true : false;
      showContrast = c != null ? true : false;
      showSaturation = s != null ? true : false;
      showHue = h != null ? true : false;
      showSepia = se != null ? true : false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: const Text('Adjust'),
        actions: [
          IconButton(
              onPressed: () async {
                Uint8List? bytes = await screenshotController.capture();
                imageProvider.changeImage(bytes!);
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
            child: Consumer<AppImageProvider>(
              builder: (BuildContext context, value, Widget? child) {
                if (value.currentImage != null) {
                  return Screenshot(
                    controller: screenshotController,
                    child: ColorFiltered(
                      colorFilter: ColorFilter.matrix(adj.matrix),
                      child: Image.memory(value.currentImage!)
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
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Visibility(
                        visible: showBrightness,
                        child: slider(
                          value: brightness,
                          onChanged: (value){
                            setState(() {
                              brightness = value;
                              adjust(b: brightness);
                            });
                          }
                        ),
                      ),
                      Visibility(
                        visible: showContrast,
                        child: slider(
                            value: contrast,
                            onChanged: (value){
                              setState(() {
                                contrast = value;
                                adjust(c: contrast);
                              });
                            }
                        ),
                      ),
                      Visibility(
                        visible: showSaturation,
                        child: slider(
                            value: saturation,
                            onChanged: (value){
                              setState(() {
                                saturation = value;
                                adjust(s: saturation);
                              });
                            }
                        ),
                      ),
                      Visibility(
                        visible: showHue,
                        child: slider(
                            value: hue,
                            onChanged: (value){
                              setState(() {
                                hue = value;
                                adjust(h: hue);
                              });
                            }
                        ),
                      ),
                      Visibility(
                        visible: showSepia,
                        child: slider(
                            value: sepia,
                            onChanged: (value){
                              setState(() {
                                sepia = value;
                                adjust(se: sepia);
                              });
                            }
                        ),
                      )
                    ],
                  ),
                ),
                TextButton(
                  child: const Text('RESET',
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      brightness = 0;
                      contrast = 0;
                      saturation = 0;
                      hue = 0;
                      sepia = 0;
                      adjust(
                        b: brightness,
                        c: contrast,
                        s: saturation,
                        h: hue,
                        se: sepia
                      );
                    });
                  },
                ),
              ],
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
                _bottomBatItem(Icons.brightness_4_rounded, 'Brightness',
                  color: showBrightness ? Colors.blue : null,
                  onPress: () {
                    showSlider(b: true);
                  }
                ),
                _bottomBatItem(Icons.contrast, 'Contrast',
                  color: showContrast ? Colors.blue : null,
                  onPress: () {
                    showSlider(c: true);
                  }
                ),
                _bottomBatItem(Icons.water_drop, 'Saturation',
                  color: showSaturation ? Colors.blue : null,
                  onPress: () {
                    showSlider(s: true);
                  }
                ),
                _bottomBatItem(Icons.filter_tilt_shift, 'Hue',
                  color: showHue ? Colors.blue : null,
                  onPress: () {
                    showSlider(h: true);
                  }
                ),
                _bottomBatItem(Icons.motion_photos_on, 'Sepia',
                  color: showSepia ? Colors.blue : null,
                  onPress: () {
                    showSlider(se: true);
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomBatItem(IconData icon, String title, {Color? color, required onPress}) {
    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color ?? Colors.white),
            const SizedBox(height: 3),
            Text(title,
              style: TextStyle(
                  color: color ?? Colors.white70
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget slider({value, onChanged}) {
    return Slider(
      label: '${value.toStringAsFixed(2)}',
      value: value,
      max: 1,
      min: -0.9,
      onChanged: onChanged
    );
  }

}
