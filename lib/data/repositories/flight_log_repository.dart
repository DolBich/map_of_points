import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:map_of_points/domain/repositories/i_flight_log_repository.dart';

class FlightLogRepository implements IFlightLogRepository {
  static const int recordLength = 11;

  @override
  Future<Either<List<GpsPoint>, GPSFailure>> parseLog(Uint8List data) async {
    final receivePort = ReceivePort();

    await Isolate.spawn(
      _parseInBackground,
      _IsolateData(data, receivePort.sendPort),
    );

    final json = await receivePort.first as Map<String, dynamic>;
    final Either<List<GpsPoint>, GPSFailure> res;

    final success = json['success'];
    if(success == null) return right(GPSFailure.smthWentWrong());
    if(success) {
      final data = json['json'] as List<Map<String, dynamic>>;
      res = left(data.map(GpsPoint.fromJson).toList());
    } else {
      final data = json['json'] as Map<String, dynamic>;
      res = right(GPSFailure.fromJson(data));
    }

    return res;
  }

  void _parseInBackground(_IsolateData isolateData) async {
    try {
      final points = await _parseFlightLog(isolateData.data);
      final json = points.fold<Map<String, dynamic>>((s) {
        final res = s.map((e) => e.toJson()).toList();
        return {'success': true, 'json': res};
      }, (f) {
        final res = f.toJson;
        return {'success': false, 'json': res};
      });
      isolateData.sendPort.send(json);
    } catch (e) {
      final json = GPSFailure.dataError(e.toString()).toJson;
      isolateData.sendPort.send({'success': false, 'json': json});
    }
  }

  Future<Either<List<GpsPoint>, GPSFailure>> _parseFlightLog(Uint8List data) async {
    if (data.length < recordLength) {
      return right(GPSFailure.dataError('File is too small!'));
    }

    final points = <GpsPoint>[];
    int recordCount = data.length ~/ recordLength;

    for (int i = 0; i < recordCount; i++) {
      try {
        final point = _parseRecord(data, i);
        points.add(point);
      } catch (e) {
        debugPrint('Error parsing record $i: $e');
      }
    }

    return left(points);
  }

  GpsPoint _parseRecord(Uint8List data, int index) {
    final offset = index * recordLength;

    if (offset + recordLength > data.length) {
      throw FormatException('Incomplete record at index $index');
    }

    final gpsFix = data[offset];
    final latitude = _bytesToInt32(data, offset + 1);
    final longitude = _bytesToInt32(data, offset + 5);
    final altitude = _bytesToInt16(data, offset + 9);

    return GpsPoint(
      gpsFix: gpsFix,
      latitude: latitude,
      longitude: longitude,
      altitude: altitude,
      index: index,
    );
  }

  int _bytesToInt32(Uint8List data, int offset) {
    return data[offset] | data[offset + 1] << 8 | data[offset + 2] << 16 | data[offset + 3] << 24;
  }

  int _bytesToInt16(Uint8List data, int offset) {
    final value = data[offset] | data[offset + 1] << 8;
    return value < 32768 ? value : value - 65536;
  }
}

class _IsolateData {
  final Uint8List data;
  final SendPort sendPort;

  _IsolateData(this.data, this.sendPort);
}
