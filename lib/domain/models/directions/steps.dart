import 'dart:convert';

class Steps {
  Map<String, dynamic> distance;
  Map<String, dynamic> duration;
  Map<String, dynamic> endLocation;
  Map<String, String> htmlInstructions;
  Map<String, dynamic> startLocation;
  Map<String, String> travelMode;

  Steps({
    required this.distance,
    required this.duration,
    required this.endLocation,
    required this.htmlInstructions,
    required this.startLocation,
    required this.travelMode,
  });

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

  factory Steps.fromMap(Map<String, dynamic> map) {
    return Steps(
      distance: Map<String, dynamic>.from(map['distance']),
      duration: Map<String, dynamic>.from(map['duration']),
      endLocation: Map<String, dynamic>.from(map['end_location']),
      htmlInstructions: Map<String, String>.from(map['html_instructions']),
      startLocation: Map<String, dynamic>.from(map['start_location']),
      travelMode: Map<String, String>.from(map['travel_mode']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Steps.fromJson(String source) => Steps.fromMap(json.decode(source));
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