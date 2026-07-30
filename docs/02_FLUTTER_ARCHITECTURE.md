# 1. Architecture Overview

The CSMS Frontend is built using Flutter as a single cross-platform application supporting:

- Android
- iOS
- Web

The project follows a Feature-First Clean Architecture optimized for long-term maintainability and AI-assisted development.

The architecture separates business logic from presentation, allowing each layer to evolve independently.

The frontend communicates exclusively with the CSMS Backend REST API.

No business calculations or business rules should exist in the UI layer.

Every feature should be independently maintainable and reusable.

Core Principles

- Single Codebase
- Feature First
- Responsive Design
- Clean Separation of Concerns
- Repository Pattern
- Riverpod State Management
- GoRouter Navigation
- REST API Communication
- Minimal Widget Rebuilds
- Highly Reusable Components
- AI-Friendly Folder Organization

# 2. Architectural Principles

The project follows these architectural principles.

## 2.1 Single Responsibility

Every class should have one responsibility only.

Examples

✓ LoginRepository

Only API communication.

✓ LoginController

Only business logic.

✓ LoginPage

Only UI.

Never mix these responsibilities.

---

## 2.2 Feature First Development

The application is organized by features instead of technical layers.

Correct

features/
login/
dashboard/
workers/
attendance/

Avoid

pages/
controllers/
screens/

This keeps related code together.

---

## 2.3 Reusability

Widgets should never be duplicated.

If a widget is reused more than twice, move it into shared/widgets.

---

## 2.4 Separation of Concerns

UI

Displays information only.

Controller

Processes user actions.

Repository

Communicates with backend.

Service

Contains helper utilities.

Models

Represent data.

---

## 2.5 Responsive by Default

Every screen must support:

Mobile

Tablet

Desktop

Never create separate applications.

---

## 2.6 Backend Driven

The backend is the single source of truth.

Frontend should never recreate business rules.

Calculations always come from backend unless explicitly defined as UI-only behavior.

---

## 2.7 Simplicity First

Always choose the simpler solution.

Avoid unnecessary abstractions.

Avoid over-engineering.

Readable code is preferred over clever code.

---

# 3. Cross Platform Strategy

The application supports:

Android

iPhone

Web

using one Flutter codebase.

Business logic is shared.

Repositories are shared.

Models are shared.

API layer is shared.

Riverpod providers are shared.

Only UI adapts between platforms.

---

Platform Adaptation

Phone

Bottom Navigation

Tablet

Navigation Rail

Desktop/Web

Permanent Sidebar

---

Screen Layout

Phone

Single Column

Tablet

One or Two Columns

Desktop

Multi Column

---

Dialogs

Phone

Full Screen

Tablet/Desktop

Modal Dialog

---

Tables

Phone

Cards

Desktop

DataTable

---

Mouse Support

Desktop

Hover Effects

Right Click

Keyboard Shortcuts

Resizable Tables

---

Touch Support

Large tap targets

Minimum 48dp touch area

---

No platform-specific business logic is allowed.

Platform-specific implementations should only exist for:

File picker

Camera

Image selection

Download handling

Local notifications

Printing

# 4. Project Structure

lib/
│
├── app/
│ ├── app.dart
│ ├── router.dart
│ ├── theme.dart
│ ├── providers.dart
│ └── bootstrap.dart
│
├── core/
│ ├── api/
│ ├── config/
│ ├── constants/
│ ├── errors/
│ ├── exceptions/
│ ├── extensions/
│ ├── network/
│ ├── services/
│ ├── storage/
│ ├── utils/
│ └── widgets/
│
├── shared/
│ ├── components/
│ ├── dialogs/
│ ├── forms/
│ ├── layouts/
│ ├── models/
│ ├── providers/
│ ├── themes/
│ └── widgets/
│
├── features/
│ ├── auth/
│ ├── dashboard/
│ ├── users/
│ ├── workers/
│ ├── attendance/
│ ├── sites/
│ ├── wallet/
│ ├── expenses/
│ ├── warehouse/
│ ├── purchases/
│ ├── drivers/
│ ├── reports/
│ ├── settings/
│ └── profile/
│
├── assets/
│ ├── fonts/
│ ├── icons/
│ └── images/
│
├── l10n/
│
└── main.dart

---

# 5. Layer Responsibilities

The project is divided into logical layers.

---

Presentation Layer

Contains

Pages

Widgets

Dialogs

Forms

Responsive Layouts

Responsibilities

Display data

Collect user input

Navigate

No business logic allowed.

---

Application Layer

Contains

Riverpod Controllers

Providers

Responsibilities

Coordinate UI and Repository

Manage state

Validation

Loading state

Error state

---

Repository Layer

Responsibilities

Call REST APIs

Convert DTOs

Handle caching

Return Models

No UI code allowed.

---

Core Layer

Shared across entire project.

Contains

Networking

Storage

Logger

Theme

Utilities

Config

Exceptions

Extensions

---

Shared Layer

Reusable Widgets

Dialogs

Buttons

Cards

Tables

Inputs

Never place feature-specific widgets here.

---

Feature Layer

Every business module lives inside features/.

Each feature owns:

Pages

Controllers

Repository

Models

Widgets

Routes

Providers

---

# 6. Feature Module Structure

features/
└── workers/
├── data/
│ ├── datasource/
│ ├── dto/
│ ├── mapper/
│ └── repository/
│
├── presentation/
│ ├── controllers/
│ ├── pages/
│ ├── providers/
│ ├── widgets/
│ ├── dialogs/
│ └── states/
│
├── models/
├── routes.dart
└── feature.dart

---

Every feature should follow the exact same structure.

Responsibilities

data/

Communicates with backend.

domain/

Contains business entities and repository contracts.

presentation/

Contains Flutter UI.

routes.dart

Feature-specific routes.

feature.dart

Exports the feature for easier imports.

No feature may directly access another feature's internal files.

Shared functionality must be moved into the shared/ or core/ directories.

Each feature should be independently testable, independently maintainable, and independently extensible.

---

# 7. State Management

Riverpod is the only state management solution used throughout the application.

No other state management libraries are allowed.

## State Categories

### Global State

Shared across the entire application.

Examples

- Logged in user
- Authentication
- Theme
- Language
- Connectivity
- App configuration

Location

shared/providers/

---

### Feature State

Owned by a single feature.

Examples

- Worker List
- Attendance Form
- Expense Entry
- Dashboard Statistics

Location

features/{feature}/presentation/providers/

---

### Local Widget State

Temporary UI state.

Examples

- Password visibility
- Selected tab
- Expansion tile state
- Dialog visibility

Use

StatefulWidget

or

flutter_hooks

Never create Riverpod providers for purely local UI state.

---

## Provider Types

Provider

Read-only dependencies.

StateProvider

Simple values.

FutureProvider

Single API requests.

StreamProvider

Real-time streams (future use).

NotifierProvider

Business logic and mutable state.

AsyncNotifierProvider

Feature controllers making API calls.

---

## Controller Responsibilities

Controllers should:

- Load data
- Validate input
- Call repositories
- Handle loading state
- Handle errors
- Notify UI

Controllers must never contain UI code.

---

# 8. Dependency Injection

The project uses Riverpod as the dependency injection framework.

No service locator (GetIt) is used.

Dependencies are injected using Providers.

Example Dependency Flow

ApiClient
↓

AuthRepository

↓

LoginController

↓

LoginPage

---

Core Dependencies

- Dio Client
- Secure Storage
- Shared Preferences
- Logger
- Connectivity

Feature Dependencies

Each feature owns:

Repository

Controller

Providers

---

Rules

Repositories must never create Dio instances.

Repositories must receive dependencies.

Controllers must never instantiate repositories.

Widgets must never instantiate controllers.

Everything must be injected.

Dependency creation belongs only inside providers.

---

# 9. Navigation

Navigation uses GoRouter.

No Navigator.push() outside GoRouter.

---

Navigation Structure

Public Routes

- Splash
- Login

Protected Routes

- Dashboard
- Workers
- Attendance
- Sites
- Expenses
- Reports
- Settings

---

Role-Based Navigation

Admin

Full access.

Supervisor

Limited modules.

Driver

Driver-specific screens only.

Route guards determine access.

UI should never rely solely on hiding buttons.

---

Nested Navigation

Dashboard

↓

Feature

↓

Details

↓

Edit

---

Navigation Rules

Never hardcode route strings.

Use route constants.

Every feature owns its own routes.

Root router combines feature routers.

Deep linking should work on Web.

---

# 10. Networking Layer

HTTP communication uses Dio.

Every API request flows through:

UI

↓

Controller

↓

Repository

↓

ApiClient

↓

Backend

---

ApiClient Responsibilities

- Base URL
- Headers
- Authentication
- Timeout
- Logging
- Retry
- Error conversion

---

Interceptors

Request

- Authorization Header
- Device Info
- Request Logging

Response

- Success Logging
- Error Handling
- Token Refresh

---

Timeouts

Connection

10 seconds

Receive

30 seconds

Send

30 seconds

---

Rules

Never call Dio directly from UI.

Never expose raw responses.

Repositories always return Models.

Errors are converted into application exceptions.

---

# 11. Repository Pattern

Repositories isolate API communication.

UI never communicates with APIs directly.

---

Repository Responsibilities

- Call endpoints
- Convert DTOs
- Return Models
- Handle pagination
- Handle caching

---

Example

WorkerPage

↓

WorkerController

↓

WorkerRepository

↓

WorkerApi

↓

REST API

---

Repository Rules

One repository per feature.

Repositories contain no widget code.

Repositories contain no navigation.

Repositories contain no BuildContext.

Repositories are reusable.

Controllers coordinate repositories.

Repositories never coordinate controllers.

---

# 12. Domain Models & DTOs

Separate API objects from application models.

---

DTO

Matches backend JSON.

Example

WorkerDto

---

Model

Used by UI.

Example

Worker

---

Mapper

Converts

DTO

↓

Model

and

Model

↓

DTO

---

Benefits

Backend changes affect only DTOs.

UI remains stable.

Repositories always return Models.

Controllers never handle JSON.

---

# 13. Authentication Architecture

Authentication uses JWT.

---

Login Flow

Login Page

↓

Auth Controller

↓

Auth Repository

↓

Backend

↓

JWT Token

↓

Secure Storage

↓

Authenticated User

---

Session Flow

App Launch

↓

Read Token

↓

Validate Session

↓

Navigate

---

Logout

Delete token.

Clear providers.

Clear cache.

Navigate to Login.

---

Rules

Never store passwords.

Never store tokens in SharedPreferences.

Use Secure Storage.

Authentication state must be globally available.

---

# 14. Local Storage

The application stores only lightweight local data.

Business data always comes from the backend.

---

Secure Storage

JWT

Refresh Token

Sensitive settings

---

Shared Preferences

Theme

Language

Last selected filters

Dashboard preferences

---

Cache

Temporary API responses.

Offline data (future).

---

Never Store

Worker database

Attendance history

Expenses

Reports

Wallet balances

The backend remains the source of truth.

---

# 15. Responsive Architecture

Responsive design is mandatory.

Every screen supports:

Phone

Tablet

Desktop

---

Breakpoints

Mobile

0 - 600

Tablet

600 - 1024

Desktop

1024+

---

Layout Strategy

Phone

Single column

Bottom Navigation

Tablet

Navigation Rail

Two-column layouts

Desktop

Permanent Sidebar

Multi-column layouts

Data Tables

---

Rules

Never duplicate pages.

Create reusable responsive widgets.

Business logic must remain identical across all layouts.

Only the presentation layer adapts to screen size.

Responsive widgets belong in:

shared/layouts/

Feature pages consume these layouts rather than implementing device-specific code.

---

# 16. Shared Widget Library

Reusable widgets must live inside:

shared/

Never duplicate UI across features.

---

Shared Components

Buttons

Cards

Dialogs

Text Fields

Dropdowns

Search Fields

Date Pickers

Tables

Loading Indicators

Error Widgets

Confirmation Dialogs

Empty States

App Bars

Navigation Widgets

Responsive Layouts

---

Rules

Feature-specific widgets stay inside the feature.

Generic widgets belong in shared/.

If used by more than two features,
move it to shared/.

Shared widgets must not contain feature-specific business logic.

---

# 17. Theme Architecture

The application uses one centralized theme.

app/theme.dart

---

Theme Includes

Typography

Colors

Spacing

Border Radius

Icons

Input Decoration

Button Styles

Dialog Styles

Card Styles

Table Styles

---

Rules

Never hardcode colors.

Never hardcode font sizes.

Never hardcode spacing.

Always use theme values.

Dark Mode support should remain possible even if not initially implemented.

---

# 18. Error Handling

Errors are handled consistently throughout the application.

---

Error Flow

Backend

↓

Repository

↓

Controller

↓

UI

---

Error Categories

Validation

Authentication

Authorization

Network

Server

Unknown

---

UI Behavior

Validation

Show field errors.

Network

Retry option.

Server

Friendly message.

Authentication

Redirect to Login.

---

Never expose raw backend exceptions to users.

Always display human-readable messages.

---

# 19. Loading States

Every asynchronous operation must have a loading state.

---

Loading Types

Page Loading

Button Loading

Table Loading

List Loading

Dialog Loading

---

Rules

Disable buttons during requests.

Prevent duplicate submissions.

Show progress immediately.

Never freeze the UI.

Use skeleton loaders where appropriate.

Avoid blocking the entire screen unless absolutely necessary.

---

# 20. Form Architecture

Forms are a primary part of the application.

All forms should follow the same architecture.

---

Structure

Form Widget

↓

Controller

↓

Validation

↓

Repository

↓

API

---

Validation

Required fields

Length

Numbers

Dates

Business validation from backend

---

Rules

Never duplicate validators.

Create reusable form fields.

Use controllers only when necessary.

Prefer Form and GlobalKey<FormState>.

Validation messages should be clear and concise.

---

# 21. Search, Filtering & Pagination

Large datasets must support efficient browsing.

---

Search

Debounced

Server-side preferred

---

Filtering

Status

Date

Site

Worker

Driver

Warehouse

---

Pagination

Server-side

Infinite scrolling where appropriate

---

Rules

Never load entire datasets unnecessarily.

Controllers manage paging state.

Repositories expose paginated methods.

Search and filters should survive screen rebuilds.

---

# 22. File Upload Strategy

The architecture supports future file uploads.

Supported

Images

PDF

Documents

---

Upload Flow

Select File

↓

Validate

↓

Compress (if image)

↓

Upload

↓

Receive URL

↓

Save through API

---

Rules

Never store files locally longer than necessary.

Repositories manage uploads.

Controllers report upload progress.

UI displays progress indicators.

---

# 23. Logging & Debugging

Logging should help developers without exposing sensitive data.

---

Log Types

API Requests

API Responses

Navigation

Errors

Authentication

Performance

---

Never Log

Passwords

JWT Tokens

Personal information

Sensitive financial data

---

Debug logging must be disabled in production builds.

---

# 24. Performance Guidelines

Performance is a core architectural requirement.

---

Guidelines

Use const constructors whenever possible.

Avoid unnecessary widget rebuilds.

Split large widgets.

Lazy load lists.

Cache images.

Reuse controllers.

Dispose resources correctly.

Use pagination.

Avoid nested scrolling.

Keep widget trees shallow.

Profile performance before optimization.

---

# 25. Testing Strategy

Testing is divided into four layers.

---

Unit Tests

Repositories

Controllers

Utilities

---

Widget Tests

Forms

Dialogs

Widgets

---

Integration Tests

Authentication

API flows

Navigation

---

Golden Tests

Optional

Responsive layouts

---

Business logic should always be tested before UI.

---

# 26. AI Development Rules

Every AI-generated code change must follow these rules.

Never create duplicate widgets.

Never bypass repositories.

Never bypass controllers.

Never hardcode API URLs.

Never create business logic inside widgets.

Never duplicate models.

Never use BuildContext inside repositories.

Never create singleton services manually.

Follow the existing folder structure.

Reuse existing components before creating new ones.

Every generated code must compile without warnings.

---

# 27. Naming Conventions

Pages

WorkerListPage

Controllers

WorkerController

Repositories

WorkerRepository

Providers

workerProvider

Models

Worker

DTOs

WorkerDto

Mappers

WorkerMapper

Widgets

WorkerCard

Dialogs

WorkerDialog

Extensions

StringExtension

Constants

AppColors

Enums

WorkerStatus

---

# 28. Coding Standards

Follow Effective Dart.

Use lowerCamelCase for variables.

Use UpperCamelCase for classes.

Prefer final over var.

Avoid dynamic.

Avoid deeply nested widgets.

Keep methods under approximately 40 lines.

Keep widgets focused on a single responsibility.

Extract reusable widgets early.

Favor composition over inheritance.

---

# 29. Package Selection Rules

Packages should be stable, well maintained, and cross-platform.

Preferred Packages

Riverpod

GoRouter

Dio

Freezed

Json Serializable

Flutter Secure Storage

Shared Preferences

Intl

Image Picker

File Picker

---

Avoid

Unmaintained packages

Platform-specific packages unless unavoidable

Multiple packages solving the same problem

Experimental packages in production

---

# 30. Future Scalability

The architecture should support future expansion without major restructuring.

Potential Future Features

Offline Mode

Push Notifications

Biometric Authentication

Background Sync

File Attachments

Multi-language Support

Desktop Support

Analytics

Audit Logs

Role Expansion

---

Scalability Principles

Add new features as independent modules.

Do not modify existing modules unless necessary.

Favor extension over modification.

Keep business logic centralized.

Maintain a single Flutter codebase for all supported platforms.

The architecture should remain understandable to both developers and AI coding assistants.

---
