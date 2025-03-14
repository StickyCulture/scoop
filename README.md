# Scoop

Scoop is a simple diagnostics tool for checking incoming [Boop](https://github.com/StickyCulture/boop) telemtry data.

## Use Case

Sticky Culture uses Scoop when developing and debugging interactive experiences that report telemetry data via our [Boop](https://github.com/StickyCulture/boop) package. Scoop makes it easy to confirm that the data is being sent correctly and received in the Firestore database.

## Getting Started

To use Scoop on your iOS device, follow these steps:

1. **Clone the Repository**
   ```sh
   git clone https://github.com/StickyCulture/scoop.git
   cd scoop
   ```

2. **Copy the Example.xcconfig** and update the values
   ```sh
   cp Configuration/Example.xcconfig Configuration/Debug.xcconfig
   cp Configuration/Example.xcconfig Configuration/Release.xcconfig
   ```

3. **Configure Firebase** to point to your Boop Firestore project.
   Download `GoogleService-Info.plist` and place it in the _Configuration/_ directory

4. **Build and Run**
   Open the project in Xcode and run the app on an iOS device, such as iPhone.

5. **Add a Scoop** by entering the name of your target Boop Firebase collection.

6. **Boop it** by triggering events in your app and watch to see if they arrive in Scoop.