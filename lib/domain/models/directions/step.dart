import 'dart:convert';

import 'package:flutter/foundation.dart';

class Step {
  Map<String, dynamic> distance;
  Map<String, dynamic> duration;
  Map<String, dynamic> endLocation;
  String htmlInstructions;
  Map<String, dynamic> startLocation;
  String travelMode;
  Step({
    required this.distance,
    required this.duration,
    required this.endLocation,
    required this.htmlInstructions,
    required this.startLocation,
    required this.travelMode,
  });

  Step copyWith({
    Map<String, dynamic>? distance,
    Map<String, dynamic>? duration,
    Map<String, dynamic>? endLocation,
    String? htmlInstructions,
    Map<String, dynamic>? startLocation,
    String? travelMode,
  }) {
    return Step(
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      endLocation: endLocation ?? this.endLocation,
      htmlInstructions: htmlInstructions ?? this.htmlInstructions,
      startLocation: startLocation ?? this.startLocation,
      travelMode: travelMode ?? this.travelMode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'distance': distance,
      'duration': duration,
      'endLocation': endLocation,
      'htmlInstructions': htmlInstructions,
      'startLocation': startLocation,
      'travelMode': travelMode,
    };
  }

  factory Step.fromMap(Map<String, dynamic> map) {
    return Step(
      distance: Map<String, dynamic>.from(map['distance']),
      duration: Map<String, dynamic>.from(map['duration']),
      endLocation: Map<String, dynamic>.from(map['end_location']),
      htmlInstructions: map['html_instructions'],
      startLocation: Map<String, dynamic>.from(map['start_location']),
      travelMode: map['travel_mode'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Step.fromJson(String source) => Step.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Step(distance: $distance, duration: $duration, endLocation: $endLocation, htmlInstructions: $htmlInstructions, startLocation: $startLocation, travelMode: $travelMode)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Step &&
        mapEquals(other.distance, distance) &&
        mapEquals(other.duration, duration) &&
        mapEquals(other.endLocation, endLocation) &&
        other.htmlInstructions == htmlInstructions &&
        mapEquals(other.startLocation, startLocation) &&
        other.travelMode == travelMode;
  }

  @override
  int get hashCode {
    return distance.hashCode ^
        duration.hashCode ^
        endLocation.hashCode ^
        htmlInstructions.hashCode ^
        startLocation.hashCode ^
        travelMode.hashCode;
  }
}

/*
 * Example of a step from the "Steps" list in the directions response. 
 */

//  "distance": {
//                 "text": "83 m",
//                 "value": 83
//               },
//               "duration": {
//                 "text": "1 min",
//                 "value": 62
//               },
//               "end_location": {
//                 "lat": -33.9267932,
//                 "lng": 150.8580565
//               },
//               "html_instructions": "Walk <b>west</b> towards <b>Hoxton Park Rd</b>",
//               "polyline": {
//                 "points": "zhanEqsww[@@@B?B@F@NBV@L?N?V@H?HBF?BHX@D?DM?"
//               },
//               "start_location": {
//                 "lat": -33.9267012,
//                 "lng": 150.8589749
//               },
//               "travel_mode": "WALKING"
//             },