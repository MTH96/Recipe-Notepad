import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meals/screens/add_recipe_screen.dart';
import 'package:provider/provider.dart';

import '../providers/settings.dart';

enum ImagePickingSource { camera, gallery, url }

class ImageHandler extends StatefulWidget {
  // final Map<String, String> langMap;
  // final bool isEng;
  final String initVal;
final double imageWidth;
  final void Function(String) onSaveImageUrl;
  final void Function(File) onSaveImageFile;
  const ImageHandler(this.initVal, this.onSaveImageUrl, this.onSaveImageFile,this.imageWidth);

  @override
  _ImageHandlerState createState() => _ImageHandlerState();
}

class _ImageHandlerState extends State<ImageHandler> {
  Map<String, String> langMap;
  bool isEng;

  File image;
  String imageUrl;
  final textController = TextEditingController();
  final picker = ImagePicker();

  Future getImage(BuildContext ctx) async {
    ImagePickingSource pickerSource = await showModalBottomSheet(
      context: ctx,
      builder: (ctx) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop(ImagePickingSource.camera);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [Icon(Icons.camera), Text(langMap['Take Pic'])],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop(ImagePickingSource.gallery);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [Icon(Icons.photo_library), Text(langMap['Pic Image'])],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop(ImagePickingSource.url);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [Icon(Icons.link), Text(langMap['enter url'])],
            ),
          )
        ],
      ),
    );
    PickedFile pickedFile;
    switch (pickerSource) {
      case ImagePickingSource.camera:
        pickedFile = await picker.getImage(
            source: ImageSource.camera, imageQuality: 75, maxWidth: widget.imageWidth);
        setState(() {
          if (pickedFile != null) {
            image = File(pickedFile.path);
          }
        });
        widget.onSaveImageFile(image);
        break;

      case ImagePickingSource.gallery:
        pickedFile = await picker.getImage(
            source: ImageSource.gallery, imageQuality: 75, maxWidth: widget.imageWidth);
        setState(() {
          if (pickedFile != null) {
            image = File(pickedFile.path);
          } 
        });
        widget.onSaveImageFile(image);
        break;

      case ImagePickingSource.url:
        await showModalBottomSheet(
            context: ctx,
            builder: (ctx) => Container(
                  alignment: Alignment.topCenter,
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(labelText: langMap['Image Url']),
                    onChanged: (value) {
                      setState(() {});
                    },
                    textInputAction: TextInputAction.done,
                    onSubmitted: (value) {
                      widget.onSaveImageUrl(value);
                      Navigator.of(ctx).pop();
                    },
                  ),
                ));

        break;
      default:
    }
    FocusScope.of(context).unfocus();
    // onSaveImageUrl(String imageUrl) ;
  }

  @override
  void initState() {
    textController.text = widget.initVal;
    final lang = Provider.of<LanguageSettings>(context,listen:false);
    isEng = lang.isEng;
    langMap = lang.getWords(AddMealScreen.routeName);

    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => getImage(context),
              icon: Icon(Icons.photo),
              label: Text(
                langMap['take pic'],
              ),
            ),
          ),
          Container(
            height: 150,
            width: 150,
            margin: const EdgeInsets.fromLTRB(8, 0, 0, 0),
            decoration: BoxDecoration(
                border: Border.all(
              color: Colors.grey,
            )),
            alignment: Alignment.center,
            child: (textController.text.isEmpty && image == null)
                ? Text(
                    langMap['add photo Link'],
                    textAlign: TextAlign.center,
                  )
                : image != null
                    ? Image.file(
                        image,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        textController.text,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (a1, a2, a3) {
                          return Text('😢\n${langMap['error']}',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.orange));
                        },
                      ),
          )
        ],
      ),
    );
  }
}
