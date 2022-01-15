import 'package:flutter/material.dart';
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
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;

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
                        }),
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
            height: cardSize + 20,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (BuildContext ctx, int idx) {
                return Container(
                  height: cardSize,
                  width: cardSize,
                  color: mainColor,
                );
              },
            ),
          ),
          Container(
            height: cardSize + 20,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (BuildContext ctx, int idx) {
                return Container(
                  height: cardSize,
                  width: cardSize,
                  color: mainColor,
                );
              },
            ),
          ),
          Container(
            height: cardSize + 20,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              itemBuilder: (BuildContext ctx, int idx) {
                if (idx == 0) {
                  return Container();
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
