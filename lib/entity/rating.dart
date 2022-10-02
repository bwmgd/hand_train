import 'package:flutter/material.dart';

class RatingEntity {
  static RatingEntity perfect = RatingEntity(0, "优", Colors.green);
  static RatingEntity good = RatingEntity(1, "良", Colors.orange);
  static RatingEntity bad = RatingEntity(2, "N", Colors.grey);

  static List<RatingEntity> ratingList = [perfect, good, bad];

  final int id;
  final String name;
  final MaterialColor color;

  RatingEntity(this.id, this.name, this.color);

  static RatingEntity getRatingById(int id) {
    return ratingList[id];
  }

  static int getRatingIdByTime(int trainTime, int totalTime) {
    if (totalTime < 3.0) return 2;
    if (trainTime / totalTime > 0.8) return 0;
    if (trainTime / totalTime > 0.5) return 1;
    return 2;
  }
}
