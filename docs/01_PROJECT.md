# Construction Site Management System (CSMS)

# Cross-Platform Flutter Frontend Project Guide

Version: 1.0

---

# 1. Project Overview

The Construction Site Management System (CSMS) is a cross-platform business application developed using Flutter.

It is designed to simplify the daily operations of construction companies by providing a unified platform for managing:

- Construction Sites
- Workers
- Attendance
- Expenses
- Supervisor Wallet
- Warehouse Inventory
- Material Transfers
- Material Purchases
- Driver Daily Logs
- Reports & Dashboards

The application targets three platforms from a single codebase:

- Android
- iOS
- Web

The system is primarily a data-entry and reporting platform. The frontend must prioritize speed, usability, consistency, and maintainability over visual complexity.

Every feature should work consistently across all supported platforms while adapting its layout to the available screen size.

---

# 2. Project Goals

The primary objective is to build a production-ready Flutter application that is:

- Fast
- Clean
- Reliable
- Easy to maintain
- Easy for AI agents to extend
- Easy for users above 35 years of age

The application should focus on reducing the number of taps required to complete daily operations.

---

# 3. Target Users

The application supports five user roles.

## Admin

Responsible for overall system management.

Main responsibilities:

- User Management
- Site Management
- Worker Management
- Attendance Verification
- Warehouse Management
- Reports
- Salary Settlement
- Dashboard

---

## Supervisor

Responsible for daily site management.

Main responsibilities:

- Attendance
- Worker Management
- Site Expenses
- Wallet
- Material Transfer
- Worker Advances

---

## Ajax Driver

Responsible for:

- Daily Mix Log
- Attendance

---

## Hitachi Driver

Responsible for:

- Daily Hour Log
- Attendance

---

## Normal Driver

Responsible for:

- Material Purchase
- Attendance

---

# 4. Supported Platforms

The application is built using a single Flutter codebase.

Supported platforms:

- Android Phones
- Android Tablets
- iPhone
- iPad
- Modern Web Browsers

The application must automatically adapt its layout for different screen sizes without maintaining separate codebases.

Business logic, networking, validation, and state management must remain identical across every platform.

---

# 5. Design Philosophy

The application is an internal business tool, not a marketing product.

The design should prioritize productivity and readability over decorative UI.

Core Principles

- Simple
- Clean
- Professional
- Responsive
- Consistent
- Fast
- Accessible

UI Guidelines

- Large touch targets
- Readable typography
- High contrast
- Minimal colors
- Minimal graphics
- No decorative illustrations
- Minimal animations
- Forms should require the fewest possible user interactions
- Frequently used actions should always remain easily accessible

The interface should feel familiar across Android, iOS, tablets, and web while respecting each platform's interaction patterns.

---

# 6. Development Principles

The project follows these principles.

## Simplicity First

Always prefer simpler implementations.

Avoid unnecessary abstractions.

---

## Consistency

Every page should look similar.

Buttons, cards, forms, dialogs, and tables should follow the same design language.

---

## Reusability

Widgets should be reusable.

Never duplicate UI.

---

## Maintainability

Code should be readable.

Feature separation should be clear.

Files should remain small.

---

## Scalability

Adding new modules should require minimal changes.

---

## Testability

Business logic must remain testable.

UI should remain independent from backend implementation.

---

# 7. Responsive Design Principles

The application will use Responsive Design instead of separate applications for each platform.

Target layouts:

Mobile

- Android Phones
- iPhone

Tablet

- Android Tablets
- iPad

Desktop

- Web Browsers

Every screen should adapt automatically according to the available screen width.

Business logic must never depend on the device type.

Only the presentation layer should change between layouts.

Responsive behavior will be defined in the UI Design System document.

---

# 8. Project Scope

The frontend includes the following modules.

Authentication

Dashboard

Users

Sites

Workers

Attendance

Expenses

Supervisor Wallet

Warehouse

Stock Management

Material Transfers

Purchases

Ajax Driver Log

Hitachi Driver Log

Reports

Profile

Settings

---

# 9. Out of Scope

The following features are intentionally excluded.

- Chat
- Notifications
- Social features
- Complex animations
- Offline synchronization (Phase 1)
- AI features
- Maps
- GPS Tracking
- Camera-heavy workflows
- Media galleries
- Custom charts with animations

---

# 10. Development Approach

Development will follow incremental feature-based implementation.

Order:

1. Project Setup
2. Core Architecture
3. Authentication
4. Shared Components
5. Admin Module
6. Supervisor Module
7. Driver Modules
8. Reports
9. Settings
10. API Integration
11. Testing
12. Production Release

Each feature must be fully completed before moving to the next.

---

# 11. Coding Standards

The project must follow:

- Official Flutter Lints
- Null Safety
- Feature-first Architecture
- Clean Architecture
- Riverpod State Management
- GoRouter Navigation

General Rules:

- Small widgets
- Small methods
- Meaningful names
- Avoid duplicated code
- Avoid business logic inside UI
- Avoid hardcoded values
- Use constants whenever possible

---

# 12. User Experience Guidelines

The application should minimize user effort regardless of platform.

Every screen should:

- Open quickly
- Minimize scrolling
- Reduce typing wherever possible
- Prefer dropdowns and searchable selectors
- Use date pickers instead of manual entry
- Show clear validation messages
- Display immediate success or error feedback
- Require confirmation only for destructive actions

Platform Adaptation

Mobile

- Bottom navigation
- Full-screen forms
- Card-based lists

Tablet

- Larger content areas
- Two-column layouts where appropriate

Web

- Sidebar navigation
- Data tables
- Multi-column dashboards
- Keyboard shortcuts
- Mouse hover states

Users should never feel they are using a different application across platforms.

---

# 13. Performance Goals

The application should provide a responsive experience across Android, iOS, and modern web browsers.

Goals

- Fast startup
- Smooth navigation
- Efficient rendering
- Minimal widget rebuilds
- Optimized state updates
- Lazy loading for large datasets
- Responsive layouts without duplicated UI

Performance should remain acceptable on low-end Android devices while taking advantage of larger screens on tablets and desktop browsers.

---

# 14. Folder Organization

The frontend follows a Feature-First, Responsive Architecture.

The project will contain:

lib/

- app/
- core/
- shared/
- features/
- l10n/

Shared widgets should adapt their layout based on screen size instead of creating separate implementations for mobile and desktop.

Detailed folder organization is defined in the Flutter Architecture document.

---

# 15. Version Control

Branch Strategy

main

Production-ready code

develop

Integration branch

feature/<feature-name>

Individual features

Examples

feature/authentication

feature/dashboard

feature/workers

feature/attendance

feature/warehouse

---

# 16. Commit Convention

Use Conventional Commits.

Examples

feat: add worker management screen

feat: implement attendance form

fix: resolve login validation issue

refactor: simplify dashboard widgets

docs: update frontend architecture

style: improve spacing

test: add authentication tests

---

# 17. AI Development Workflow

The frontend will be developed with the assistance of AI coding agents.

The AI agent must:

- Follow project documents strictly.
- Never invent architecture.
- Never introduce new patterns without documentation.
- Never duplicate widgets.
- Never duplicate business logic.
- Build one feature at a time.
- Keep files focused and maintainable.
- Respect existing folder structure.
- Avoid unnecessary dependencies.

Project documentation always takes precedence over AI assumptions.

---

# 18. Success Criteria

The frontend project will be considered successful when:

- All business workflows from the system design are implemented.
- The application runs from a single Flutter codebase.
- Android, iOS, and Web share the same business logic.
- Every screen is responsive across phones, tablets, and desktop browsers.
- The UI remains clean, consistent, and easy to understand.
- Code duplication is minimized through reusable components.
- The project remains maintainable and AI-friendly.
- Backend integration follows the defined API contracts.
- New features can be added without major architectural changes.

---

## MVP (Version 1)

The first production release focuses on replacing the most common daily paper-based workflows.

Included Features

- Authentication
- Forgot Password
- Dashboard
- Worker Management
- Site Management
- Attendance Management
- Expense Management
- Basic Reports
- Profile & Settings

Deferred

- Warehouse
- Purchases
- Driver Operations
- Wallet
- Advanced Reports
- Notifications

---

End of Document
