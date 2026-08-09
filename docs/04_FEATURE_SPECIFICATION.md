# 1. Document Overview

This document defines every functional module of the Construction Site Management System (CSMS).

It serves as the primary implementation guide for frontend development.

Every feature described in this document should be implemented according to:

• 01_PROJECT.md

• 02_FLUTTER_ARCHITECTURE.md

• 03_UI_DESIGN_SYSTEM.md

This document defines:

• Purpose

• User Roles

• Pages

• User Interface

• Fields

• Validation Rules

• Business Rules

• Navigation

• API Integration

---

Goals

Maintain consistent implementation.

Reduce ambiguity.

Provide a single source of truth for every module.

Support AI-assisted development.

---

Out of Scope

Backend implementation.

Database schema.

Business logic implementation.

Deployment.

These are handled by the backend project.

---

# Feature Template

1. Overview

2. Purpose

3. Available Roles

4. Navigation

5. Pages

6. UI Components

7. Fields

8. Validation Rules

9. Business Rules

10. User Actions

11. API Requirements

12. Success States

13. Error States

14. Future Improvements

---

# 3. Application Modules

The application is divided into the following functional modules.

---

1 Authentication

2 Dashboard

3 User Management

4 Worker Management

5 Site Management

6 Attendance

7 Warehouse

8 Purchase Management

9 Expense Management

10 Driver Operations

11 Wallet & Payments

12 Reports

13 Settings

---

Each module is independent.

Each module owns:

Pages

Controllers

Providers

Repositories

Widgets

Routes

Models

State

---

# 4. Authentication

## Purpose

Authenticate users securely and provide account recovery before allowing access to the system.

---

Available Roles

All Users

---

Pages

• Login

• Forgot Password

---

Navigation

App Launch

↓

Login

├── Login Success → Dashboard

└── Forgot Password → OTP Verification → Reset Password → Login

---

## Login Screen

### Purpose

Authenticate users using their registered credentials.

### UI Components

Logo

Welcome Message

Username / Phone Field

Password Field

Show Password Toggle

Forgot Password Button

Login Button

Loading Indicator

### Fields

Username / Phone

Password

### Validation

Username Required

Password Required

Minimum Password Length

### User Actions

Login

Show Password

Navigate to Forgot Password

Logout

### Business Rules

Only active users can log in.

Only authenticated users can access protected screens.

JWT Access Token is stored securely.

Expired sessions redirect to Login.

User role determines accessible modules after login.

### Success

Navigate to Dashboard.

### Errors

Invalid Credentials

Inactive User

Network Error

Server Error

---

## Forgot Password Screen

### Purpose

Allow users to securely reset their account password.

### UI Components

Phone Number Field

Send OTP Button

OTP Input

New Password Field

Confirm Password Field

Reset Password Button

Resend OTP Button

Loading Indicator

### Fields

Phone Number

OTP

New Password

Confirm Password

### Validation

Registered Phone Required

Valid OTP Required

OTP Expiry Check

Password Policy

Passwords Must Match

### User Actions

Request OTP

Resend OTP

Verify OTP

Reset Password

Return to Login

### Business Rules

OTP is sent only to registered users.

OTP expires after configurable duration.

OTP can be resent after cooldown.

OTP becomes invalid after successful password reset.

New password must satisfy password policy.

After successful reset, redirect user to Login.

### Success

Password updated successfully.

Navigate to Login.

### Errors

User Not Found

Invalid OTP

Expired OTP

Passwords Do Not Match

Network Error

Server Error

---

# 5. Dashboard

## Purpose

Provide a quick overview of daily operations.

---

Available Roles

Admin

---

Pages

Dashboard

---

Widgets

Summary Cards

Charts

Recent Activity

Quick Actions

---

Summary Cards

Today's Attendance

Today's Expenses

Wallet Balance

Pending Purchases

Warehouse Alerts

---

Quick Actions

Add Attendance

Add Expense

Create Purchase

View Reports

---

Business Rules

Dashboard data loads after login.

Widgets depend on user role.

---

Future

Custom Dashboard

Saved Widgets

Notifications

---

# 6. User Management

## Purpose

Manage system users and their permissions.

---

Available Roles

Admin

---

Pages

User List

User Details

Create User

Edit User

---

UI Components

Search

Filters

User Table

Role Badge

Status Badge

Action Menu

---

Fields

Name

Phone

Username

Role

Status

Password

---

Validation

Required Fields

Unique Username

Valid Phone Number

---

User Actions

Create

Update

Activate

Deactivate

Search

Filter

---

Business Rules

Only Admin manages users.

Users cannot delete themselves.

Inactive users cannot log in.

---

Future

Activity History

---

# 7. Worker Management

## Purpose

Manage construction workers.

---

Available Roles

Admin

Supervisor

---

Pages

Worker List

Worker Details

Create Worker

Edit Worker

---

UI Components

Search

Filters

Cards (Mobile)

Table (Desktop)

---

Fields

Worker Name

Phone

Address

Skill

Daily Wage

Status

Assigned Site

---

Validation

Required Name

Positive Wage

Valid Phone

---

User Actions

Create

Edit

Assign Site

Deactivate

Search

---

Business Rules

Inactive workers cannot be assigned.

Workers belong to one active site at a time.

---

Future

Photo

Documents

Attendance History

---

# 8. Site Management

## Purpose

Manage construction sites and assign resources.

---

Available Roles

Admin

Supervisor

---

Pages

Site List

Site Details

Create Site

Edit Site

---

UI Components

Search

Filters

Site Cards (Mobile)

Data Table (Desktop)

Status Badge

Action Menu

---

Fields

Site Name

Site Code

Location

Address

Supervisor

Start Date

Expected End Date

Status

Description

---

Validation

Site Name Required

Supervisor Required

Valid Dates

Unique Site Code

---

User Actions

Create Site

Update Site

View Site

Assign Supervisor

Activate

Deactivate

Search

Filter

---

Business Rules

Each site has one active supervisor.

Inactive sites cannot receive new attendance.

Inactive sites cannot receive purchases.

Completed sites become read-only except for reports.

---

Success

Site saved successfully.

---

Errors

Duplicate Site Code

Missing Required Fields

Invalid Date

---

Future

GPS Location

Map View

Site Photos

Project Documents

---

# 9. Attendance Management

## Purpose

Record and monitor daily worker attendance.

---

Available Roles

Admin

Supervisor

---

Pages

Attendance Dashboard

Daily Attendance

Attendance History

Worker Attendance Details

---

UI Components

Date Picker

Site Selector

Worker List

Attendance Status Chips

Summary Card

Search

Filters

---

Fields

Attendance Date

Site

Worker

Attendance Status

Remarks

---

Attendance Status

Present

Absent

Half Day

Leave

---

Validation

Date Required

Worker Required

Site Required

Valid Status

---

User Actions

Mark Attendance

Update Attendance

Search

Filter

View History

---

Business Rules

One attendance record per worker per day.

Attendance cannot be duplicated.

Attendance allowed only for active workers.

Attendance allowed only for active sites.

Attendance history remains immutable after approval (future).

---

Dashboard Summary

Present

Absent

Half Day

Leave

Total Workers

---

Success

Attendance recorded successfully.

---

Errors

Duplicate Attendance

Worker Not Assigned

Inactive Worker

Invalid Date

---

Future

Bulk Attendance

QR Attendance

Biometric Integration

Offline Attendance

---

# 10. Warehouse Management

## Purpose

Manage warehouse inventory and stock movement.

---

Available Roles

Admin

Supervisor

---

Pages

Warehouse Dashboard

Item List

Item Details

Add Item

Edit Item

Stock History

---

UI Components

Search

Filters

Inventory Table

Low Stock Badge

Category Filter

Stock Cards

---

Fields

Item Name

Item Code

Category

Unit

Current Quantity

Minimum Quantity

Purchase Price

Supplier

Description

---

Validation

Required Name

Unique Item Code

Positive Quantity

Positive Price

---

User Actions

Add Item

Update Item

Receive Stock

Issue Stock

Adjust Quantity

Search

Filter

---

Business Rules

Stock cannot become negative.

Every stock movement is recorded.

Item code must remain unique.

Low stock alert appears automatically.

Inactive items cannot receive transactions.

---

Dashboard

Total Items

Available Stock

Low Stock

Recently Updated Items

---

Success

Inventory updated successfully.

---

Errors

Insufficient Stock

Duplicate Item Code

Invalid Quantity

---

Future

Barcode Scanner

QR Labels

Multiple Warehouses

Supplier Management

---

# 11. Purchase Management

## Purpose

Record purchases made for construction sites and warehouse inventory.

---

Available Roles

Admin

Supervisor

---

Pages

Purchase List

Purchase Details

Create Purchase

Edit Purchase

---

UI Components

Supplier Selector

Site Selector

Item Selector

Purchase Form

Summary Card

Search

Filters

---

Fields

Purchase Number

Purchase Date

Supplier

Site

Items

Quantity

Unit Price

Total Amount

Payment Status

Remarks

---

Validation

Purchase Date Required

Supplier Required

At Least One Item

Positive Quantity

Positive Price

---

User Actions

Create Purchase

Update Purchase

View Details

Search

Filter

---

Business Rules

Purchase number generated automatically.

Every purchase updates warehouse stock.

Purchase cannot be deleted after confirmation.

Total amount calculated automatically.

---

Purchase Summary

Items Purchased

Total Quantity

Total Amount

Pending Payments

---

Success

Purchase created successfully.

---

Errors

Invalid Quantity

Missing Supplier

Duplicate Submission

---

Future

Purchase Approval

Purchase Attachments

Supplier Invoices

GST Support

Purchase Orders

---

# 12. Expense Management

## Purpose

Record and manage all construction-related expenses.

---

Available Roles

Admin

Supervisor

---

Pages

Expense List

Expense Details

Create Expense

Edit Expense

---

UI Components

Search

Filters

Expense Table

Expense Cards

Category Selector

Site Selector

Date Picker

---

Fields

Expense Date

Site

Category

Description

Amount

Payment Method

Paid By

Remarks

---

Common Categories

Labour

Material

Fuel

Vehicle

Food

Equipment

Miscellaneous

---

Validation

Date Required

Category Required

Positive Amount

Description Required

---

User Actions

Create Expense

Update Expense

View Details

Search

Filter

---

Business Rules

Amount must be greater than zero.

Expenses belong to one site.

Expenses become read-only after approval (future).

Total expense calculated automatically in reports.

---

Dashboard

Today's Expenses

Monthly Expenses

Site-wise Expenses

Category-wise Expenses

---

Success

Expense recorded successfully.

---

Errors

Invalid Amount

Missing Required Fields

---

Future

Receipt Upload

Expense Approval

Recurring Expenses

GST Support

---

# 13. Driver Operations

## Purpose

Manage daily work performed by construction vehicle drivers.

---

Available Roles

Admin

Supervisor

Ajax Driver

Hitachi Driver

Normal Driver

---

Pages

Driver Dashboard

Daily Work Entry

Work History

Vehicle Details

---

Driver Types

Ajax Driver

Hitachi Driver

Normal Driver

---

UI Components

Date Picker

Site Selector

Vehicle Selector

Work Form

History List

---

Fields

Driver

Vehicle

Site

Date

Working Hours

Trip Count

Fuel Used

Remarks

---

Validation

Driver Required

Vehicle Required

Site Required

Positive Working Hours

---

User Actions

Submit Daily Work

Update Entry

View History

---

Business Rules

Drivers can only manage their own records.

Supervisors can view site records.

Admins can access all records.

One work entry per driver per day.

---

Dashboard

Today's Trips

Working Hours

Fuel Usage

Recent Entries

---

Success

Work log submitted successfully.

---

Errors

Duplicate Entry

Inactive Vehicle

Invalid Hours

---

Future

GPS Tracking

Fuel Integration

Maintenance Records

Trip Analytics

---

# 14. Wallet & Payments

## Purpose

Track cash flow, balances, and payment history.

---

Available Roles

Admin

Supervisor

---

Pages

Wallet Dashboard

Transactions

Payment History

Transfer Details

---

UI Components

Balance Card

Transaction Table

Filters

Summary Cards

Date Range

---

Fields

Transaction Date

Transaction Type

Amount

Site

Reference

Description

Balance

---

Transaction Types

Credit

Debit

Transfer

Purchase Payment

Expense Payment

---

Validation

Positive Amount

Transaction Type Required

Date Required

---

User Actions

View Transactions

Record Payment

Transfer Amount

Search

Filter

---

Business Rules

Balance updates automatically.

Negative balance not allowed.

Every transaction recorded permanently.

Payments linked to purchases or expenses.

---

Dashboard

Current Balance

Today's Transactions

Credits

Debits

---

Success

Transaction recorded successfully.

---

Errors

Insufficient Balance

Invalid Amount

Duplicate Transaction

---

Future

Bank Integration

Online Payments

Multi-wallet Support

Audit Trail

---

# 15. Reports

## Purpose

Provide operational and financial insights.

---

Available Roles

Admin

Supervisor

---

Pages

Reports Dashboard

Attendance Reports

Expense Reports

Purchase Reports

Warehouse Reports

Driver Reports

Wallet Reports

---

UI Components

Date Filters

Site Filters

Charts

Tables

Summary Cards

Export Button

---

Available Reports

Daily

Weekly

Monthly

Custom Range

---

Export Formats

PDF

Excel

CSV

---

Business Rules

Reports are generated from backend data.

Large reports should use server-side pagination.

Filters remain applied until cleared.

---

Dashboard

Key Metrics

Trend Charts

Top Expenses

Attendance Summary

Inventory Summary

---

Success

Report generated successfully.

---

Errors

No Data Available

Invalid Date Range

Server Error

---

Future

Scheduled Reports

Email Reports

Saved Filters

Interactive Charts

---

# 16. Settings

## Purpose

Configure application preferences and account settings.

---

Available Roles

All Users

---

Pages

Profile

Change Password

Application Settings

About

---

UI Components

Settings List

Profile Card

Switches

Dialogs

---

Sections

Profile

Security

Appearance

Notifications (Future)

Application Information

---

User Actions

Update Profile

Change Password

Logout

View App Version

---

Validation

Required Fields

Password Rules

Phone Validation

---

Business Rules

Users may edit only their own profile.

Only Admin can modify system-wide settings (future).

Sensitive actions require authentication.

---

Success

Settings updated successfully.

---

Errors

Incorrect Password

Validation Error

Network Error

---

Future

Dark Mode

Language Selection

Notification Preferences

Biometric Lock

---

# 17. Future Modules

The following modules are intentionally excluded from the initial release.

• Notifications

• File Management

• Document Repository

• GPS Tracking

• QR Attendance

• Barcode Scanning

• Offline Synchronization

• Multi-company Support

• Multi-language Support

• Push Notifications

• Audit Logs

• Analytics Dashboard

These features should be implemented without affecting the existing architecture.

---

# 18. Feature Dependencies

The following diagram illustrates how modules interact.

Authentication
│
▼
Dashboard
│
├───────────────┐
▼ ▼
User Management Site Management
│ │
▼ ▼
Worker Management ──────┘
│
▼
Attendance
│
├───────────────┐
▼ ▼
Purchases Driver Operations
│ │
▼ ▼
Warehouse Expenses
│ │
└──────┬────────┘
▼
Wallet & Payments
│
▼
Reports
│
▼
Settings

---

# 19. Release Plan

## Release 1.0 (MVP)

The first production release focuses on replacing the daily paper-based workflows used by supervisors.

Included Features

✓ Authentication

✓ Forgot Password

✓ Dashboard

✓ User Management

✓ Worker Management

✓ Site Management

✓ Attendance Management

✓ Expense Management

✓ Basic Reports (Attendance & Expenses)

✓ Profile & Settings

---

## Release 1.1

Additional operational modules.

✓ Warehouse Management

✓ Purchase Management

---

## Release 1.2

Vehicle and driver operations.

✓ Driver Operations

✓ Driver Reports

---

## Release 1.3

Financial management.

✓ Wallet & Payments

✓ Financial Reports

---

## Release 1.4

Application improvements.

✓ Performance Optimization

✓ UI/UX Improvements

✓ Bug Fixes

✓ Security Enhancements

✓ Additional Reports

✓ Refactoring

---

# 20. Development Guidelines

Every feature must follow the established project standards.

---

Architecture

• Follow 02_FLUTTER_ARCHITECTURE.md

---

UI

• Follow 03_UI_DESIGN_SYSTEM.md

---

Implementation

• Build one feature at a time.

• Complete one module before starting another.

• Keep business logic inside controllers and repositories.

• Reuse shared widgets whenever possible.

• Maintain responsive layouts across Android, iOS, and Web.

---

Quality Checklist

✓ Responsive

✓ Accessible

✓ Consistent

✓ Tested

✓ Uses shared components

✓ Uses shared providers

✓ No duplicated code

✓ Follows project architecture

---

The goal is a maintainable, scalable, and consistent application where every module behaves as part of one unified system.

---

# Appendix A. Complete Screen Inventory

The following screens constitute Version 1.0 of CSMS.

---

Authentication

• Login

---

Dashboard

• Dashboard

---

User Management

• User List

• User Details

• Create User

• Edit User

---

Worker Management

• Worker List

• Worker Details

• Create Worker

• Edit Worker

---

Site Management

• Site List

• Site Details

• Create Site

• Edit Site

---

Attendance

• Daily Attendance

• Attendance History

• Worker Attendance

---

Warehouse

• Inventory Dashboard

• Item List

• Item Details

• Create Item

• Edit Item

• Stock History

---

Purchases

• Purchase List

• Purchase Details

• Create Purchase

• Edit Purchase

---

Expenses

• Expense List

• Expense Details

• Create Expense

• Edit Expense

---

Driver Operations

• Driver Dashboard

• Daily Work Entry

• Work History

---

Wallet

• Wallet Dashboard

• Transactions

• Payment History

---

Reports

• Reports Dashboard

• Attendance Report

• Expense Report

• Purchase Report

• Warehouse Report

• Driver Report

---

Settings

• Profile

• Change Password

• App Settings

• About

---

# Appendix B. Shared Components

Every feature should reuse the shared component library.

---

Buttons

AppPrimaryButton

AppSecondaryButton

AppTextButton

---

Inputs

AppTextField

AppNumberField

AppDropdown

AppSearchField

AppDatePicker

AppTimePicker

---

Cards

SummaryCard

InfoCard

StatisticCard

---

Lists

ResponsiveList

ResponsiveTable

---

Dialogs

ConfirmationDialog

DeleteDialog

LoadingDialog

---

Feedback

LoadingWidget

ErrorWidget

EmptyWidget

SuccessSnackbar

---

Navigation

BottomNavigation

NavigationRail

DesktopSidebar

---

Layout

ResponsivePage

ResponsiveGrid

SectionContainer

PageHeader

---

# Appendix C. Development Status

| Module         | Status |
| -------------- | ------ |
| Authentication | ☐      |
| Dashboard      | ☐      |
| Users          | ☐      |
| Workers        | ☐      |
| Sites          | ☐      |
| Attendance     | ☐      |
| Warehouse      | ☐      |
| Purchases      | ☐      |
| Expenses       | ☐      |
| Drivers        | ☐      |
| Wallet         | ☐      |
| Reports        | ☐      |
| Settings       | ☐      |

Update this table after completing every feature.

---

# Appendix D. Definition of Done

A feature is considered complete only when all of the following conditions are satisfied.

---

Functionality

☐ Feature implemented

☐ CRUD completed

☐ Validation completed

☐ Error handling completed

---

Architecture

☐ Uses Riverpod

☐ Uses Repository

☐ Uses DTO

☐ Uses Models

☐ Uses Shared Widgets

---

UI

☐ Responsive

☐ Follows Design System

☐ Loading States

☐ Empty States

☐ Error States

☐ Success Feedback

---

Quality

☐ No layout overflow

☐ No analyzer warnings

☐ No duplicated widgets

☐ Proper naming

☐ Responsive on Android

☐ Responsive on iPhone

☐ Responsive on Web

---

API

☐ Connected to Backend

☐ Proper Error Mapping

☐ Proper Validation

☐ Loading Indicators

---

Testing

☐ Manual Testing Completed

☐ Edge Cases Checked

☐ Navigation Verified

---

Documentation

☐ Feature checklist updated

☐ Roadmap updated

---

# Appendix E. Recommended Development Order

Sprint 1

Authentication

Dashboard

Navigation

---

Sprint 2

Users

Workers

Sites

---

Sprint 3

Attendance

Warehouse

Purchases

---

Sprint 4

Expenses

Drivers

Wallet

---

Sprint 5

Reports

Settings

---

Sprint 6

Testing

Refactoring

Bug Fixes

Performance Optimization

---

# Appendix F. Standard AI Prompt

Before implementing any feature, read:

01_PROJECT.md

02_FLUTTER_ARCHITECTURE.md

03_UI_DESIGN_SYSTEM.md

04_FEATURE_SPECIFICATION.md

Then implement exactly one feature.

Requirements

• Follow Flutter Architecture.

• Follow UI Design System.

• Use Riverpod.

• Use GoRouter.

• Use Repository Pattern.

• Build responsive layouts.

• Reuse shared widgets.

• Do not create unnecessary abstractions.

• Do not hardcode values.

• Produce production-quality code.

Complete the feature before moving to the next one.

---

# Appendix G – MVP Scope

## Objective

The goal of Version 1.0 (MVP) is to deliver a stable, production-ready application that replaces the daily paper-based workflow used by construction site supervisors.

The MVP should allow supervisors to:

- Log into the application.
- Recover their password.
- View assigned sites.
- Manage workers.
- Mark daily attendance.
- Record daily expenses.
- View basic reports.

Features outside this scope must not be implemented during the MVP.

---

## Included Modules

### Authentication

Status: MVP

Features

✓ Login

✓ Forgot Password

✓ JWT Authentication

✓ Secure Token Storage

✓ Auto Login

✓ Logout

---

### Dashboard

Status: MVP

Features

✓ Dashboard Summary

✓ Quick Actions

✓ Recent Activity

---

### User Management

Status: MVP

Features

✓ User List

✓ Create User

✓ Edit User

✓ Activate / Deactivate User

---

### Worker Management

Status: MVP

Features

✓ Worker List

✓ Worker Details

✓ Create Worker

✓ Edit Worker

✓ Activate / Deactivate Worker

---

### Site Management

Status: MVP

Features

✓ Site List

✓ Site Details

✓ Create Site

✓ Edit Site

✓ Assign Supervisor

---

### Attendance Management

Status: MVP

Features

✓ Daily Attendance

✓ Attendance History

✓ Worker Attendance Details

---

### Expense Management

Status: MVP

Features

✓ Expense List

✓ Add Expense

✓ Edit Expense

✓ Expense Details

---

### Reports

Status: MVP

Features

✓ Attendance Report

✓ Expense Report

✓ Export PDF

✓ Export Excel

---

### Settings

Status: MVP

Features

✓ User Profile

✓ Change Password

✓ Logout

---

## Deferred Modules

The following modules are intentionally excluded from Version 1.0.

### Warehouse Management

Deferred to Release 1.1

### Purchase Management

Deferred to Release 1.1

### Driver Operations

Deferred to Release 1.2

### Wallet & Payments

Deferred to Release 1.3

---

## MVP Quality Requirements

Every MVP feature must satisfy the following requirements before being considered complete.

### Functionality

✓ Business requirements implemented

✓ CRUD operations completed (where applicable)

✓ Validation implemented

✓ Error handling completed

---

### Architecture

✓ Feature-first architecture

✓ Riverpod state management

✓ Repository Pattern

✓ DTO mapping

✓ Shared widgets

✓ Responsive layout

---

### User Experience

✓ Mobile responsive

✓ Tablet responsive

✓ Web responsive

✓ Loading states

✓ Empty states

✓ Error states

✓ Success feedback

---

### Code Quality

✓ No analyzer warnings

✓ No duplicated code

✓ Proper naming conventions

✓ Clean folder structure

✓ Reusable components

---

### API

✓ Uses backend API only

✓ No hardcoded data (except temporary mock data when explicitly allowed)

✓ Proper error mapping

✓ Authentication handled correctly

---

## Implementation Rules

During MVP development, AI agents must follow these rules:

1. Implement only one feature at a time.

2. Complete the feature before moving to the next.

3. Follow the architecture defined in
   `02_FLUTTER_ARCHITECTURE.md`.

4. Follow the UI rules defined in
   `03_UI_DESIGN_SYSTEM.md`.

5. Follow the feature specification defined in
   `04_FEATURE_SPECIFICATION.md`.

6. Do not implement deferred modules.

7. Do not add extra functionality that is not documented.

8. Reuse existing shared widgets whenever possible.

9. Keep business logic inside controllers and repositories.

10. Produce production-quality Flutter code suitable for Android, iOS and Web.
