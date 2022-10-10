import 'dart:io';

import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({
    required this.textController,
    required this.buttonCallback,
    required this.enableButton,
    required this.files,
    required this.deleteCallback,
    super.key,
  });
  final TextEditingController textController;
  final bool enableButton;
  final List<FileSystemEntity> files;
  final VoidCallback buttonCallback;
  final VoidCallback deleteCallback;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 5),
        Expanded(
          child: MacosTextField(
            controller: textController,
            placeholder: 'Type some extension',
          ),
        ),
        const SizedBox(width: 5),
        PushButton(
            buttonSize: ButtonSize.small,
            onPressed: !enableButton ? null : buttonCallback,
            child: const Text("Select folder")),
        const SizedBox(width: 10),
        PushButton(
            buttonSize: ButtonSize.small,
            onPressed: !enableButton || files.isEmpty
                ? null
                : () async {
                    //enableButton = false;
                    deleteCallback();
                  },
            child: const Text("Delete")),
        const SizedBox(width: 10),
      ],
    );
  }
}
