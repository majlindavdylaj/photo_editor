import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lindi/lindi.dart';
import 'package:photo_editor/helper/filters.dart';
import 'package:photo_editor/lindi/image_viewholder.dart';
import 'package:photo_editor/model/filter.dart';
import 'package:screenshot/screenshot.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {

  late Filter currentFilter;
  late List<Filter> filters;

  late ImageViewHolder imageViewHolder;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    filters = Filters().list();
    currentFilter = filters[0];
    imageViewHolder = LindiInjector.get<ImageViewHolder>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: const Text('Filters'),
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
      body: Center(
        child: LindiBuilder(
          viewModel: imageViewHolder,
          builder: (BuildContext context) {
            if (imageViewHolder.currentImage != null) {
              return Screenshot(
                controller: screenshotController,
                child: ColorFiltered(
                  colorFilter: ColorFilter.matrix(currentFilter.matrix),
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
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 120,
        color: Colors.black,
        child: SafeArea(
          child: LindiBuilder(
            viewModel: imageViewHolder,
          builder: (BuildContext context) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              itemBuilder: (BuildContext context, int index){
                Filter filter = filters[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                currentFilter = filter;
                              });
                            },
                            child: ColorFiltered(
                              colorFilter: ColorFilter.matrix(filter.matrix),
                              child: Image.memory(imageViewHolder.currentImage!),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(filter.filterName,
                        style: const TextStyle(
                          color: Colors.white
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          }
          )
        ),
      ),
    );
  }
}
