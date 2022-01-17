import 'package:fl_chart/fl_chart.dart';
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

  List<Food> allFoods = [];
  List<Workout> allWorkouts = [];
  List<EyeBody> allEyeBodies = [];
  List<Weight> allWeights = [];

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  void getHistories() async {
    int _d = Utils.getFormatTime(dateTime);

    foods = await dbHelper.queryFoodByDate(_d);
    workouts = await dbHelper.queryWorkoutByDate(_d);
    eyeBodies = await dbHelper.queryEyeBodyByDate(_d);
    weight = await dbHelper.queryWeightByDate(_d);

    allFoods = await dbHelper.queryAllFood();
    allWorkouts = await dbHelper.queryAllWorkout();
    allEyeBodies = await dbHelper.queryAllEyeBody();
    allWeights = await dbHelper.queryAllWeight();

    if (weight.isNotEmpty) {
      final w = weight.first;
      weightController.text = w.weight.toString();
      fatController.text = w.fat.toString();
      muscleController.text = w.muscle.toString();
    } else {
      weightController.text = '';
      fatController.text = '';
      muscleController.text = '';
    }

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
      appBar: AppBar(elevation: 0),
      body: getPage(),
      floatingActionButton: ![0, 1].contains(currentIndex)
          ? Container()
          : FloatingActionButton(
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
    } else if (currentIndex == 2) {
      return getWeightWidget();
    } else if (currentIndex == 3) {
      return getStatsWidget();
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
                  if (weight.isEmpty) {
                    return Container();
                  } else {
                    final w = weight.first;

                    return Container(
                      height: cardSize,
                      width: cardSize,
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [BoxShadow(spreadRadius: 4, blurRadius: 4, color: Colors.black12)]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${w.weight} kg', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    );
                  }
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
            CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;

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
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(color: mainColor, shape: BoxShape.circle),
                  todayDecoration: BoxDecoration(color: subColor, shape: BoxShape.circle),
                ),
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

  TextEditingController weightController = TextEditingController();
  TextEditingController fatController = TextEditingController();
  TextEditingController muscleController = TextEditingController();
  int chartIndex = 0;

  Widget getWeightWidget() {
    return Container(
      child: ListView.builder(
        itemCount: 3,
        itemBuilder: (ctx, idx) {
          if (idx == 0) {
            CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;

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
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(color: mainColor, shape: BoxShape.circle),
                  todayDecoration: BoxDecoration(color: subColor, shape: BoxShape.circle),
                ),
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
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  // date & save button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${dateTime.month}월 ${dateTime.day}일',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: mainColor,
                          ),
                          child: const Text('저장'),
                        ),
                        onTap: () async {
                          Weight w;
                          if (weight.isEmpty) {
                            w = Weight(date: Utils.getFormatTime(dateTime));
                          } else {
                            w = weight.first;
                          }

                          w.weight = int.tryParse(weightController.text) ?? 0;
                          w.fat = int.tryParse(fatController.text) ?? 0;
                          w.muscle = int.tryParse(muscleController.text) ?? 0;

                          await dbHelper.insertWeight(w);
                          getHistories();
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // TextField - weight, muscle, fat
                  Row(
                    children: [
                      // weight
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('몸무게'),
                            TextField(
                              controller: weightController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: txtColor, width: 0.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      // muscle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('근육량'),
                            TextField(
                              controller: muscleController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: txtColor, width: 0.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      //fat
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('지방'),
                            TextField(
                              controller: fatController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: txtColor, width: 0.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else if (idx == 2) {
            List<FlSpot> spots = [];

            for (final w in allWeights) {
              if (chartIndex == 0) {
                spots.add(FlSpot(w.date.toDouble(), w.weight!.toDouble()));
              } else if (chartIndex == 1) {
                spots.add(FlSpot(w.date.toDouble(), w.muscle!.toDouble()));
              } else {
                spots.add(FlSpot(w.date.toDouble(), w.fat!.toDouble()));
              }
            }

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      // weight
                      InkWell(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: chartIndex == 0 ? mainColor : inactiveBgColor,
                          ),
                          child: Text(
                            '몸무게',
                            style: TextStyle(color: chartIndex == 0 ? Colors.white : inactiveTxtColor),
                          ),
                        ),
                        onTap: () async {
                          setState(() {
                            chartIndex = 0;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      // muscle
                      InkWell(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: chartIndex == 1 ? mainColor : inactiveBgColor,
                          ),
                          child: Text(
                            '근육량',
                            style: TextStyle(color: chartIndex == 1 ? Colors.white : inactiveTxtColor),
                          ),
                        ),
                        onTap: () async {
                          setState(() {
                            chartIndex = 1;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      // fat
                      InkWell(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: chartIndex == 2 ? mainColor : inactiveBgColor,
                          ),
                          child: Text(
                            '지방',
                            style: TextStyle(color: chartIndex == 2 ? Colors.white : inactiveTxtColor),
                          ),
                        ),
                        onTap: () async {
                          setState(() {
                            chartIndex = 2;
                          });
                        },
                      ),
                    ],
                  ),
                  // chart
                  Container(
                    height: 250,
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [BoxShadow(blurRadius: 6, spreadRadius: 2, color: Colors.black12)],
                    ),
                    child: LineChart(
                      LineChartData(
                        titlesData: FlTitlesData(
                          leftTitles: SideTitles(showTitles: false),
                          rightTitles: SideTitles(showTitles: false),
                          topTitles: SideTitles(showTitles: false),
                          bottomTitles: SideTitles(
                            interval: 1,
                            showTitles: true,
                            getTitles: (value) {
                              DateTime date = Utils.stringToDateTime(value.toInt().toString());
                              return '${date.day}일';
                            },
                          ),
                        ),
                        gridData: FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            showOnTopOfTheChartBoxArea: false,
                            getTooltipItems: (spots) {
                              return [LineTooltipItem('${spots.first.y}kg', TextStyle(color: mainColor))];
                            },
                          ),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            colors: [mainColor],
                            spots: spots,
                          ),
                        ],
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

  Widget getStatsWidget() {
    return Container(
      child: ListView.builder(
        itemCount: 4,
        itemBuilder: (ctx, idx) {
          if (idx == 0) {
            List<FlSpot> spots = [];

            for (final w in allWorkouts) {
              if (chartIndex == 0) {
                spots.add(FlSpot(w.date.toDouble(), w.time.toDouble()));
              } else if (chartIndex == 1) {
                spots.add(FlSpot(w.date.toDouble(), w.kcal.toDouble()));
              } else {
                spots.add(FlSpot(w.date.toDouble(), w.distance.toDouble()));
              }
            }

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      // weight
                      InkWell(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: chartIndex == 0 ? mainColor : inactiveBgColor,
                          ),
                          child: Text(
                            '운동 시간',
                            style: TextStyle(color: chartIndex == 0 ? Colors.white : inactiveTxtColor),
                          ),
                        ),
                        onTap: () async {
                          setState(() {
                            chartIndex = 0;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      // muscle
                      InkWell(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: chartIndex == 1 ? mainColor : inactiveBgColor,
                          ),
                          child: Text(
                            'Kcal',
                            style: TextStyle(color: chartIndex == 1 ? Colors.white : inactiveTxtColor),
                          ),
                        ),
                        onTap: () async {
                          setState(() {
                            chartIndex = 1;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      // fat
                      InkWell(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: chartIndex == 2 ? mainColor : inactiveBgColor,
                          ),
                          child: Text(
                            '거리',
                            style: TextStyle(color: chartIndex == 2 ? Colors.white : inactiveTxtColor),
                          ),
                        ),
                        onTap: () async {
                          setState(() {
                            chartIndex = 2;
                          });
                        },
                      ),
                    ],
                  ),
                  // chart
                  Container(
                    height: 200,
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [BoxShadow(blurRadius: 6, spreadRadius: 2, color: Colors.black12)],
                    ),
                    child: LineChart(
                      LineChartData(
                        titlesData: FlTitlesData(
                          leftTitles: SideTitles(showTitles: false),
                          rightTitles: SideTitles(showTitles: false),
                          topTitles: SideTitles(showTitles: false),
                          bottomTitles: SideTitles(
                            interval: 1,
                            showTitles: true,
                            getTitles: (value) {
                              DateTime date = Utils.stringToDateTime(value.toInt().toString());
                              return '${date.day}일';
                            },
                          ),
                        ),
                        gridData: FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            showOnTopOfTheChartBoxArea: false,
                            getTooltipItems: (spots) {
                              return [LineTooltipItem('${spots.first.y}', TextStyle(color: mainColor))];
                            },
                          ),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            colors: [mainColor],
                            spots: spots,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (idx == 1) {
            return Container(
              height: cardSize,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: allFoods.length,
                itemBuilder: (BuildContext ctx, int _idx) {
                  return Container(
                    height: cardSize,
                    width: cardSize,
                    child: MainFoodCard(food: allFoods[_idx]),
                  );
                },
              ),
            );
          } else if (idx == 2) {
            return Container(
              height: cardSize,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: allWorkouts.length,
                itemBuilder: (BuildContext ctx, int _idx) {
                  return Container(
                    height: cardSize,
                    width: cardSize,
                    child: MainWorkoutCard(workout: allWorkouts[_idx]),
                  );
                },
              ),
            );
          } else if (idx == 3) {
            return Container(
              height: cardSize,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: allEyeBodies.length,
                itemBuilder: (BuildContext ctx, int _idx) {
                  return Container(
                    height: cardSize,
                    width: cardSize,
                    child: MainEyeBodyCard(eyeBody: allEyeBodies[_idx]),
                  );
                },
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
