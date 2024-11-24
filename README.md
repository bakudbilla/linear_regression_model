
<h1>API ENPOINT</h1>

https://linear-regression-model-qaq0.onrender.com/predict

<h1>VIDEO DEMO</h1>

https://www.youtube.com/watch?v=sljkiD-dQmw

<h1>Medical Insurance Cost Predictor</h1>

![Screenshot_20241124_173033](https://github.com/user-attachments/assets/5bf342b5-8937-4b1e-a19a-b94bed28fbf1)

A Flutter mobile application that predicts medical insurance costs based on personal health metrics and lifestyle factors using machine learning.
Features

Predicts medical insurance costs based on the following:
 - Age
 - BMI (Body Mass Index)
 - Number of children
 - Gender
 - Smoking status

<h2>Prerequisites</h2>
Ensure you have the following tools installed:

- Flutter SDK
- Install Flutter
- Dart SDK (comes with Flutter)
- Android Studio (for Android emulation)

Git: Install Git

<h2>Installation</h2>
Clone the Repository:

```
git clone https://github.com/KennyKvn001/farm-ed_flutter_app 
cd insurancecostpredictor
```
Install Dependencies: Inside the project directory, run:

```flutter pub get```

Add required dependencies to pubspec.yaml:

```
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0

```
<h1>Folder Structure</h1>

```
 insurancecostpredictor/
│
├── lib/                    
│   └── main.dart          
│
├── android/               
│
├── ios/                   
│
├── images/                
│
├── pubspec.yaml          
│
└── README.md
```

Configure assets in pubspec.yaml:

```
flutter:
  assets:
    - images/medical_insurance.jpeg
```

Running the Application

Start an Emulator or Connect a Device:
Use Android Studio to launch an emulator or connect a physical device.

Run the App:

```
flutter run
```

Hot Reload (during development): Make changes and save to see updates instantly.


