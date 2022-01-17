import 'package:flutter/material.dart';
import 'package:health_flutter/data/database.dart';
import 'package:health_flutter/pages/eyebody.dart';
import 'package:health_flutter/pages/food.dart';
import 'package:health_flutter/pages/workout.dart';
import 'package:health_flutter/style.dart';
import 'package:health_flutter/utils.dart';
import 'package:table_calendar/table_calendar.dart';

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

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;

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
                                date: Utils.getFormatTime(dateTime),
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
                                  date: Utils.getFormatTime(dateTime),
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
                                date: Utils.getFormatTime(dateTime),
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
      return getHomeWidget();
    } else if (currentIndex == 1) {
      return getHistoryWidget();
    }

    return Container();
  }

  Widget getHomeWidget() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: cardSize,
            child: foods.isEmpty
                ? Container(
                    padding: const EdgeInsets.all(8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset('assets/img/asian_food.jpg'),
                    ),
                  )
                : ListView.builder(
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
            child: workouts.isEmpty
                ? Container(
                    padding: const EdgeInsets.all(8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset('assets/img/body.jpg'),
                    ),
                  )
                : ListView.builder(
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
                      padding: const EdgeInsets.all(8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset('assets/img/3.png'),
                      ),
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

  Widget getHistoryWidget() {
    return Container(
      child: ListView.builder(
        itemCount: 2,
        itemBuilder: (ctx, idx) {
          if (idx == 0) {
            return Container(
              child: TableCalendar(
                // https://dipeshgoswami.medium.com/table-calendar-3-0-0-null-safety-818ba8d4c45e
                // reference: Flutter table_calendar >= 3.0.0
                firstDay: DateTime(2021, 1, 1),
                lastDay: DateTime(2030, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                availableCalendarFormats: const {CalendarFormat.twoWeeks: ''},
                headerStyle: const HeaderStyle(titleCentered: true),
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  }

                  dateTime = selectedDay;
                  getHistories();
                },
              ),
            );
          } else if (idx == 1) {
            return getHomeWidget();
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
