# [Investigate theming of app as well as colours](https://github.com/ZanderCowboy/multichoice/issues/8)

## Ticket: [8](https://github.com/ZanderCowboy/multichoice/issues/8)

### branch: `8-investigate-theming-of-app-as-well-as-colours-1`

### Overview

This ticket is primarily responsible for setting up theming in our app. I also implemented Light mode and Dark mode.

### What was done

- [X] Created a `Makefile` to avoid typing the commands in the terminal manually
```make
fb:
 flutter pub get && dart run build_runner build --delete-conflicting-outputs
 
db:
 dart run build_runner build --delete-conflicting-outputs

frb:
 flutter clean && flutter pub get && dart run build_runner build --delete-conflicting-outputs
```
- [X] Restructured new code
- [X] Created an app palette in `app_palette.dart`
- [X] Created typography for the app in `app_typography.dart`
- [X] Updated the UI with the new colors and text styles
- [X] Created a simple `Drawer` on the HomePage
- [X] Implemented `Light` mode and `Dark` mode
- [X] Created `app_colors_extension` and `app_text_extension`, along with `AppThemeExtension`
- [X] Created and updated main `AppTheme` in `app_theme.dart`
- [X] Created a `ThemeGetter` to enable us to use `context.theme` with `ThemeData get theme => Theme.of(this);`
- [X] Created `theme` package and added files

### What needs to be done

- [ ] Verify that our method of refreshing the theme button in the HomeBloc
- [ ] Remove `theme_service` and interface `i_theme_service`

### Resources

- [name](https://medium.com/@alexandersnotes/flutter-custom-theme-with-themeextension-792034106abc)
- [Don’t write Theme.of(context) ANYMORE](https://medium.com/@alexandersnotes/how-to-improve-flutter-code-with-extension-methods-99854a29692c)
- [`theme_tailor`](https://pub.dev/packages/theme_tailor)
- [`provider`](https://pub.dev/packages/provider)
- [`shared_preferences`](https://pub.dev/packages/shared_preferences)
- [Mobile Palette Generator](https://mobilepalette.colorion.co/)
- [colormagic](https://colormagic.app/)
