# Frontend Angular Build Ignore Design

## Scope

Stop versioning generated output under `frontend_angular/build/`. The directory remains available locally for build and deployment workflows.

## Approach

Keep the existing `/build` rule in `frontend_angular/.gitignore`. Remove all currently tracked `build/` files from the Git index with `git rm -r --cached build`; this operation does not delete local files.

## Verification

Confirm that `git status --short` reports staged removals for tracked `build/` files, retains no modifications beneath `build/`, and leaves unrelated untracked feature documentation unchanged.

## Constraints

Do not edit generated output, application source, or unrelated files. This change is intentionally limited to Git tracking behavior; a separate commit can be made only when requested.
