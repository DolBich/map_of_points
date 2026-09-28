# Map of Points

A Flutter application for parsing GPS flight logs and visualizing flight trajectories on an interactive map.

## Overview

Map of Points processes binary GPS logs produced by a tracking device and visualizes the recorded flight path on an interactive map.

The application validates incoming GPS records, displays information for individual points, and allows the user to navigate through the recorded track.

Invalid GPS records are excluded from the rendered trajectory while remaining available for inspection.

## Features

* Parse binary `.bin` GPS log files
* Validate GPS records
* Visualize flight trajectories on an interactive map
* Navigate between recorded points
* Display detailed information for the selected GPS point
* Inspect invalid records separately
* Automatically focus the map on the selected point
* Interactive map navigation with zoom and pan

## GPS Data

Each parsed record contains information including:

* Fix status
* Latitude
* Longitude
* Altitude
* Validity

The application expects binary input files produced by the corresponding GPS tracker. The current parser expects files whose size is divisible by 11 bytes.

## Architecture

The application is structured around separate presentation and data-handling components, with routing implemented using `AutoRoute` and application state managed with `BLoC`.

```text
lib/
├── presentation/
├── ...
└── main.dart
```

## Tech Stack

* Flutter / Dart
* BLoC
* AutoRoute
* Flutter Map
* LatLong2
* Dartz
* File Picker
* JSON Serializable
* Build Runner

## Supported Platforms

The project contains Flutter targets for:

* Android
* iOS
* Linux
* macOS
* Web
* Windows

## Example Workflow

1. Open the application.
2. Select a `.bin` GPS log file.
3. The application parses and validates the recorded data.
4. Valid points are rendered as a flight trajectory on the map.
5. Select individual points to inspect their recorded data.
6. Invalid records can still be inspected even though they are excluded from the trajectory.

## Why I Built It

The project was built to work with GPS flight data and to provide a practical visualization and inspection tool for recorded telemetry.

It also serves as an example of working with binary input data, validation, state management, and interactive geospatial visualization in Flutter.

## Status

This is a completed personal project and is preserved as a technical showcase.

---

```
Flutter • GPS • Telemetry • Binary Data • Geospatial Visualization • BLoC
```
