import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lindi/lindi.dart';
import 'package:lindi_sticker_widget/lindi_controller.dart';
import 'package:lindi_sticker_widget/lindi_sticker_icon.dart';
import 'package:lindi_sticker_widget/lindi_sticker_widget.dart';
import 'package:photo_editor/helper/fonts.dart';
import 'package:photo_editor/lindi/image_viewholder.dart';
import 'package:text_editor/text_editor.dart';

class TextScreen extends StatefulWidget {
  const TextScreen({Key? key}) : super(key: key);

  @override
  State<TextScreen> createState() => _TextScreenState();
}

class _TextScreenState extends State<TextScreen> {

  late ImageViewHolder imageViewHolder;
  late LindiController controller;
  
  bool showEditor = true;

  @override
  void initState() {
    imageViewHolder = LindiInjector.get<ImageViewHolder>();
    controller = LindiController(
        icons: [
          LindiStickerIcon(
              icon: Icons.done,
              alignment: Alignment.topRight,
              onTap: () {
                controller.selectedWidget!.done();
              }),
          LindiStickerIcon(
              icon: Icons.lock_open,
              lockedIcon: Icons.lock,
              alignment: Alignment.topCenter,
              type: IconType.lock,
              onTap: () {
                controller.selectedWidget!.lock();
              }),
          LindiStickerIcon(
              icon: Icons.close,
              alignment: Alignment.topLeft,
              onTap: () {
                controller.selectedWidget!.delete();
              }),
          LindiStickerIcon(
              icon: Icons.layers,
              alignment: Alignment.bottomCenter,
              onTap: () {
                controller.selectedWidget!.stack();
              }),
          LindiStickerIcon(
              icon: Icons.flip,
              alignment: Alignment.bottomLeft,
              onTap: () {
                controller.selectedWidget!.flip();
              }),
          LindiStickerIcon(
              icon: Icons.crop_free,
              alignment: Alignment.bottomRight,
              type: IconType.resize
          ),
        ]
    );
    controller.onPositionChange((index) {
      debugPrint(
          "widgets size: ${controller.widgets.length}, current index: $index");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: const CloseButton(),
            title: const Text('Text'),
            actions: [
              IconButton(
                  onPressed: () async {
                    Uint8List? image = await controller.saveAsUint8List();
                    imageViewHolder.changeImage(image!);
                    if(!mounted) return;
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.done)
              )
            ],
          ),
          body: Center(
            child: LindiBuilder(
              viewModel: imageViewHolder,
              builder: (BuildContext context) {
                if (imageViewHolder.currentImage != null) {
                  return LindiStickerWidget(
                      controller: controller,
                      child: Image.memory(imageViewHolder.currentImage!)
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
            height: 80,
            color: Colors.black,
            child: Center(
              child: TextButton(
                onPressed: (){
                  setState(() {
                    showEditor = true;
                  });
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, color: Colors.white),
                    Text("Add Text",
                      style: TextStyle(
                        color: Colors.white
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        if(showEditor)
        Scaffold(
          backgroundColor: Colors.black.withOpacity(0.85),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: TextEditor(
                fonts: Fonts().list(),
                textStyle: const TextStyle(color: Colors.white),
                minFontSize: 10,
                maxFontSize: 70,
                onEditCompleted: (style, align, text) {
                  setState(() {
                    showEditor = false;
                    if(text.isNotEmpty){
                      controller.add(
                          Text(text,
                            textAlign: align,
                            style: style,
                          )
                      );
                    }
                  });
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}
