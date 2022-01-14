class Food {
  int id;
  int date;
  int time;
  int type;
  int? kcal;
  String? memo;
  String? image;

  Food({
    required this.id,
    required this.date,
    required this.time,
    required this.type,
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
      'kcal': kcal,
      'image': image,
      'memo': memo,
    };
  }
}

class Workout {
  int id;
  int date;
  int time;
  int kcal;
  int intense; // 강도
  int part;
  String name;
  String? memo;

  Workout({
    required this.id,
    required this.date,
    required this.time,
    required this.kcal,
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
      kcal: data['kcal'],
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
      'kcal': kcal,
      'intense': intense,
      'part': part,
      'name': name,
      'memo': memo,
    };
  }
}

class EyeBody {
  int id;
  int date;
  String? image;
  String? memo;

  EyeBody({
    required this.id,
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
  int weight;
  int? fat;
  int? muscle;

  Weight({
    required this.date,
    required this.weight,
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
