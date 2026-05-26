# Journal App - Premium Journaling Experience

A modern, minimal journaling app built with Flutter, inspired by Notion and Obsidian.

## Features

### Core Features
- ✅ Authentication (Login/Register/Forgot Password)
- ✅ Rich Text Editor with formatting options
- ✅ Create, read, update, and delete journal entries
- ✅ Sidebar navigation with user profile
- ✅ Full-text search across all journals
- ✅ Favorites system with dedicated view
- ✅ Dark mode with premium black & gold theme
- ✅ Offline-first architecture with local storage
- ✅ Cloud sync with Supabase
- ✅ Smooth animations and transitions
- ✅ Responsive layout for all screen sizes

### Premium Features
- 🎨 Custom rich text formatting
- 🏷️ Tag system for organization
- ⭐ Favorite journals
- 🔍 Advanced search with filters
- ☁️ Automatic cloud backup
- 📱 Offline support with sync queue
- 🌙 Dark/Light theme toggle
- ⚡ Smooth page transitions
- 💾 Local caching for instant loading

## Tech Stack

- **Framework**: Flutter 3.x
- **State Management**: Riverpod 2.x
- **Backend**: Supabase
- **Database**: PostgreSQL (Cloud), Hive (Local)
- **Rich Text**: Flutter Quill
- **Navigation**: Go Router
- **Connectivity**: Connectivity Plus
- **UI**: Custom premium components

## Architecture

```
lib/
├── core/
│   ├── constants/          # App-wide constants
│   ├── errors/             # Error handling utilities
│   ├── extensions/         # Dart extension methods
│   ├── models/             # Data models
│   ├── router/             # GoRouter configuration & guards
│   ├── services/           # Database & storage services
│   ├── theme/              # App theme (light/dark)
│   └── utils/              # Connectivity, validation, date formatting
├── features/
│   ├── auth/               # Authentication (login, register, forgot password)
│   ├── journal/            # Journal CRUD, editor, favorites, search, sync
│   ├── settings/           # App settings
│   └── sidebar/            # Navigation drawer
├── shared/
│   └── widgets/            # Reusable UI components
├── app.dart                # App entry widget
└── main.dart               # Main entry point
```

## Setup

### Prerequisites
- Flutter SDK >=3.44.0
- Dart SDK ^3.12.0
- Supabase account (for cloud sync)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/ossy-hash/Journal_App.git
   cd Journal_App
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Supabase** (optional, required for cloud sync)
   - Create a Supabase project
   - Add your Supabase URL and anon key to environment or config

4. **Run the app**
   ```bash
   flutter run
   ```

## Dependencies

| Package | Purpose |
|---------|---------|
| flutter_riverpod | State management |
| supabase_flutter | Cloud backend & auth |
| hive_flutter | Local storage |
| flutter_quill | Rich text editor |
| go_router | Navigation & routing |
| google_fonts | Custom typography |
| connectivity_plus | Network monitoring |
| shimmer | Loading animations |
| intl | Date formatting & i18n |
| uuid | Unique ID generation |

## License

MIT
