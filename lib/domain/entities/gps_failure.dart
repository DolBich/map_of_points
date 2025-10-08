import 'package:map_of_points/data/extensions/enum_extension.dart';

sealed class GPSFailure {
  final String? message;

  const GPSFailure([this.message]);

  _ErrorType get _type;

  String get toText;

  Map<String, dynamic> get toJson => {'type': _type.name,'message': message};

  factory GPSFailure.fromJson(Map<String, dynamic> json) {
    final message = json['message'];
    final type = _ErrorType.values.byNameOrNull(json['type']);
    if(type == null) return GPSFailure.smthWentWrong();
    switch(type) {
      case _ErrorType.data:
        return GPSFailure.dataError(message);
      case _ErrorType.smth:
        return GPSFailure.smthWentWrong();
    }
  }

  const factory GPSFailure.dataError([String? message]) = _DataError;

  const factory GPSFailure.smthWentWrong() = _SmthWentWrong;
}

class _DataError extends GPSFailure {
  const _DataError([super.message]);

  @override
  _ErrorType get _type => _ErrorType.data;

  @override
  String get  toText => 'Uploaded data has issues that leaded to error: $message';
}

class _SmthWentWrong extends GPSFailure {
  const _SmthWentWrong();

  @override
  _ErrorType get _type => _ErrorType.smth;

  @override
  String get  toText => 'Something went wrong! Upload latest version of app to fix it. Contact us if it didn\'t help';
}

enum _ErrorType {
  data,
  smth,
}


