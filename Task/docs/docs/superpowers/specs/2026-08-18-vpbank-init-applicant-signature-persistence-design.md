# VPBank Init Applicant Signature Persistence

## Purpose

Persist the VPBank signature returned by a successful `InitApplicant` response so that `GetOpenAccountIframeUrl` can reconstruct the authenticated VPBank iframe URL.

## Scope

- In `AcceptTermsAndAnalyzeInvoices`, after VPBank returns `SUCCESS`, select the most recent lending application for the current enterprise tax code.
- Update that application with the response signature, generated iframe URL, appraisal OD amount, and request ID.
- Preserve the existing integration log behavior.

## Data Flow

1. Invoice analysis uploads eligible XML files and calls VPBank `InitApplicant`.
2. A successful response provides `Signature` and `AppraisalOdAmount`.
3. The service builds the iframe URL and persists these values to the enterprise's latest lending application.
4. `GetOpenAccountIframeUrl` reads the persisted signature and builds the same URL after a later page visit.

## Error Handling

- Signature persistence is part of a successful application initialization. A persistence error is allowed to propagate so the request is not reported as fully successful when later iframe reopening would fail.
- No new lending application is created when no existing application exists; the normal lending-info synchronization remains responsible for creating applications.

## Verification

- Add tests covering a successful initialization with an existing lending application and asserting signature, iframe URL, appraisal amount, and request ID are stored.
- Build the affected ASP.NET solution or project.
