import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:map_of_points/domain/entities/gps_failure.dart';
import 'package:map_of_points/domain/entities/gps_point.dart';

export 'dart:typed_data';

export 'package:dartz/dartz.dart';
export 'package:map_of_points/domain/entities/gps_failure.dart';
export 'package:map_of_points/domain/entities/gps_point.dart';

abstract class IFlightLogRepository {
  Future<Either<List<GpsPoint>, GPSFailure>> parseLog(Uint8List data);
}