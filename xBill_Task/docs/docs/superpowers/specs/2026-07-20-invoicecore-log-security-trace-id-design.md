# Invoicecore Log Security and Trace ID Design

## Goal

For `CBCLOUDV2-8307`, prevent credentials from appearing in `invoicecore` logs and attach a request-level trace ID to host logs for HTTP request troubleshooting.

## Architecture

`VS.Web.Host` will resolve an inbound `X-Trace-Id` header when valid, otherwise generate a GUID. Request middleware sets this value in log4net's logical context and returns it in the response header. The log4net pattern will render the context property for all logs emitted in the request.

The Cyber ID password integration methods will stop logging serialized payloads, password-bearing URLs, raw responses, and tokens. Their replacement messages will retain only endpoint and HTTP status information.

## Compatibility and Boundaries

The change is host- and logging-only. It does not change Cyber ID requests, API responses, database objects, frontend behavior, queues, or background jobs. The trace ID is not propagated outside a synchronous HTTP request.

## Failure Handling

The trace context is removed in a `finally` block so exceptions cannot leak it to later requests. An invalid client header is replaced with a server-generated GUID instead of rejecting the request.

## Verification

Automated coverage will verify header reuse, generation, response output, and cleanup where practical. Manual checks will prove log correlation and ensure a known password value does not occur in Cyber ID logs. The backend solution will be built before reporting completion.
