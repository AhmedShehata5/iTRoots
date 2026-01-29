Here is the clean, professional, and concise README.md for your project without any icons:

iTroots Task - Swift MVVM Application
A comprehensive iOS application built with MVVM architecture, featuring a full authentication flow, hybrid data management, and real-time localization.

Key Features
Authentication Flow: Includes dedicated Login and Register modules with input validation and session persistence.

Hybrid Data Strategy: Core text content is sourced from local JSON files, while images are dynamically integrated from remote APIs via a custom APIService.

Offline-First Architecture: Ensures a seamless user experience during network outages by caching both data and remote image assets.

Instant Localization: Features a built-in Language Switcher for English and Arabic that updates the entire app layout (RTL/LTR) instantly without a restart.

Custom UI Design:

Unified MainTabBarController with a consistent brand color theme.

Branded Navigation Bar with high-contrast elements for better visibility.

Integrated Side Menu for quick access to app settings and preferences.

Tech Stack
Language: Swift.

Architecture: MVVM (Model-View-ViewModel).

Networking: Alamofire for robust API communication.

Image Handling: SDWebImage for asynchronous downloading and memory caching.

UI Frameworks: Programmatic UIKit and SideMenu library.

Persistence: UserDefaults for session management and File Manager for local data handling.

Architecture Overview
ViewControllers: Manages UI logic for Login, Register, Home, and Settings screens.

ViewModels: Handles business logic, authentication states, and the merging of local/remote data.

Services: Specialized APIService for fetching local resources and remote API data.

Managers: Dedicated managers for localization logic and offline storage.

How to Run
Clone the repository.

Install dependencies via CocoaPods or Swift Package Manager.

Open iTrootsTask.xcodeproj.

Build and run on any iOS 15.0+ device or simulator.
