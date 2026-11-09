# CBCLOUDV2-8307 Expect

## Feature Status

- Status: draft
- Class: Small

## Business Goal

Prevent credentials from being persisted in `invoicecore` application logs and make all HTTP request logs traceable through one request-level trace identifier.

## Scope

- Service: `invoicecore/aspnet-core/src/zero/VS.Web.Host`.
- For every inbound HTTP request, accept a valid `X-Trace-Id` request header or generate a new server trace ID when the header is absent or invalid.
- Return the resolved trace ID in the `X-Trace-Id` response header.
- Add the trace ID to the log4net logical context for the request lifetime and include it in the host log layout.
- Clear the logical context after each request.
- Remove raw request payload, password-bearing URL, and raw response-body logging from Cyber ID password-related integrations in `DashBoard_DNAppService`.
- Preserve Cyber ID HTTP request behavior and frontend-facing response behavior.

## Out Of Scope

- No encryption or persistence of password values for diagnostic purposes.
- No trace/correlation propagation to RabbitMQ, MassTransit, Hangfire, or other background jobs.
- No changes to Cyber ID API contracts, request payloads, response payloads, or authentication behavior.
- No database schema, migration, deployment configuration, frontend, or other service changes.

## Acceptance Criteria

- A request with a valid `X-Trace-Id` returns the same ID in its response and host logs include that ID.
- A request without a valid `X-Trace-Id` receives a newly generated ID in its response and host logs include that ID.
- Trace context is cleared at request completion and cannot appear in a later unrelated request log.
- Host log lines include a `traceId` field while retaining the existing level, timestamp, thread, logger, and message information.
- Cyber ID password operations do not write plaintext passwords, serialized request bodies, password-bearing URLs, bearer tokens, or raw response bodies to application logs.
- Cyber ID password operations retain sufficient diagnostics to identify the endpoint and HTTP result without exposing sensitive values.

## Approved Design

### Trace ID lifecycle

Implement request middleware in `VS.Web.Host` early in the HTTP pipeline. The middleware accepts an inbound `X-Trace-Id` only when it is non-empty and uses a conservative safe-character and length validation rule. Otherwise, it generates a new GUID in compact `N` format. It writes the resolved value to the response `X-Trace-Id` header, sets `log4net.LogicalThreadContext.Properties["traceId"]` before invoking the next pipeline component, and removes the value in a `finally` block.

Update the host `log4net.config` conversion pattern with `%property{traceId}`. This gives all log4net entries emitted during the request the same searchable identifier without changing individual application-service logging calls.

### Sensitive Cyber ID logs

Replace password-related Cyber ID logs that currently output JSON payloads, query URLs, or raw response text with structured-safe messages containing only the fixed endpoint path and HTTP status code. Do not log a password, password confirmation, password-bearing query string, access/bearer token, OTP, serialized input, or raw response body. Retain exception logging without adding sensitive request/response data.

### Error handling and compatibility

The middleware must not change request execution or response status codes. It must restore logging context even when downstream middleware or endpoints throw. The existing outbound Cyber ID calls and business results remain unchanged; only diagnostic log content is reduced.

### Verification

- Add focused automated tests for trace ID reuse, generation, response header behavior, and context cleanup where the existing test project supports host/middleware tests.
- Build `invoicecore/aspnet-core/VS.Web.sln`.
- Perform an HTTP request with and without `X-Trace-Id`, inspect the response header and log output, and verify a password test value is absent from the relevant logs.
