import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_editor/helper/tints.dart';
import 'package:photo_editor/model/tint.dart';
import 'package:photo_editor/providers/app_image_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class TintScreen extends StatefulWidget {
  const TintScreen({Key? key}) : super(key: key);

  @override
  State<TintScreen> createState() => _TintScreenState();
}

class _TintScreenState extends State<TintScreen> {

  late AppImageProvider imageProvider;
  ScreenshotController screenshotController = ScreenshotController();
  late List<Tint> tints;

  int index = 0;

  @override
  void initState() {
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    tints = Tints().list();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: const Text('Tint'),
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
                    child: Image.memory(value.currentImage!,
                      color: tints[index].color.withOpacity(tints[index].opacity),
                      colorBlendMode: BlendMode.color,
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                slider(
                    value: tints[index].opacity,
                    onChanged: (value){
                      setState(() {
                        tints[index].opacity = value;
                      });
                    }
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
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: tints.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              Tint tint = tints[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    this.index = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12, horizontal: 8
                  ),
                  child: CircleAvatar(
                    backgroundColor: this.index == index
                        ? Colors.white : Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: CircleAvatar(
                        backgroundColor: tint.color,
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        ),
      ),
    );
  }

  Widget slider({value, onChanged}) {
    return Slider(
        label: '${value.toStringAsFixed(2)}',
        value: value,
        max: 1,
        min: 0,
        onChanged: onChanged
    );
  }
}
