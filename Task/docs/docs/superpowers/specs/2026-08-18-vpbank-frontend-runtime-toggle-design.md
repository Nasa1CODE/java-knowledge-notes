# VPBank Frontend Runtime Toggle

## Purpose

Allow each frontend deployment to show or hide the VPBank lending entry point through its runtime application configuration.

## Scope

- Add `enableVPBankLending` to development and production runtime configuration files, defaulting to `false`.
- Load the value into `AppConsts` while the application bootstraps.
- Include the VPBank lending menu only when the value is `true`.

## Behavior

- `true`: users see the existing `Quản lý vay VPBank` navigation item.
- `false`, missing, or non-boolean: the navigation item is hidden.
- The VPBank route and backend API remain available; direct links and active sessions are not blocked.

## Verification

- Test that configuration defaults safely to hidden and that the menu is conditionally created.
- Run the frontend lint or build command available to the Angular project.
