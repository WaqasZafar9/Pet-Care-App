# Pettify

Pettify is a comprehensive Flutter application designed to provide pet care services, including shopping for pet products, accessing pet-related information, and integrating various functionalities for a seamless user experience. This project utilizes Firebase for backend services and includes features such as user authentication, cloud storage, and real-time database access.

## Features

- **User Authentication**: Sign in and sign up using email and password, Google Sign-In.
- **Product Catalog**: Browse categories, popular items, and new items.
- **Search and Filter**: Easily search and filter products.
- **Carousel Slider**: Display top offers and featured products.
- **Geolocation Services**: Integration with Google Maps and location services.
- **Cloud Integration**: Firebase for real-time database, storage, and analytics.

## Installation

### Prerequisites

- Flutter SDK: Version >=3.3.1 <4.0.0
- Dart SDK
- Android Studio or Visual Studio Code with Flutter and Dart plugins
- Firebase project setup

### Clone the Repository

```
git clone https://github.com/yourusername/pettify.git
```
```
cd pettify
```

### Setup Firebase

1. Go to the Firebase Console and create a new project.
2. Add an Android app to your project and download the `google-services.json` file. Place it in the `android/app` directory.
3. Add an iOS app to your project and download the `GoogleService-Info.plist` file. Place it in the `ios/Runner` directory.
4. Enable Firebase Authentication, Firestore, and Storage in the Firebase Console.

### API Key Configuration

1. Create a file named `.env` in the root directory and add the following content:

    ```
    APIKEY="YOUR_GOOGLE_MAPS_API_KEY"
    GPTAPI="YOUR_OPENAI_API_KEY"
    GEMINIAPI="YOUR_GEMINI_API_KEY"
    ```

2. Create a file named `api_keys.dart` in the `lib` directory and add the following content:

    ```dart
    import 'package:flutter_dotenv/flutter_dotenv.dart';

    var APIKEY = dotenv.env["APIKEY"]!;
    var GPTAPI = dotenv.env["GPTAPI"]!;
    var GEMINIAPI = dotenv.env["GEMINIAPI"]!;
    ```

Replace the placeholder values with your actual API keys.

### Install Dependencies

```bash
flutter pub get
```

## Running the Application

### Android / iOS

```bash
flutter run
```

## Dependencies

- flutter 
- cupertino_icons
- font_awesome_flutter
- google_nav_bar
- firebase_core
- firebase_auth
- firebase_analytics
- firebase_crashlytics
- google_maps_flutter
- cloud_firestore
- google_sign_in
- image_picker
- firebase_storage
- location
- flutter_polyline_points
- awesome_snackbar_content
- modal_progress_hud_nsn
- file_picker
- google_gemini
- shared_preferences
- google_generative_ai
- simple_shadow
- carousel_slider
- flutter_rating_bar
- blurrycontainer
- flutter_stripe

## Contributions

Contributions to this project are welcome. If you find any issues or want to add new features, feel free to open an issue or submit a pull request.  
> ### Contact me via email: [fuzailraza161@gmail.com](mailto:fuzailraza161@gmail.com)  

## License

This project is licensed under the GNU License - see the LICENSE file for details.

Thank you for using Pettify!