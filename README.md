

# Tarzan Pet Tracker

## Motivation
I wanted to create my own GPS tracker for my pet puppy since he's a little escape artist. I saw the prices of dog trackers and the subscription costs includes and thought `Noooope`. So I opted to make my own, and learn more about Flutter and how to make my own iot project. The tracker itself is made of a Raspberry Pi Zero, with a battery, GPS and Sim Module attached. Coordinates are uploaded to Firestore using NodeJS on the PiZero. 

## Gifs

<table>
  <tr>
    <td>
      <img src="readme_files/record_1.gif"/>
      Recording 1
    </td>
    <td>
      <img src="readme_files/record_2.gif"/>
      Recording 2
    </td>
    <td>
      <img src="readme_files/record_3.gif"/>
      Recording 3
    </td>
  <tr>
</table>

## Features

| Features        | Have Been Implemented           | 
| ------------- |:-------------:|
| Authentication      |  ✅ |  
| Error states     | ✅      |   
| Real Time Tracker Updates | ✅      |
| Real Time Geofencing | ✅      |
| Real Time Notifications | ✅     |
| Works on Foreground | ✅      |
| Works in background | ✅      |
| Real Time Driving Directions | ✅     |
| Real Time Walking Directions | ✅      |
| Real Time Location Updates | ✅      |

## Technology and Services Used
* Flutter and Dart - Riverpod for State Management
* Google Firebase - Authentication, Storage, Firestore NoSql
* Google Cloud - Google Maps Api, Google Directions Api

