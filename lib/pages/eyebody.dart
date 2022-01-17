import 'package:flutter/material.dart';
import 'package:health_flutter/data/data.dart';
import 'package:health_flutter/data/database.dart';
import 'package:health_flutter/style.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

class EyeBodyAddPage extends StatefulWidget {
  final EyeBody eyebody;

  const EyeBodyAddPage({Key? key, required this.eyebody}) : super(key: key);

  @override
  _EyeBodyAddPageState createState() => _EyeBodyAddPageState();
}

class _EyeBodyAddPageState extends State<EyeBodyAddPage> {
  EyeBody get eyebody => widget.eyebody;
  TextEditingController memoController = TextEditingController();

  @override
  void initState() {
    memoController.text = eyebody.memo!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        iconTheme: IconThemeData(color: txtColor),
        elevation: 1.0,
        actions: [
          TextButton(
            child: Text('저장', style: TextStyle(color: txtColor)),
            onPressed: () async {
              final db = DatabaseHelper.instance;
              eyebody.memo = memoController.text;
              await db.insertEyeBody(eyebody);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      backgroundColor: bgColor,
      body: Container(
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (ctx, idx) {
            if (idx == 0) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                height: cardSize,
                width: cardSize,
                child: InkWell(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Align(
                      child: eyebody.image!.isEmpty
                          ? Image.asset('assets/img/body.jpg')
                          : AssetThumb(
                              width: cardSize.toInt(),
                              height: cardSize.toInt(),
                              asset: Asset(eyebody.image, 'body.png', 0, 0),
                            ),
                    ),
                  ),
                  onTap: () {
                    selectImage();
                  },
                ),
              );
            } else if (idx == 1) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('메모', style: mTextStyle.apply(color: txtColor)),
                    Container(height: 12),
                    TextField(
                      maxLines: 10,
                      minLines: 10,
                      keyboardType: TextInputType.multiline,
                      controller: memoController,
                      style: mTextStyle.apply(color: txtColor),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(width: 0.5, color: txtColor),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Future<void> selectImage() async {
    final _img = await MultiImagePicker.pickImages(maxImages: 1, enableCamera: true);

    if (_img.isEmpty) {
      return;
    }

    setState(() {
      eyebody.image = _img.first.identifier;
    });
  }
}

class MainEyeBodyCard extends StatelessWidget {
  final EyeBody eyeBody;

  const MainEyeBodyCard({Key? key, required this.eyeBody}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: 1,
          child: Stack(
            children: [
              Positioned.fill(
                child: AssetThumb(
                  width: cardSize.toInt(),
                  height: cardSize.toInt(),
                  asset: Asset(eyeBody.image, 'food.png', 0, 0),
                ),
              ),
              Positioned.fill(child: Container(color: Colors.black12)),
            ],
          ),
        ),
      ),
    );
  }
}
