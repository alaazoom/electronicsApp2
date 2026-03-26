
# Design Tokens for Flutter (Mobile) - Light & Dark Theme Support

This directory contains design tokens converted from Figma design files, with full support for both light and dark themes.

## 📂 Files Structure

### `app_colors.dart`
Contains all color definitions organized into:
- **Basic Colors**: white, black, placeholders, borders, icons, text, titles, hints.
- **Main & Secondary Colors**: With transparency variants.
- **Status Colors**: Warning, success, error.
- **Theme Extension**: Logic to toggle between `AppColors.light` and `AppColors.dark`.

### `app_typography.dart`
Contains all text styles using **Poppins** font:
- **Headings, Body Text, Buttons, Labels**.
- **Note**: Styles define size and weight only (colors are handled by the theme).

### `app_shadows.dart`
Contains theme-aware shadows:
- `card`: Standard shadow (Black in Light Mode, White/Transparent in Dark Mode).
- `bottomSheet`: Shadow for bottom sheets.

### `app_theme.dart`
Main theme configuration:
- `AppTheme.lightTheme` & `AppTheme.darkTheme`.
- Automatically maps colors and typography to Flutter's standard widgets.

---

## 🚀 Setup

### 1. Add Poppins Font
Add the Poppins font to your `pubspec.yaml`:

```yaml
flutter:
  fonts:
    - family: Poppins
      fonts:
        - asset: fonts/Poppins-Regular.ttf
          weight: 400
        - asset: fonts/Poppins-Medium.ttf
          weight: 500
        - asset: fonts/Poppins-SemiBold.ttf
          weight: 600
        - asset: fonts/Poppins-Bold.ttf
          weight: 700

```

### 2. Configure Main App

In your `main.dart`, enable both themes:

```dart
import 'package:flutter/material.dart';
import 'configs/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      // ✅ Enable both themes here
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Follows system settings
      home: const HomePage(),
    );
  }
}

```

---

## ✅ How to Use (The Right Way)

### 1. Using Colors (Dynamic)

Always use `context.colors` to ensure Dark Mode support.

```dart
// ✅ CORRECT
Container(
  color: context.colors.mainColor, // Changes automatically
  child: Text(
    'Hello',
    style: TextStyle(color: context.colors.onPrimary),
  ),
)

// ❌ WRONG (Avoid this)
Container(
  color: AppColors.mainColor, // Static, won't change in Dark Mode
)

```

### 2. Using Typography

Combine `AppTypography` with dynamic colors.

```dart
Text(
  'Heading',
  style: AppTypography.h2_20SemiBold.copyWith(
    color: context.colors.titles, // ✅ Dynamic Color
  ),
)

```

**Pro Tip:** Standard widgets like `AppBar` or `ListTile` use the correct font and color automatically because we configured `AppTheme.dart`.

### 3. Using Shadows

Shadows adapt to the theme (e.g., subtle black shadow in Light Mode, glow or no shadow in Dark Mode).

```dart
Container(
  decoration: BoxDecoration(
    color: context.colors.surface,
    borderRadius: BorderRadius.circular(12),
    boxShadow: context.shadows.card, // ✅ Dynamic Shadow
  ),
  child: YourWidget(),
)

```

### 4. Custom Widgets Example

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access theme data
    final colors = context.colors; 
    
    return Container(
      decoration: BoxDecoration(
        color: colors.surface, // White (Day) / Dark Grey (Night)
        border: Border.all(color: colors.border),
      ),
      child: Text(
        'Content',
        style: AppTypography.body14Regular.copyWith(
          color: colors.text,
        ),
      ),
    );
  }
}

```

---

## 🎨 Color Mapping Reference

| Element | Light Mode Color | Dark Mode Color | Usage |
| --- | --- | --- | --- |
| **Background** | White (#FFFFFF) | Dark (#121212) | Scaffold background |
| **Surface** | White (#FFFFFF) | Dark Grey (#1E1E1E) | Cards, Sheets, Dialogs |
| **Titles** | Black (#212121) | White (#E5E5E5) | Main Headings |
| **Text** | Dark Grey (#3D3D3D) | Light Grey (#B3B3B3) | Body text |
| **Border** | Light Grey (#E4E4E4) | Dark Grey (#3D3D3D) | Dividers, Borders |
| **Fill** | Very Light Grey (#F9FAFB) | Dark Grey (#2A2A2A) | TextFields, Badges |

---

## ⚠️ Important Rules

1. **Never use `AppColors.someColor` directly inside Widgets.** Use `context.colors.someColor`.
2. **Never use `AppShadows.someShadow` directly.** Use `context.shadows.someShadow`.
3. **Exceptions:** You can use static `AppColors` inside `static` variables or constants where `context` is not available, but try to convert those to methods if they need to be theme-aware.