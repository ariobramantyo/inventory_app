import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class FullImageScreen extends StatelessWidget {
  const FullImageScreen({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close)),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () async {
                try {
                  final imageName = getFileName(imageUrl);
                  Reference reference = FirebaseStorage.instance.ref(imageName);

                  final dirPath = await getTemporaryDirectory();
                  final path = '${dirPath.path}/${reference.name}';

                  await Dio().download(imageUrl, path);

                  await GallerySaver.saveImage(path, toDcim: true);

                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Successfully download image')));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Download image failed')));
                }
              },
              icon: Icon(Icons.download))
        ],
      ),
      body: Center(
          child: InteractiveViewer(
              maxScale: 3,
              child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                  )))),
    );
  }

  String getFileName(String url) {
    RegExp regExp = RegExp(r'.+(\/|%2F)(.+)\?.+');
    var matches = regExp.allMatches(url);

    var match = matches.elementAt(0);
    debugPrint("${Uri.decodeFull(match.group(2)!)}");
    return Uri.decodeFull(match.group(2)!);
  }
}
