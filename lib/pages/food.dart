import 'package:flutter/material.dart';
import 'package:health_flutter/data/data.dart';
import 'package:health_flutter/data/database.dart';
import 'package:health_flutter/style.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

import '../utils.dart';

class FoodAddPage extends StatefulWidget {
  final Food food;

  const FoodAddPage({Key? key, required this.food}) : super(key: key);

  @override
  _FoodAddPageState createState() => _FoodAddPageState();
}

class _FoodAddPageState extends State<FoodAddPage> {
  Food get food => widget.food;
  TextEditingController memoController = TextEditingController();

  @override
  void initState() {
    memoController.text = food.memo!;
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
              food.memo = memoController.text;
              await db.insertFood(food);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Container(
        child: ListView.builder(
          itemCount: 4,
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
                      child: food.image!.isEmpty
                          ? Image.asset('assets/img/asian_food.jpg')
                          : AssetThumb(
                              width: cardSize.toInt(),
                              height: cardSize.toInt(),
                              asset: Asset(food.image, 'food.png', 0, 0),
                            ),
                    ),
                  ),
                  onTap: () {
                    selectImage();
                  },
                ),
              );
            } else if (idx == 1) {
              String _t = food.time.toString();
              String _h = _t.substring(0, _t.length - 2);
              String _m = _t.substring(_t.length - 2);
              TimeOfDay time = TimeOfDay(hour: int.parse(_h), minute: int.parse(_m));

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('식사시간'),
                        InkWell(
                          child: Text(
                            '${time.hour > 11 ? '오후' : '오전'} '
                            '${Utils.makeTwoDigit(time.hour % 12)}:'
                            '${Utils.makeTwoDigit(time.minute)}',
                          ),
                          onTap: () async {
                            TimeOfDay? _time = await showTimePicker(context: context, initialTime: TimeOfDay.now());

                            setState(() {
                              food.time = int.parse('${_time?.hour}${Utils.makeTwoDigit(_time?.minute)}');
                            });

                            if (_time == null) {
                              return;
                            }
                          },
                        )
                      ],
                    ),
                    Container(height: 12),
                    GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 4, // grid row 에 최대로 보여줄 수 있는 개수, 지정 숫자를 넘어갈 경우 추가 row 에 표시
                      childAspectRatio: 2.5,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      children: List.generate(
                        mealTime.length,
                        (_idx) {
                          return InkWell(
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: food.meal == _idx ? mainColor : inactiveBgColor,
                              ),
                              child: Text(
                                mealTime[_idx],
                                style: TextStyle(color: food.meal == _idx ? Colors.white : inactiveTxtColor),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                food.meal = _idx;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else if (idx == 2) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [Text('식단 평가')],
                    ),
                    Container(height: 12),
                    GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 4, // grid row 에 최대로 보여줄 수 있는 개수, 지정 숫자를 넘어갈 경우 추가 row 에 표시
                      childAspectRatio: 2.5,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      children: List.generate(
                        mealType.length,
                        (_idx) {
                          return InkWell(
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: food.type == _idx ? mainColor : inactiveBgColor,
                              ),
                              child: Text(
                                mealType[_idx],
                                style: TextStyle(color: food.type == _idx ? Colors.white : inactiveTxtColor),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                food.type = _idx;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else if (idx == 3) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('메모'),
                    Container(height: 12),
                    TextField(
                      maxLines: 10,
                      minLines: 10,
                      keyboardType: TextInputType.multiline,
                      controller: memoController,
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
      food.image = _img.first.identifier;
    });
  }
}

class MainFoodCard extends StatelessWidget {
  final Food food;

  const MainFoodCard({Key? key, required this.food}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _t = food.time.toString();
    String _h = _t.substring(0, _t.length - 2);
    String _m = _t.substring(_t.length - 2);
    TimeOfDay time = TimeOfDay(hour: int.parse(_h), minute: int.parse(_m));

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
                  asset: Asset(food.image, 'food.png', 0, 0),
                ),
              ),
              Positioned.fill(child: Container(color: Colors.black38)),
              Positioned.fill(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    '${time.hour > 11 ? '오후' : '오전'} '
                    '${Utils.makeTwoDigit(time.hour % 12)}:'
                    '${Utils.makeTwoDigit(time.minute)}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Positioned(
                right: 6,
                bottom: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: mainColor, borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    mealTime[food.meal],
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
