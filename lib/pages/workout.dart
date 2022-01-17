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
            child: Text('저장', style: mTextStyle.apply(color: txtColor)),
            onPressed: () async {
              final db = DatabaseHelper.instance;
              workout.memo = memoController.text;
              workout.time = timeController.text.isEmpty ? 0 : int.parse(timeController.text);
              workout.kcal = kcalController.text.isEmpty ? 0 : int.parse(kcalController.text);
              workout.distance = distController.text.isEmpty ? 0 : int.parse(distController.text);
              workout.name = nameController.text;
              await db.insertWorkout(workout);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      backgroundColor: bgColor,
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (ctx, idx) {
          if (idx == 0) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      style: mTextStyle.apply(color: txtColor),
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
                      Text('운동 시간', style: mTextStyle.apply(color: txtColor)),
                      SizedBox(
                        width: 70,
                        height: 40,
                        child: TextField(
                          controller: timeController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: mTextStyle.apply(color: txtColor),
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
                      Text('Kcal', style: mTextStyle.apply(color: txtColor)),
                      SizedBox(
                        width: 70,
                        height: 40,
                        child: TextField(
                          controller: kcalController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: mTextStyle.apply(color: txtColor),
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
                      Text('운동 거리', style: mTextStyle.apply(color: txtColor)),
                      SizedBox(
                        width: 70,
                        height: 40,
                        child: TextField(
                          controller: distController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: mTextStyle.apply(color: txtColor),
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
                    children: [Text('운동 부위', style: mTextStyle.apply(color: txtColor))],
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
                    children: [Text('운동 강도', style: mTextStyle.apply(color: txtColor))],
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
                  Text('메모', style: mTextStyle.apply(color: txtColor)),
                  Container(height: 12),
                  TextField(
                    maxLines: 6,
                    minLines: 6,
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
    );
  }
}

class MainWorkoutCard extends StatelessWidget {
  final Workout workout;

  const MainWorkoutCard({Key? key, required this.workout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: bgColor,
            boxShadow: const [BoxShadow(blurRadius: 4, spreadRadius: 4, color: Colors.black12)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(color: inactiveBgColor, borderRadius: BorderRadius.circular(15)),
                    child: Image.asset('assets/img/${workout.type}.png'),
                  ),
                  Expanded(
                    child: Text(
                      '${Utils.makeTwoDigit(workout.time ~/ 60)}:${Utils.makeTwoDigit(workout.time % 60)}',
                      textAlign: TextAlign.end,
                      style: mTextStyle.apply(color: txtColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(workout.name, style: mTextStyle.apply(color: txtColor)),
              ),
              Text(workout.kcal == 0 ? '' : '${workout.kcal} kcal', style: sTextStyle.apply(color: txtColor)),
              Text(workout.distance == 0 ? '' : '${workout.distance} km', style: sTextStyle.apply(color: txtColor)),
            ],
          ),
        ),
      ),
    );
  }
}
