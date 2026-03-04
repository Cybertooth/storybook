# storybook_android

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## AGENTS

**Essential Information for Coding Agents to Start Working:**

This project is a standalone Flutter application developed within the `storybook_v1` monorepo. It initially utilizes an offline-first architecture with plans to integrate with the backend API.

### Tech Stack & Libraries
- **UI & SDK:** Flutter
- **State Management:** Riverpod (`flutter_riverpod`, `riverpod_annotation`)
- **Navigation:** GoRouter (`go_router`)
- **Local Database:** Drift (`drift`, `drift_flutter`) for SQLite
- **Networking:** Dio (`dio`)
- **Data Models:** Freezed (`freezed_annotation`) & JSON Serializable (`json_annotation`)

### Directory Structure
The application follows a clean-architecture-inspired modular approach under `lib/`:
- `core/`: Core utilities, theme, and basic infrastructure components.
- `data/`: Data sources, repositories implementations, and Local Storage (Drift) configurations.
- `domain/`: Business logic, domain entities, and abstract repository definitions.
- `features/`: The visual layers containing UI screens, components, and Riverpod providers.
- `shared/`: App-wide shared UI elements and reusable components.

### Crucial Developer Commands
Since this architecture heavily utilizes code generation for Riverpod, Drift, Freezed, and JSON Serializable, you **must run the build runner** whenever making changes to models, providers, or database schemas in `lib/`:
```bash
# Generate the code
flutter pub run build_runner build --delete-conflicting-outputs
# or alternatively:
dart run build_runner build -d
```
Without running the generator, you will encounter numerous missing `.g.dart` or `.freezed.dart` file compilation errors.
