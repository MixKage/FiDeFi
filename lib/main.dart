import 'dart:io';

import 'package:desktop_window/desktop_window.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

import 'bottom_navig_bar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await testWindowFunctions();
  runApp(const MyApp());
}

Future<void> testWindowFunctions() async {
  await DesktopWindow.setWindowSize(const Size(330, 350));
  await DesktopWindow.setMinWindowSize(const Size(300, 300));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MacosApp(
      title: 'FiDeFi',
      theme: MacosThemeData.light(),
      darkTheme: MacosThemeData.dark(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _enableButton = true;
  String? _selectedDirectory;
  List<FileSystemEntity> files = [];
  List<int> _selectedFiles = [];

  Future<void> _openFolderPicker() async {
    files = [];
    _selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (_selectedDirectory != null) {
      //files = io.Directory("$_selectedDirectory/").listSync();
      await _setFilesFromFolder();
    }
    setState(() {
      _enableButton = true;
    });
  }

  Future<void> _setFilesFromFolder() async {
    if (_selectedDirectory != null) {
      files = [];
      _selectedFiles = [];
      var tmp = Directory("$_selectedDirectory/").listSync();
      List<String> extensions = textController.text.split(',');
      if (extensions.isNotEmpty && extensions[0] != "") {
        for (var element in tmp) {
          //Получаю расширение файла
          var extenFile = element.path.split('.');
          for (var ext in extensions) {
            //Проверяю с входным потоком необходимых расширений
            if (extenFile[extenFile.length - 1] == ext) {
              files.add(element);
              break;
            }
          }
        }
      } else {
        files = tmp;
      }
      for (var i = 0; i < files.length; i++) {
        _selectedFiles.add(i);
      }
      setState(() {});
    }
  }

  // Future<void> _deleteSelectedFiles() async {
  //   for (int index in _selectedFiles) {
  //     files[index].delete();
  //   }
  //   _selectedFiles = [];
  //   files = Directory("$_selectedDirectory/").listSync();
  //   setState(() {
  //     _enableButton = true;
  //   });
  // }

  final textController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    textController.addListener(_setFilesFromFolder);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MacosTheme.brightnessOf(context) == Brightness.dark
          ? MacosColors.underPageBackgroundColor
          : MacosColors.white,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: BottomBar(
            enableButton: _enableButton,
            textController: textController,
            files: files,
            buttonCallback: () async {
              setState(() => _enableButton = false);
              _openFolderPicker();
            },
            deleteCallback: () async {
              for (int index in _selectedFiles) {
                files[index].delete();
              }
              _selectedFiles = [];
              files = [];
              var tmp = Directory("$_selectedDirectory/").listSync();
              List<String> extensions = textController.text.split(',');
              if (extensions.isNotEmpty && extensions[0] != "") {
                for (var element in tmp) {
                  //Получаю расширение файла
                  var extenFile = element.path.split('.');
                  for (var ext in extensions) {
                    //Проверяю с входным потоком необходимых расширений
                    if (extenFile[extenFile.length - 1] == ext) {
                      files.add(element);
                      break;
                    }
                  }
                }
              } else {
                files = tmp;
              }
              setState(() {
                _enableButton = true;
              });
            }),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: files.isEmpty
                    ? Center(
                        child: Text(
                          "File list empty",
                          style: TextStyle(
                            fontWeight: FontWeight.w200,
                            color: MacosTheme.brightnessOf(context) ==
                                    Brightness.dark
                                ? Colors.white38
                                : Colors.black38,
                            fontSize: 30,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: files.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            color: (_selectedFiles.contains(index))
                                ? MacosColors.systemGrayColor.withOpacity(0.2)
                                : Colors.transparent,
                            child: ListTile(
                              onTap: () {
                                if (_selectedFiles.contains(index)) {
                                  setState(() {
                                    _selectedFiles
                                        .removeWhere((val) => val == index);
                                  });
                                } else {
                                  setState(() {
                                    _selectedFiles.add(index);
                                  });
                                }
                              },
                              onLongPress: () {},
                              leading: files[index].toString()[0] == "F"
                                  ? Icon(
                                      Icons.file_copy,
                                      color: MacosTheme.brightnessOf(context) ==
                                              Brightness.dark
                                          ? MacosColors.windowFrameColor
                                          : MacosColors.gridColor,
                                    )
                                  : Icon(
                                      Icons.folder,
                                      color: MacosTheme.brightnessOf(context) ==
                                              Brightness.dark
                                          ? MacosColors.windowFrameColor
                                          : MacosColors.gridColor,
                                    ),
                              title: Text(
                                files[index].toString(),
                                style: TextStyle(
                                    color: MacosTheme.brightnessOf(context) ==
                                            Brightness.dark
                                        ? MacosColors.textColor
                                        : MacosColors.textBackgroundColor),
                              ),
                            ),
                          );
                        }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
