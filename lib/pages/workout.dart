import 'package:flutter/material.dart';
import 'package:health_flutter/data/data.dart';
import 'package:health_flutter/data/database.dart';
import 'package:health_flutter/style.dart';

import '../utils.dart';

class WorkoutAddPage extends StatefulWidget {
  final Workout workout;

  const WorkoutAddPage({Key? key, required this.workout}) : super(key: key);

  @override
  _WorkoutAddPageState createState() => _WorkoutAddPageState();
}

class _WorkoutAddPageState extends State<WorkoutAddPage> {
  Workout get workout => widget.workout;
  TextEditingController nameController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController kcalController = TextEditingController();
  TextEditingController distController = TextEditingController();
  TextEditingController memoController = TextEditingController();

  @override
  void initState() {
    memoController.text = workout.memo!;
    timeController.text = workout.time.toString();
    kcalController.text = workout.kcal.toString();
    distController.text = workout.distance.toString();
    nameController.text = workout.name;
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
              workout.memo = memoController.text;
              await db.insertWorkout(workout);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Container(
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (ctx, idx) {
            if (idx == 0) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                width: 70,
                height: 70,
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(color: inactiveBgColor, borderRadius: BorderRadius.circular(15)),
                      child: InkWell(
                        child: Image.asset('assets/img/${workout.type}.png'),
                        onTap: () {
                          setState(() {
                            workout.type++;
                            workout.type = workout.type % 4;
                          });
                        },
                      ),
                    ),
                    Container(width: 16),
                    Expanded(
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: txtColor, width: 0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (idx == 1) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  children: [
                    // time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('운동 시간'),
                        SizedBox(
                          width: 70,
                          child: TextField(
                            controller: timeController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: txtColor, width: 0.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // kcal
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Kcal'),
                        SizedBox(
                          width: 70,
                          child: TextField(
                            controller: kcalController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: txtColor, width: 0.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // distance
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('운동 거리'),
                        SizedBox(
                          width: 70,
                          child: TextField(
                            controller: distController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: txtColor, width: 0.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
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
                      children: const [Text('운동 부위')],
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
                        wPart.length,
                        (_idx) {
                          return InkWell(
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: workout.part == _idx ? mainColor : inactiveBgColor,
                              ),
                              child: Text(
                                wPart[_idx],
                                style: TextStyle(color: workout.part == _idx ? Colors.white : inactiveTxtColor),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                workout.part = _idx;
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
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [Text('운동 강도')],
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
                        wIntense.length,
                        (_idx) {
                          return InkWell(
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: workout.intense == _idx ? mainColor : inactiveBgColor,
                              ),
                              child: Text(
                                wIntense[_idx],
                                style: TextStyle(color: workout.intense == _idx ? Colors.white : inactiveTxtColor),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                workout.intense = _idx;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else if (idx == 4) {
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
}