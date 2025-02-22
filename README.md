# Bug It - iOS Bug Tracking App

## Overview
Bug It is an iOS application built with Swift and SwiftUI that enables users to efficiently track and report bugs. The app allows users to capture screenshots, add descriptions, and automatically store bug reports in Google Sheets, with seamless integration for image sharing from other apps.

## Features

### Core Functionality
- 📸 Screenshot Capture & Upload
  - Take screenshots within the app
  - Select images from device gallery
  - Receive images from other apps
  - Automatic upload to third-party storage with URL generation

- 📝 Bug Documentation
  - Detailed bug descriptions
  - Automatic date-based organization
  - Customizable fields for comprehensive reporting

- 📊 Google Sheets Integration
  - Automatic creation of date-based sheets (e.g., "26-09-23")
  - Real-time data synchronization
  - Secure API implementation

### Technical Architecture
- MVVM Architecture
- Clean Code principles
- Modular Network Layer
- SwiftUI for modern UI implementation

## Installation

### Prerequisites
- Xcode 14.0+
- iOS 15.0+
- CocoaPods

### Dependencies

pod 'GoogleSignIn'
pod 'GoogleSignInSwift'
pod 'GoogleAPIClientForREST/Sheets'

Project Structure

BugIt/
├── App/
│   └── BugItApp.swift
├── Features/
│   ├── BugSubmission/
│   ├── ImageCapture/
│   └── Settings/
├── Core/
│   ├── Network/
│   └── Storage/
├── Utils/
└── Resources/

