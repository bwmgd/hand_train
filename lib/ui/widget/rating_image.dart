import 'package:flutter/material.dart';
import 'package:my_flutter_app/entity/rating.dart';

class RatingImage extends StatelessWidget {
  final int _ratingId;

  const RatingImage(this._ratingId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var ratingEntity = RatingEntity.getRatingById(_ratingId);
    return CircleAvatar(
      child: Text(
        ratingEntity.name,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: ratingEntity.color,
    );
  }
}
