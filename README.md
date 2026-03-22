# QR Folio

QR Folio is a mobile application built with Flutter that allows users to create, manage, and share their professional portfolios via personalized QR codes. It serves as a modern digital business card and a comprehensive media hub, making networking effortless and dynamic.

## 📱 App Overview
QR Folio enables professionals to bundle their contact details, professional experience, images, videos, and documents into a centralized digital profile. This interactive profile is easily shareable through a unique QR code, eliminating the need for traditional physical business cards.

## 🔄 High-Level Flow
1. **Authentication**: Users securely sign up, verify their email, and log in to the platform.
2. **Profile Setup**: Users define and update their personal and professional details.
3. **Media Management**: Users organize their portfolio gallery by uploading and managing:
   - Images
   - Video Links
   - Professional Documents (e.g., PDFs)
4. **QR Code Generation**: The app automatically generates a personalized QR code linking directly to the user's digital portfolio.
5. **QR Sharing & Export**: Users can share their QR code seamlessly, export it in various formats (PNG, SVG), or copy the direct profile link to share manually.
6. **QR Scanning**: Users can utilize the built-in scanner to quickly view other colleagues' and professionals' QR Folios.

## ✨ Key Features
- **User Authentication**: Secure Sign Up, Login, and Email Verification functionality.
- **Profile Customization**: Detailed, professional portfolio pages.
- **Rich Media Gallery**: Specialized tabs for managing Images, Videos, and Documents efficiently.
- **Dynamic QR Code**: Generate visually appealing and recognizable QR codes (`pretty_qr_code`).
- **QR Export & Sharing**: Export QR codes natively (PNG, SVG) and share instantly via messaging apps.
- **Built-in Scanner**: Scan external QR Folios with ease using the device's camera (`mobile_scanner`).

## 🛠️ Technical Stack & Architecture
- **Framework**: Flutter (Dart)
- **State Management**: BLoC Pattern (`flutter_bloc`) 
- **Architecture**: Feature-Based Clean Architecture (separated into Presentation, Domain, and Data layers)
- **Networking/API**: Dio for robust and interceptor-enabled HTTP requests
- **UI/UX**: Custom UI themes, seamless tab transitions, `google_fonts` (Plus Jakarta Sans).
- **Local Storage**: `flutter_secure_storage` for managing secure session tokens safely.
- **Environment Management**: Secure API configuration using `.env` (`flutter_dotenv`).

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.10.7)
- Dart SDK
- Android Studio / VS Code (or your preferred IDE)
- A valid `.env` file containing your backend API endpoints.

### Installation
1. Clone this repository.
2. Navigate to the project root and install the necessary dependencies:
   ```bash
   flutter pub get
   ```
3. Set up the `.env` file in the root directory:
   ```env
   # Add your API base URLs and specific keys here
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## 📂 Project Structure
The app adheres to a structured **Clean Architecture** approach:
- `lib/core`: App-wide utilities, centralized themes, and reusable widgets (e.g., `Navbar`, `Wallpaper`).
- `lib/features/auth`: Login, Signup, user verification, and secure session management.
- `lib/features/home`: Main dashboard, user profile viewing, and updates.
- `lib/features/media`: Media gallery showcasing distinct tabs for Images, Videos, and Docs, along with upload capabilities.
- `lib/features/qr`: Creating, displaying, exporting, and scanning QR codes.
