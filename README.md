# Life RPG

Life RPG is an iOS app that turns personal goals into quests. Track active quests, gain EXP, level up, and see your rank evolve over time. The project also includes a home screen widget for quick progress at a glance.

## Features
- Quest tracking with status (In Progress, Completed, Cancelled)
- EXP and level system with rank tiers (E → SSS)
- Quest history with detail view and clear-history flow
- Rank screen with animated visuals and a Hogwarts-themed rank list
- Home screen widget showing active quest count
- Localization support (English and Thai)

## Project Structure
- `Life RPG/` iOS app target (UIKit)
- `QuestWidget/` WidgetKit extension (home screen widget)
- `Life RPGTests/` and `Life RPGUITests/` test targets

## Requirements
- Xcode (recent enough for iOS 17.5 SDK)
- iOS 17.5+ deployment target
- Swift Package dependency: Alamofire 5.9.1

## Getting Started
1. Open `Life RPG.xcodeproj` in Xcode.
2. Select the `Life RPG` scheme.
3. Choose an iOS simulator or device (iOS 17.5+).
4. Build and run.

## Widget Notes
- The widget reads active quests from the app group `group.com.6530288.Life-RPG`.
- Quest updates trigger widget timeline reloads via `WidgetCenter`.

## Data & Persistence
- Quests and user progression are stored in `UserDefaults`.
- Active quests and all quests are stored separately for quick filtering.

## Localization
- Strings are localized in `Life RPG/en.lproj` and `Life RPG/th.lproj`.
- Language can be switched in Settings; the app restarts its root controller to apply changes.

## External Services
- Hogwarts staff data is fetched from `https://hp-api.herokuapp.com/api/characters/staff` for the All Ranks view.

## Testing
Run tests from Xcode:
- `Life RPGTests`
- `Life RPGUITests`

## License
Add a license file if you plan to distribute this project.
