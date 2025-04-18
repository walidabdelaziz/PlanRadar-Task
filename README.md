# PlanRadar - iOS

The **PlanRadar App** is designed to provide users with an intuitive experience for searching cities, retrieving real-time weather data, and accessing the history of previously saved weather data locally. The app allows users to explore weather conditions for different cities, view detailed historical information, and store city-specific weather data for future reference.

## Requirements

- iOS 18.0+
- Xcode 16.0+
- Swift 5.5+

## Installation

- Clone the repository.
- Open PlanRadar Task.xcodeproj.
- Build and run the project on your simulator or device.

## Technologies Used

### Reactive Programming with RxSwift

- RxSwift & RxCocoa are used for building reactive and responsive UIs.
- Implements BehaviorRelay for managing reactive states.
- Observables trigger UI updates dynamically and efficiently.


### MVVM + Clean Architecture

- Follows MVVM (Model-View-ViewModel) architecture for clear separation of concerns.
- Implements Clean Architecture principles with a layered structure:
  - **Presentation Layer** – Views and ViewModels
  - **Domain Layer** – Business logic and entities
  - **Data Layer** – Networking and local storage (Core Data)

### Alamofire with Async/Await

- Integrates Alamofire, a popular networking library for Swift, to handle HTTP requests.
- Leverages async and await features in Swift 5.5 to write asynchronous code in a more readable and synchronous-like manner.

### Local Storage with Core Data

- Weather data responses are stored locally using Core Data.

### Image Caching with Kingfisher

- Integrates Kingfisher for efficient image downloading and caching.
- Enhances performance by avoiding redundant image loads.

## Features

- [x] Search for cities and retrieve real-time weather data.
- [x] Browse detailed weather information, including temperature, humidity, wind speed, and more.
- [x] Access and view the history of weather data saved locally.
- [x] Dynamic form filling and smooth user experience with reactive programming.





