class Food {
  int? id;
  int date;
  int time;
  int type;
  int meal;
  int? kcal;
  String? memo;
  String? image;

  Food({
    this.id,
    required this.date,
    required this.time,
    required this.type,
    required this.meal,
    this.kcal,
    this.image,
    this.memo,
  });

  factory Food.fromDB(Map<String, dynamic> data) {
    return Food(
      id: data['id'],
      date: data['date'],
      time: data['time'],
      type: data['type'],
      meal: data['meal'],
      kcal: data['kcal'],
      image: data['image'],
      memo: data['memo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'time': time,
      'type': type,
      'meal': meal,
      'kcal': kcal,
      'image': image,
      'memo': memo,
    };
  }
}

class Workout {
  int? id;
  int date;
  int time;
  int type;
  int kcal;
  int distance;
  int intense; // 강도
  int part;
  String name;
  String? memo;

  Workout({
    this.id,
    required this.date,
    required this.time,
    required this.type,
    required this.kcal,
    required this.distance,
    required this.intense,
    required this.part,
    required this.name,
    this.memo,
  });

  factory Workout.fromDB(Map<String, dynamic> data) {
    return Workout(
      id: data['id'],
      date: data['date'],
      time: data['time'],
      type: data['type'],
      kcal: data['kcal'],
      distance: data['distance'],
      intense: data['intense'],
      part: data['part'],
      name: data['name'],
      memo: data['memo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'time': time,
      'type': type,
      'kcal': kcal,
      'distance': distance,
      'intense': intense,
      'part': part,
      'name': name,
      'memo': memo,
    };
  }
}

class EyeBody {
  int? id;
  int date;
  String? image;
  String? memo;

  EyeBody({
    this.id,
    required this.date,
    this.image,
    this.memo,
  });

  factory EyeBody.fromDB(Map<String, dynamic> data) {
    return EyeBody(
      id: data['id'],
      date: data['date'],
      image: data['image'],
      memo: data['memo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'image': image,
      'memo': memo,
    };
  }
}

class Weight {
  int date;
  int? weight;
  int? fat;
  int? muscle;

  Weight({
    required this.date,
    this.weight,
    this.fat,
    this.muscle,
  });

  factory Weight.fromDB(Map<String, dynamic> data) {
    return Weight(
      date: data['date'],
      weight: data['weight'],
      fat: data['fat'],
      muscle: data['muscle'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'weight': weight,
      'fat': fat,
      'muscle': muscle,
    };
  }
}
