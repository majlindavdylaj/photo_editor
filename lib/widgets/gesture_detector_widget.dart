import 'package:flutter/material.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

class GestureDetectorWidget extends StatelessWidget {

  Widget? child;

  GestureDetectorWidget({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());
    return MatrixGestureDetector(
      onMatrixUpdate: (m, tm, sm, rm){
        notifier.value = m;
      },
      child: AnimatedBuilder(
        animation: notifier,
        builder: (context, child){
          return Transform(
            transform: notifier.value,
            child: Stack(
              children: [
                Container(
                  color: Colors.transparent,
                ),
                Center(
                  child: Container(
                    child: this.child,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
