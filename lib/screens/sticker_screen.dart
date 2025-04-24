import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lindi/lindi.dart';
import 'package:lindi_sticker_widget/lindi_controller.dart';
import 'package:lindi_sticker_widget/lindi_sticker_icon.dart';
import 'package:lindi_sticker_widget/lindi_sticker_widget.dart';
import 'package:photo_editor/helper/stickers.dart';
import 'package:photo_editor/lindi/image_view_model.dart';

class StickerScreen extends StatefulWidget {
  const StickerScreen({Key? key}) : super(key: key);

  @override
  State<StickerScreen> createState() => _StickerScreenState();
}

class _StickerScreenState extends State<StickerScreen> {
  late ImageViewModel imageViewModel;
  late LindiController controller;

  int index = 0;

  @override
  void initState() {
    imageViewModel = LindiInjector.get<ImageViewModel>();
    controller = LindiController(icons: [
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
          type: IconType.resize),
    ]);
    controller.onPositionChange((index) {
      debugPrint(
          "widgets size: ${controller.widgets.length}, current index: $index");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: const Text('Sticker'),
        actions: [
          IconButton(
              onPressed: () async {
                Uint8List? image = await controller.saveAsUint8List();
                imageViewModel.changeImage(image!);
                if (!context.mounted) return;
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.done))
        ],
      ),
      body: Center(
        child: LindiBuilder(
          viewModel: imageViewModel,
          builder: (BuildContext context) {
            if (imageViewModel.currentImage != null) {
              return Container(
                color: Colors.red,
                child: LindiStickerWidget(
                    controller: controller,
                    child: Image.memory(imageViewModel.currentImage!)),
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
        height: 160,
        color: Colors.black,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                    color: Colors.black,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: Stickers().list()[index].length,
                      itemBuilder: (BuildContext context, int idx) {
                        String sticker = Stickers().list()[index][idx];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 60,
                                height: 60,
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: InkWell(
                                    onTap: () {
                                      controller.add(
                                          Image.asset(sticker, width: 100));
                                    },
                                    child: Image.asset(sticker),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )),
              ),
              SingleChildScrollView(
                child: Row(
                  children: [
                    for (int i = 0; i < Stickers().list().length; i++)
                      _bottomBatItem(i, Stickers().list()[i][0], onPress: () {
                        setState(() {
                          index = i;
                        });
                      })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomBatItem(int idx, String icon,
      {Color? color, required onPress}) {
    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                color: index == idx ? Colors.blue : Colors.transparent,
                height: 2,
                width: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(icon, width: 30),
            ),
          ],
        ),
      ),
    );
  }
}
