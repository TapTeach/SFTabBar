# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Plan & Review
### Before starting work
- Always in plan mode to make a plan
- After get the plan, make sure you Write the plan to • claude/tasks/TASK_NAME. md.
- The plan should be a detailed implementation plan and the reasoning behind them, as well as tasks broken down.
- If the task require external knowledge or certain package, also research to get latest knowledge (Use Task tool for research)
- Don't over plan it, always think MVP.
- Once you write the plan, firstly ask me to review it. Do not continue until I approve the plan.
### While implementing
- You should update the plan as you work.
- After you complete tasks in the plan, you should update and append detailed descriptions of the changes you made, so following tasks can be easily hand over to other engineers.

## Project Overview

SFTabBar is a SwiftUI iOS app that provides an interactive tool for designing and previewing tab bar interfaces using SF Symbols. The app allows users to customize tab items with different icons, labels, weights, and colors, then export the generated SwiftUI code or preview the live tab bar.

## Architecture

### Core Components

- **TabsViewModel**: Central observable object managing all tab configuration state (icons, labels, weights, colors)
- **ContentView**: Main interface with live tab bar preview and configuration forms
- **tabItem**: Custom view component that renders individual tab items in the preview
- **SymbolsListView**: Searchable/filterable browser for SF Symbols with category support
- **Export**: Generates and displays copy-pasteable SwiftUI tabItem code
- **PlayView**: Live interactive tab bar preview using native SwiftUI TabView

### Data Flow

1. User configures tabs through ContentView forms
2. Changes update TabsViewModel @Published properties  
3. Live preview updates automatically via @ObservedObject binding
4. Export generates SwiftUI code from current tab state
5. PlayView creates functional TabView using configured properties

### Key Features

- **Dynamic Tab Count**: Supports 1-5 configurable tabs via stepper control
- **SF Symbols Integration**: Complete SF Symbols 6.0 library loaded from sfsymbols6.json
- **Live Preview**: Custom tab bar visualization with device frame and home indicator
- **Code Export**: Generates proper SwiftUI .tabItem modifier code with copy-to-clipboard
- **Weight System**: Font weight selection for tab icons (regular, bold, etc.)
- **Color Customization**: Independent tab bar color, item color, and tint color controls

### Navigation Structure

```
ContentView (NavigationStack)
├── SymbolsListView (icon selection)
├── WeightListView (font weight selection)  
├── TipJar (IAP)
├── PlayView (live preview)
└── Export (code generation)
```

## Development Commands

This is an Xcode project - use Xcode to build, run, and test the app:

- Build: ⌘+B in Xcode
- Run: ⌘+R in Xcode  
- Test: ⌘+U in Xcode

## SwiftUI Patterns

The project uses modern SwiftUI patterns:
- `.toolbar` with `ToolbarItem`/`ToolbarItemGroup` for navigation bar items
- `NavigationStack` (modern navigation)
- `@ObservedObject` for view model binding
- Form-based configuration UI
- Custom Shape views (HRule, VRule) for preview guidelines

## Data Sources

- **sfsymbols6.json**: Complete SF Symbols 6.0 catalog with categorized symbol names
- **SFData.swift**: JSON loading utilities using Bundle.main resources
- **SFModel.swift**: Data models for symbol library structure

## Important Files

- **ContentView.swift**: Main app interface and tab configuration
- **TabsViewModel**: All tab state management  
- **Export.swift**: SwiftUI code generation and clipboard functionality
- **PlayView.swift**: Live tab bar preview with UITabBarAppearance customization