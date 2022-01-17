import 'package:flutter/material.dart';
import 'package:health_flutter/data/database.dart';
import 'package:health_flutter/pages/eyebody.dart';
import 'package:health_flutter/pages/food.dart';
import 'package:health_flutter/pages/workout.dart';
import 'package:health_flutter/style.dart';
import 'package:health_flutter/utils.dart';

import 'data/data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final dbHelper = DatabaseHelper.instance;

  int currentIndex = 0;
  DateTime dateTime = DateTime.now();

  List<Food> foods = [];
  List<Workout> workouts = [];
  List<EyeBody> eyeBodies = [];
  List<Weight> weight = [];

  void getHistories() async {
    int _d = Utils.getFormatTime(dateTime);

    foods = await dbHelper.queryFoodByDate(_d);
    workouts = await dbHelper.queryWorkoutByDate(_d);
    eyeBodies = await dbHelper.queryEyeBodyByDate(_d);
    weight = await dbHelper.queryWeightByDate(_d);

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getHistories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: getPage(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: bgColor,
            builder: (ctx) {
              return SizedBox(
                height: 250,
                child: Column(
                  children: [
                    TextButton(
                      child: const Text('식단'),
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => FoodAddPage(
                              food: Food(
                                date: Utils.getFormatTime(DateTime.now()),
                                time: 1130,
                                type: 0,
                                meal: 0,
                                kcal: 0,
                                image: '',
                                memo: '',
                              ),
                            ),
                          ),
                        );

                        getHistories();
                      },
                    ),
                    TextButton(
                        child: const Text('운동'),
                        onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => WorkoutAddPage(
                                workout: Workout(
                                  date: Utils.getFormatTime(DateTime.now()),
                                  time: 60,
                                  type: 0,
                                  kcal: 0,
                                  distance: 0,
                                  intense: 0,
                                  part: 0,
                                  name: '',
                                  memo: '',
                                ),
                              ),
                            ),
                          );

                          getHistories();
                        }),
                    TextButton(child: const Text('몸무게'), onPressed: () {}),
                    TextButton(
                      child: const Text('눈바디'),
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => EyeBodyAddPage(
                              eyebody: EyeBody(
                                date: Utils.getFormatTime(DateTime.now()),
                                image: '',
                                memo: '',
                              ),
                            ),
                          ),
                        );

                        getHistories();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '오늘'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: '기록'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: '몸무게'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: '통계'),
        ],
        currentIndex: currentIndex,
        onTap: (idx) {
          setState(() {
            currentIndex = idx;
          });
        },
      ),
    );
  }

  Widget getPage() {
    if (currentIndex == 0) {
      return getHomeWidget(DateTime.now());
    }

    return Container();
  }

  Widget getHomeWidget(DateTime date) {
    return Container(
      child: Column(
        children: [
          Container(
            height: cardSize,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: foods.length,
              itemBuilder: (BuildContext ctx, int idx) {
                return Container(
                  height: cardSize,
                  width: cardSize,
                  child: MainFoodCard(food: foods[idx]),
                );
              },
            ),
          ),
          Container(
            height: cardSize,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: workouts.length,
              itemBuilder: (BuildContext ctx, int idx) {
                return Container(
                  height: cardSize,
                  width: cardSize,
                  child: MainWorkoutCard(workout: workouts[idx]),
                );
              },
            ),
          ),
          Container(
            height: cardSize,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              itemBuilder: (BuildContext ctx, int idx) {
                if (idx == 0) {
                  return Container();
                } else {
                  if (eyeBodies.isEmpty) {
                    return Container(
                      height: cardSize,
                      width: cardSize,
                      color: mainColor,
                    );
                  }
                  return Container(
                    height: cardSize,
                    width: cardSize,
                    child: MainEyeBodyCard(eyeBody: eyeBodies[0]),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
