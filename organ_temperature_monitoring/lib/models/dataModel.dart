import 'dart:convert';

class DataModel {
  String Temperature;
  String Timestamp;
  String Battery;

  DataModel.fromJson(Map<String, dynamic> json)
      : Temperature =
            (json['Temperature'] == null) ? '-1' : json['Temperature'],
        Timestamp = json['Timestamp'],
        Battery = (json['Battery'] != null) ? json['Battery'] : '-1';

  //a method that convert object to json
  Map<String, dynamic> toJson() =>
      {'Temperature': Temperature, 'Timestamp': Timestamp, 'Battery': Battery};
}
