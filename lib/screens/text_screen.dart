import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lindi_sticker_widget/lindi_controller.dart';
import 'package:lindi_sticker_widget/lindi_sticker_widget.dart';
import 'package:photo_editor/helper/fonts.dart';
import 'package:photo_editor/providers/app_image_provider.dart';
import 'package:provider/provider.dart';
import 'package:text_editor/text_editor.dart';

class TextScreen extends StatefulWidget {
  const TextScreen({Key? key}) : super(key: key);

  @override
  State<TextScreen> createState() => _TextScreenState();
}

class _TextScreenState extends State<TextScreen> {

  late AppImageProvider imageProvider;
  LindiController controller = LindiController();
  
  bool showEditor = true;

  @override
  void initState() {
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
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
                    imageProvider.changeImage(image!);
                    if(!mounted) return;
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.done)
              )
            ],
          ),
          body: Center(
            child: Consumer<AppImageProvider>(
              builder: (BuildContext context, value, Widget? child) {
                if (value.currentImage != null) {
                  return LindiStickerWidget(
                      controller: controller,
                      child: Image.memory(value.currentImage!)
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
            height: 50,
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
                      controller.addWidget(
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
