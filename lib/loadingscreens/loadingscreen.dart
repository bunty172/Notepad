import 'package:flutter/material.dart';

class LoadingScreen {
  LoadingScreen({required this.context});

  final BuildContext context;
  late final OverlayEntry overlay;

  void showOverlay() {
    final renederBox = context.findRenderObject() as RenderBox;
    final size = renederBox.size;
    overlay = OverlayEntry(builder: (context) {
      return Material(
        color: Colors.black.withAlpha(150),
        child: Center(
          child: Container(
            constraints: BoxConstraints(
                maxHeight: size.height * 0.2,
                maxWidth: size.width * 0.8,
                minWidth: size.width * 0.5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(children: const [
              SizedBox(
                height: 20,
              ),
              CircularProgressIndicator(),
              SizedBox(
                height: 10,
              ),
              Text("Please wait a moment"),
            ]),
          ),
        ),
      );
    });

    final state = Overlay.of(context);
    state?.insert(overlay);
  }

  void removeOverlay() {
    overlay.remove();
  }
}
