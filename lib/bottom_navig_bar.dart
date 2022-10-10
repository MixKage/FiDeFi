import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({
    required this.textController,
    required this.buttonCallback,
    required this.enableButton,
    super.key,
  });
  final TextEditingController textController;
  final bool enableButton;
  final VoidCallback buttonCallback;

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
            onPressed: !_enableButton || files.isEmpty
                ? null
                : () async {
                    _enableButton = false;
                    _deleteSelectedFiles();
                  },
            child: const Text("Delete")),
        const SizedBox(width: 10),
      ],
    );
  }
}
