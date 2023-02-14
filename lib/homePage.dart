import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Dio dio = Dio();
  double progress = 0.0;
  bool isLoadingVideo = false;
  File? imageFile;
  String? path_2;

//---------------------------startDownloading-----------------------------------
  Future<File?> startDownloading() async {
    debugPrint("The download is Start");
    setState(() {
      isLoadingVideo = true;
    });

    const String url =
        'https://images.unsplash.com/photo-1474511320723-9a56873867b5?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1172&q=80';
    const String fileName = "fox.jpeg";
    // final appStorage = await getApplicationDocumentsDirectory();

    // String path = await _getFilePath(fileName);
    debugPrint("This is the Path $path_2");

    final response = await dio.download(
      url,
      "${path_2}/$fileName",
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
        receiveTimeout: 0,
      ),
      onReceiveProgress: (recivedBytes, totalBytes) {
        setState(() {
          progress = recivedBytes / totalBytes;
        });

        debugPrint("This is th Progress $progress");
      },
      // deleteOnError: true,
    );

    setState(() {
      isLoadingVideo = false;
      imageFile = File("${path_2}/$fileName");
    });
    // final raf = imageFile?.openSync(mode: FileMode.write);
    // raf?.writeFromSync(response);
    // await raf?.close();
    OpenFile.open(imageFile?.path);
    // return imageFile;
  }

  //-------------------------------------------------------

  Future initPatForm() async{
    Future.delayed(Duration(seconds: 3), (){ _setPath(); });
    // _setPath();
  }

  void _setPath() async {
    Directory? _path = await getExternalStorageDirectory();
    String newPath = "";
    List<String> paths = _path!.path.split("/");
    for (int x = 1; x < paths.length; x++) {
      String folder = paths[x];
      if (folder != "Android") {
        newPath += "/$folder";
      } else {
        break;
      }
    }

    newPath = "$newPath/Insta Downloads";
    final savedDir = Directory(newPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();

    }

    path_2 = savedDir.path;

  }

  //-------------------------openFile--------------------------------------

  // Future<File?> openFile(File file) async {
  //   final raf = file.openSync(mode: FileMode.write);
  //   raf.writeFromSync(response.data);
  //   await raf.close();
  // }

//---------------------------grtFilePath----------------------------------------
  Future<String> _getFilePath(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    return "${dir.path}/$filename";
  }

  @override
  void initState() {
    // TODO: implement initState
    // _setPath();
    initPatForm();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Download File"),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.grey,
            child: ListTile(
              dense: true,
              // contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 16.0),

              visualDensity: VisualDensity(vertical: 4),
              title: const Text("Download Image"),
              subtitle: Text((progress * 100).toInt().toString()),
              trailing: IconButton(
                  onPressed: () {},
                  icon: isLoadingVideo == false
                      ? IconButton(
                          onPressed: startDownloading,
                          icon: const Icon(Icons.download_rounded))
                      : CircularProgressIndicator.adaptive()),

            ),
          )
        ],
      ),

    );
  }
}
