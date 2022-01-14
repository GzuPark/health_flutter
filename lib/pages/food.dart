import 'package:flutter/material.dart';
import 'package:health_flutter/data/data.dart';
import 'package:health_flutter/style.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: ListView.builder(
          itemCount: 4,
          itemBuilder: (ctx, idx) {
            if (idx == 0) {
              return Container(
                child: InkWell(
                  child: Container(
                    height: 150,
                    child: Image.asset('assets/img/asian_food.jpg', fit: BoxFit.cover),
                  ),
                  onTap: () {},
                ),
              );
            } else if (idx == 1) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [Text('식사시간'), Text('오후 11:32')],
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
                margin: const EdgeInsets.symmetric(horizontal: 16),
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
                margin: const EdgeInsets.symmetric(horizontal: 16),
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
}
