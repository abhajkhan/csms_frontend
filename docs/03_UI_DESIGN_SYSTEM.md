# 1. Design Philosophy

The Construction Site Management System (CSMS) is an internal business application designed for daily operational use.

The application is used continuously throughout the workday by construction managers, supervisors, warehouse staff, drivers, and administrators.

The design must prioritize efficiency over decoration.

The objective is not to create a visually impressive application.

The objective is to create an application that allows users to complete tasks quickly, accurately, and comfortably.

Every design decision should reduce user effort.

---

Core Design Values

• Simple
• Clean
• Professional
• Consistent
• Fast
• Predictable
• Accessible
• Responsive

---

The interface should feel familiar from the first use.

Users should never need to guess:

• where information is located
• what button performs an action
• how to navigate
• what a field expects

Consistency is more valuable than creativity.

Every screen should look like it belongs to the same application.

---

Primary Goals

Reduce typing.

Reduce scrolling.

Reduce taps.

Reduce mistakes.

Increase readability.

Increase speed.

Increase consistency.

---

The UI should disappear into the background.

Users should focus on their work,
not on understanding the application.

---

# 2. Design Principles

Every screen must follow these principles.

---

1. Clarity

Information must be immediately understandable.

Avoid decorative elements that compete with content.

---

2. Simplicity

Only display information necessary for the current task.

Avoid unnecessary controls.

---

3. Consistency

Spacing

Typography

Buttons

Cards

Dialogs

Tables

Colors

must remain consistent across every screen.

---

4. Readability

Large typography.

High contrast.

Proper spacing.

Short labels.

Clear icons.

---

5. Speed

Frequently used actions should require minimal interaction.

Never force unnecessary navigation.

---

6. Feedback

Every user action should provide immediate feedback.

Loading

Success

Error

Warning

Validation

must always be visible.

---

7. Forgiveness

Users should be able to correct mistakes easily.

Support

Undo

Confirmation

Validation

instead of silent failures.

---

8. Responsiveness

The same experience should exist on

Android

iPhone

Tablet

Web

Only layout changes.

Behavior remains identical.

---

# 3. Brand Personality

The application should communicate professionalism.

It should feel like software built for work.

Not entertainment.

---

Keywords

Reliable

Professional

Organized

Minimal

Modern

Trustworthy

Efficient

---

Avoid

Playful UI

Decorative graphics

Fancy illustrations

Oversized icons

Bright gradients

Glassmorphism

Neumorphism

Heavy shadows

Complex animations

---

The application should feel calm.

Information should receive more visual attention than decoration.

---

# 4. Visual Style

Visual appearance should remain intentionally minimal.

---

Cards

Flat

Rounded corners

Minimal elevation

---

Background

Clean

Light

Neutral

---

Borders

Thin

Subtle

Consistent

---

Icons

Outlined

Simple

Recognizable

---

Animations

Short

Purposeful

Subtle

---

Whitespace

Generous

Consistent

Predictable

---

Visual Hierarchy

1. Page Title

2. Primary Actions

3. Section Titles

4. Form Content

5. Supporting Information

6. Secondary Actions

7. Metadata

Nothing should compete with the primary task.

---

# 5. Color System

Colors should communicate meaning.

Never decoration.

---

Primary Color

Blue

Used for

Primary Buttons

Selected Items

Links

Focus States

---

Success

Green

Used for

Completed

Approved

Saved

Paid

Verified

---

Warning

Amber

Used for

Pending

Incomplete

Requires Attention

---

Danger

Red

Used for

Delete

Error

Rejected

Insufficient Balance

Inactive

---

Information

Blue

Used for

Tips

Status

Help

---

Neutral

Gray Scale

Backgrounds

Borders

Disabled Controls

Dividers

Metadata

---

Rules

Only one primary color.

Maximum two accent colors on a screen.

Never rely on color alone.

Always pair color with:

Icon

Label

Status text.

---

# 6. Typography

Typography should prioritize readability.

---

Font Family

Use a clean sans-serif font.

Example

Inter

Roboto

SF Pro (iOS)

---

Font Scale

Display

32

Page Title

28

Section Title

22

Card Title

18

Body

16

Table Text

15

Button Text

15

Caption

13

Helper Text

12

---

Rules

Use sentence case.

Avoid ALL CAPS.

Avoid excessive bold text.

Bold should indicate importance.

Not decoration.

Maximum three font weights.

Regular

Medium

SemiBold

Maintain generous line spacing.

---

# 7. Iconography

Icons should improve recognition.

Never replace text.

---

Preferred Style

Outlined

Rounded

Simple

Consistent

---

Sizes

Small

18

Default

20

Large

24

Navigation

24

---

Rules

Every important icon must have a text label.

Do not use icons as decoration.

Do not mix icon styles.

Use one icon family throughout the application.

Icons should communicate actions, not aesthetics.

---

# 8. Spacing System

Spacing follows an 8-point grid.

---

Spacing Scale

4

8

12

16

24

32

40

48

64

---

Page Padding

Mobile

16

Tablet

24

Desktop

32

---

Card Padding

16

---

Section Gap

24

---

Form Field Gap

12

---

Widget Gap

8

---

Dialog Padding

24

---

Rules

Never use arbitrary spacing.

Always use predefined spacing values.

Consistent spacing creates visual rhythm and improves readability.

---

# 9. Grid System

The application uses a responsive grid system.

The grid adapts automatically based on screen size.

---

Mobile

4 Columns

---

Tablet

8 Columns

---

Desktop

12 Columns

---

Content Width

Mobile

Full Width

Tablet

Centered

Maximum 900px

Desktop

Centered

Maximum 1400px

---

Rules

Content should never stretch unnecessarily.

Large empty spaces reduce readability.

Forms should never become excessively wide.

Data tables may use full available width.

Cards should align to the grid whenever possible.

---

# 10. Responsive Breakpoints

Every layout should adapt automatically.

---

Mobile

0 - 599 px

---

Tablet

600 - 1023 px

---

Desktop

1024 px and above

---

Orientation

Portrait

Optimized for forms.

Landscape

Optimized for data viewing.

---

Rules

Never detect specific devices.

Always use available width.

Responsive behavior should depend on screen size,
not operating system.

---

# 11. Layout Rules

Every page follows the same layout hierarchy.

---

App Bar

↓

Page Title

↓

Primary Action

↓

Search & Filters (if applicable)

↓

Main Content

↓

Secondary Actions

---

Content Alignment

Left aligned.

Avoid centered layouts for business forms.

---

Maximum Form Width

600 px

---

Maximum Dialog Width

500 px

---

Dashboard Width

Responsive

Uses available space.

---

Rules

One primary purpose per page.

Avoid multiple unrelated sections.

Keep scrolling predictable.

Group related information together.

---

# 12. Navigation Design

Navigation adapts based on screen size.

---

Mobile

Bottom Navigation

or

Navigation Drawer

---

Tablet

Navigation Rail

---

Desktop

Permanent Sidebar

---

Navigation Rules

Maximum seven primary modules.

Group secondary modules.

Highlight current page.

Navigation should always remain visible on desktop.

Back navigation should be predictable.

Never hide important navigation behind multiple menus.

---

# 13. Page Structure

Every page follows a predictable structure.

---

Header

Contains

Title

Breadcrumb (Desktop)

Primary Action

---

Body

Contains

Cards

Tables

Forms

Charts

Lists

---

Footer

Optional

Pagination

Summary

Actions

---

Rules

Every page should have a clear title.

Users should immediately understand where they are.

Primary actions belong near the top.

Secondary actions belong near related content.

---

# 14. Screen Templates

Every feature should follow one of these templates.

---

Template A

Dashboard

App Bar

↓

Summary Cards

↓

Charts

↓

Recent Activity

---

Template B

CRUD List

App Bar

↓

Search

↓

Filters

↓

Table / Cards

↓

Pagination

---

Template C

Create / Edit Form

App Bar

↓

Form Card

↓

Sections

↓

Save Button

---

Template D

Details Page

Header

↓

Information Cards

↓

Related Records

↓

Actions

---

Template E

Reports

Filters

↓

Summary

↓

Charts

↓

Tables

↓

Export Button

AI-generated screens should always start from one of these templates.

---

# 15. Cards

Cards group related information.

---

Style

Flat

Rounded Corners

Minimal Shadow

---

Padding

16 px

---

Spacing Between Cards

16 px

---

Card Structure

Title

↓

Optional Subtitle

↓

Content

↓

Actions

---

Rules

Avoid nested cards.

One topic per card.

Cards should not become excessively long.

Split large information into multiple cards.

---

# 16. Forms

Forms are the primary interaction pattern.

---

Structure

Section Title

↓

Input Fields

↓

Validation

↓

Primary Button

---

Field Order

Most important fields first.

Optional fields last.

---

Grouping

Group related inputs.

Separate groups with spacing.

---

Rules

One column on mobile.

Maximum two columns on desktop.

Labels always above inputs.

Required fields clearly indicated.

Avoid unnecessary scrolling.

---

# 17. Input Components

Inputs should remain consistent.

---

Supported Inputs

Text

Number

Phone

Email

Password

Dropdown

Searchable Dropdown

Checkbox

Radio

Switch

Date Picker

Time Picker

Multiline

---

Input Height

48 px

---

Border Radius

12 px

---

Rules

Always use labels.

Never rely on placeholders.

Validation messages appear below inputs.

Disabled fields remain readable.

Searchable dropdowns for large datasets.

---

# 18. Buttons

Buttons communicate available actions.

---

Primary Button

Filled

Used once per section.

---

Secondary Button

Outlined

Alternative action.

---

Text Button

Low priority actions.

---

Danger Button

Delete

Reset

Permanent actions.

---

Button Height

48 px

---

Border Radius

12 px

---

Rules

Only one primary button in a section.

Avoid icon-only buttons unless universally understood.

Disable buttons while submitting.

Show loading indicator during processing.

---

# 19. Tables

Tables display structured data.

---

Desktop

Data Table

---

Mobile

Cards

---

Features

Sorting

Pagination

Filtering

Searching

Row Selection (when required)

---

Rules

Never display excessive columns on mobile.

Prioritize important information.

Allow horizontal scrolling only when unavoidable.

Maintain consistent column alignment.

---

# 20. Lists

Lists display collections of items.

---

Each Item Contains

Primary Information

Secondary Information

Status

Quick Actions

---

Spacing

12 px

---

Rules

Avoid clutter.

Support search where needed.

Support empty states.

Support loading states.

Large datasets should use pagination or lazy loading.

---

# 21. Dialogs

Dialogs should interrupt the user only when necessary.

---

Use Dialogs For

Confirmation

Delete

Quick Edit

Short Forms

Warnings

---

Do Not Use Dialogs For

Large Forms

Reports

Tables

Complex Workflows

---

Maximum Width

Mobile

Full Screen

Tablet

500 px

Desktop

500 px

---

Structure

Title

↓

Description

↓

Content

↓

Actions

---

Buttons

Primary Action

Secondary Action

---

Rules

Maximum two action buttons.

Primary action on the right.

Dialogs must always have a clear title.

Pressing outside the dialog should only dismiss non-critical dialogs.

Destructive actions require explicit confirmation.

---

# 22. Bottom Sheets

Bottom Sheets are used only on mobile devices.

---

Use Cases

Quick Actions

Filters

Sort Options

Small Forms

Photo Selection

---

Desktop

Use Dialogs instead.

---

Structure

Handle

↓

Title

↓

Content

↓

Actions

---

Rules

Maximum 70% screen height.

Support swipe-to-dismiss for non-critical sheets.

Avoid nested bottom sheets.

One task per bottom sheet.

---

# 23. Date & Time Pickers

Dates and times should never require manual typing unless absolutely necessary.

---

Date Selection

Use native calendar picker.

---

Time Selection

Use native time picker.

---

Date Range

Use dedicated range picker.

---

Quick Options

Today

Yesterday

This Week

This Month

Last Month

---

Rules

Display dates using a consistent format.

Provide clear validation for invalid dates.

Support keyboard input on desktop where appropriate.

---

# 24. Search UI

Search should be available wherever users manage large datasets.

---

Placement

Top of the page.

Above filters.

---

Behavior

Real-time search.

Debounce input.

Minimum delay

300 ms

---

Search Fields

Workers

Sites

Expenses

Items

Drivers

Reports

---

Rules

Search should preserve filters.

Clear button should always be available.

Search state should remain after navigation when appropriate.

---

# 25. Filter UI

Filters reduce visible information.

They should remain simple.

---

Common Filters

Date

Status

Site

Supervisor

Driver

Warehouse

Category

---

Desktop

Horizontal filter bar.

---

Mobile

Bottom Sheet.

---

Rules

Frequently used filters appear first.

Show active filter count.

Provide a "Clear All" option.

Avoid more than six visible filters at once.

---

# 26. Dashboard Design

Dashboards provide a quick operational overview.

---

Layout

Summary Cards

↓

Charts

↓

Recent Activity

↓

Quick Actions

---

Summary Cards

Display one important metric.

Examples

Today's Attendance

Today's Expenses

Wallet Balance

Pending Payments

Warehouse Stock Alerts

---

Rules

Maximum four summary cards per row.

Keep charts simple.

Avoid unnecessary visual decoration.

Prioritize actionable information over historical data.

---

# 27. Charts & Graphs

Charts summarize operational data.

---

Preferred Charts

Bar Chart

Line Chart

Pie Chart (limited use)

Progress Indicator

---

Avoid

3D Charts

Animated Charts

Complex Infographics

---

Rules

Every chart requires:

Title

Legend

Labels

Values

Use consistent colors.

Do not rely solely on color to communicate meaning.

Keep animations subtle.

---

# 28. Status Indicators

Status indicators communicate system state.

---

Common Statuses

Active

Inactive

Pending

Completed

Approved

Rejected

Verified

Unverified

Paid

Unpaid

---

Display

Colored badge

-

Text

-

Optional icon

---

Rules

Never use color alone.

Keep wording short.

Maintain consistent colors across the application.

---

# 29. Tags & Chips

Tags highlight attributes.

---

Examples

Admin

Supervisor

Ajax Driver

Hitachi Driver

Normal Driver

Warehouse

Site

Material

---

Rules

Use concise text.

Avoid more than three chips per item.

Use chips for classification, not actions.

---

# 30. Notifications

Notifications provide immediate feedback.

---

Types

Success

Warning

Error

Information

---

Display

Snackbars

Toasts

Inline Messages

---

Duration

Success

2 seconds

Warning

3 seconds

Error

Until dismissed or acknowledged

---

Rules

Messages should be short.

Explain the problem clearly.

Whenever possible, suggest how to resolve it.

Avoid stacking multiple notifications.

---

# 31. Loading States

Every asynchronous action must communicate progress.

---

Types

Page Loading

Section Loading

Table Loading

Button Loading

Dialog Loading

---

Preferred Indicators

Skeleton Loader

Linear Progress

Circular Progress

---

Rules

Display loading immediately.

Do not freeze the interface.

Disable repeated actions during loading.

Maintain layout stability while content loads.

---

# 32. Empty States

Empty states should guide users.

---

Examples

No Workers

No Attendance

No Expenses

No Reports

No Search Results

---

Structure

Simple Illustration (optional)

↓

Title

↓

Short Description

↓

Primary Action

---

Rules

Avoid blaming the user.

Explain why the list is empty.

Offer a clear next step.

Keep illustrations minimal.

---

# 33. Error States

Errors should be understandable and recoverable.

---

Structure

Error Icon

↓

Title

↓

Description

↓

Retry Button

---

Categories

Network

Permission

Server

Validation

Unknown

---

Rules

Never expose stack traces.

Never display raw API errors.

Always provide a retry option when appropriate.

---

# 34. Success States

Success feedback confirms completed actions.

---

Examples

Worker Added

Attendance Saved

Expense Recorded

Purchase Completed

Payment Updated

---

Display

Snackbar

Success Banner

Dialog (critical actions only)

---

Rules

Keep messages concise.

Avoid interrupting workflow.

Do not require unnecessary confirmations after successful actions.

---

# 35. Animations

Animations should improve usability.

Never entertainment.

---

Purpose

Guide attention.

Confirm actions.

Improve perceived performance.

Provide smooth transitions.

---

Animation Duration

Button Press

120 ms

Page Transition

200 ms

Dialog

180 ms

Bottom Sheet

220 ms

Snackbar

200 ms

Loading

Continuous

---

Animation Curve

easeOutCubic

---

Allowed Animations

Fade

Slide

Scale (small)

Opacity

Expansion

---

Avoid

Bounce

Rotation

Flash

Elastic

Large Hero animations

Complex chained animations

---

Rules

Animations should never delay user interaction.

Keep transitions subtle.

Reduce motion where accessibility settings require it.

---

# 36. Responsive Adaptations

Layouts should adapt naturally to available space.

Business logic must never change.

---

Mobile

Single Column

Bottom Navigation

Cards

Full Width Forms

---

Tablet

Two Columns

Navigation Rail

Larger Dialogs

Side-by-side Cards

---

Desktop

Sidebar Navigation

Data Tables

Resizable Content

Multi-column Layouts

Keyboard Support

---

Responsive Rules

Never duplicate screens.

Reuse the same widgets.

Only layout changes.

Forms should remain easy to complete on every screen size.

Large monitors should not produce excessively wide forms.

---

# 37. Accessibility

The application should remain usable by everyone.

---

Touch Targets

Minimum

48 x 48 dp

---

Contrast

High contrast between text and background.

Avoid low-contrast combinations.

---

Typography

Minimum body text

16 px

---

Icons

Always paired with text for important actions.

---

Forms

Labels always visible.

Validation messages clearly explained.

Keyboard navigation supported on desktop.

---

Screen Readers

Buttons

Inputs

Icons

Images

must include semantic labels where appropriate.

---

Rules

Never communicate information using color alone.

Support text scaling without breaking layouts.

---

# 38. UX Rules

Every interaction should minimize user effort.

---

Navigation

Maximum three taps to reach common tasks.

---

Typing

Reduce typing whenever possible.

Prefer:

Dropdowns

Date Pickers

Auto-complete

Searchable Selectors

---

Scrolling

Avoid excessive scrolling.

Split long forms into logical sections.

---

Feedback

Every action receives immediate feedback.

Loading

Success

Warning

Error

---

Consistency

Buttons remain in consistent locations.

Dialogs behave consistently.

Navigation remains predictable.

---

Mistakes

Prevent mistakes before they happen.

Validate early.

Confirm destructive actions.

Support recovery whenever possible.

---

# 39. AI UI Rules

Every AI-generated screen must follow these rules.

---

Never invent a new page layout.

Use existing screen templates.

---

Never invent new spacing values.

Use the spacing system.

---

Never invent new colors.

Use the color system.

---

Never hardcode font sizes.

Use typography tokens.

---

Never duplicate widgets.

Reuse shared components.

---

Never create inconsistent buttons.

Use shared button widgets.

---

Never create inconsistent forms.

Reuse form components.

---

Never implement custom dialogs.

Use shared dialogs.

---

Never place business logic inside widgets.

Widgets display data only.

---

Every screen must be responsive.

Every screen must compile without layout overflow.

Every screen should visually match the existing application.

---

# 40. Screen Review Checklist

Every new screen should pass this checklist before completion.

---

Layout

✓ Uses approved screen template

✓ Responsive

✓ Correct spacing

✓ Correct typography

---

Components

✓ Shared widgets used

✓ Correct buttons

✓ Correct forms

✓ Correct dialogs

---

UX

✓ Easy to understand

✓ Minimal scrolling

✓ Minimal typing

✓ Logical navigation

---

Feedback

✓ Loading state

✓ Success state

✓ Error state

✓ Empty state

---

Accessibility

✓ Touch targets

✓ Contrast

✓ Labels

✓ Keyboard support

---

Performance

✓ No unnecessary rebuilds

✓ Responsive layout

✓ Optimized widgets

---

Architecture

✓ No business logic in UI

✓ Uses providers

✓ Uses repositories

✓ Follows feature structure

---

Consistency

✓ Matches design system

✓ Matches navigation

✓ Matches typography

✓ Matches color system

---

# 41. UI Do's & Don'ts

## Do

✓ Keep layouts simple.

✓ Prioritize readability.

✓ Use consistent spacing.

✓ Use reusable widgets.

✓ Group related information.

✓ Show clear feedback.

✓ Minimize typing.

✓ Design mobile first.

✓ Make every screen responsive.

✓ Keep forms short.

✓ Use meaningful icons.

✓ Follow existing patterns.

---

## Don't

✗ Don't use gradients.

✗ Don't use glassmorphism.

✗ Don't use neumorphism.

✗ Don't use oversized shadows.

✗ Don't use bright decorative colors.

✗ Don't create new button styles.

✗ Don't invent new page layouts.

✗ Don't hardcode dimensions.

✗ Don't hide important actions.

✗ Don't overload pages with information.

✗ Don't use animations without purpose.

✗ Don't rely on icons without labels.

✗ Don't nest scrolling views unnecessarily.

✗ Don't duplicate UI components.

✗ Don't sacrifice usability for visual effects.

---

The interface should always feel calm, predictable, and professional.

The design should help users complete work quickly, not impress them with visual effects.

When in doubt, choose the simpler solution.

---

# Final Design Principles

This design system exists to ensure that every screen in the Construction Site Management System feels like part of one unified application.

The goal is consistency, not novelty.

Users should never need to relearn the interface when moving between modules.

Every page should prioritize:

• Simplicity

• Readability

• Speed

• Consistency

• Accessibility

• Responsiveness

The frontend should remain minimal, professional, and efficient across Android, iOS, and Web.

Design decisions should always support operational productivity rather than visual decoration.

When multiple valid design options exist, prefer the one that reduces cognitive effort and allows users to complete tasks with fewer interactions.

---
