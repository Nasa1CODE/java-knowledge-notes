# BillCloud System Specification

## 1. Purpose

This document is the system-level specification for BillCloud. It defines what the system must support from a product, technical, integration, security, and operational perspective.

Use this document to understand the expected behavior of the whole platform. Use `architecture.md` to understand source layout, runtime architecture, and service-level implementation details.

## 2. Document Scope

This specification covers the full BillCloud workspace under `D:\Source\billcloud`, including:

- Main portal frontend and public lookup frontend.
- ASP.NET Zero / ABP API backends.
- Java Spring Boot processing services.
- .NET worker and app-service processes.
- Import/export, PDF/ZIP, email, bang ke/DCTT, tax-message, and lookup flows.
- Runtime integration requirements for database, queue, file storage, signing, Redis, Kafka, RabbitMQ, and external services.

Task-specific specifications must be stored under `docs/features/<TICKET-ID>/expect.md` or related task files, and should reference this file when they depend on system-level behavior.

## 3. System Goals

BillCloud must provide a multi-tenant electronic invoice platform that enables organizations to create, manage, transmit, search, export, and verify invoice-related documents.

Primary goals:

- Support authenticated business users through a full-featured invoice portal.
- Support public invoice lookup and verification flows.
- Manage electronic invoice issuance, adjustment, replacement, cancellation, reporting, and tax authority communication.
- Process asynchronous work reliably through queue-based workers.
- Generate and store PDF, ZIP, XML, and Excel outputs.
- Send invoice and document emails using configured templates and attachments.
- Support tenant-specific data isolation and master/tenant database routing.
- Support deployment through existing GitLab CI, Ansible, Docker, and Kubernetes patterns.

## 4. System Actors

| Actor | Description | Main Entry Points |
| --- | --- | --- |
| Business user | Authenticated user of a tenant/business who creates and manages invoices. | `frontend_angular/` portal. |
| Tenant administrator | User who manages users, roles, configuration, enterprise info, templates, and tax setup. | `frontend_angular/`, ASP.NET Zero admin APIs. |
| System administrator | Operator who configures infrastructure, queues, deployments, and runtime settings. | Config files, CI/CD, Kubernetes, server-hosted config. |
| Public lookup user | External user who searches or verifies an invoice/document. | `searchBill/` public lookup UI. |
| Tax authority / GATE systems | External systems that receive or return tax/e-transaction messages. | Kafka, HTTP callback, tax-message services. |
| Mail infrastructure | External or internal mail provider used to deliver invoice emails. | `invoice-sendmail-service/`, RabbitMQ events. |
| Worker services | Background processors for export, PDF, ZIP, email, import, print, XML, and tax flows. | RabbitMQ, Kafka, direct queue polling. |
| AI/development agent | Assistant or developer reading source and docs to make changes. | `AGENTS.md`, `docs/*.md`, service source trees. |

## 5. System Domains

### 5.1 Portal and User Experience

The system must provide an authenticated Angular portal for business operations.

Required capabilities:

- User login, session initialization, tenant context, and permission-based navigation.
- Dashboard and onboarding flows.
- HDDT business modules for invoices, incoming invoices, reports, master data, enterprise configuration, support, and administration.
- Route-level access control based on permission metadata.
- Runtime-configurable backend URLs so the same frontend build can target different environments.
- Integration with generated API proxies and custom service wrappers.

Primary source:

- `frontend_angular/`

### 5.2 Public Lookup and Verification

The system must provide public invoice lookup and verification without requiring the full authenticated portal.

Required capabilities:

- Lookup invoice or document by search code or secret code.
- Verify invoice XML files.
- Resolve tenant/domain configuration from the public origin where applicable.
- Use captcha verification for public lookup flows.
- Support public viewing of invoice-related documents.
- Provide safe fallback behavior when tenant/domain lookup cannot resolve the intended context.

Primary source:

- `searchBill/`

### 5.3 Core Invoice Management

The system must support electronic invoice lifecycle management.

Required capabilities:

- Create, update, view, search, and manage invoice records.
- Support outgoing invoices, POS invoices, special invoice types, and related invoice documents.
- Support adjustment, replacement, cancellation, resend, and transaction-history flows.
- Support master data required for invoice creation, including customers, products, templates, enterprise settings, certificate information, and tax configuration.
- Enforce tenant, user, role, permission, and business rules.
- Publish asynchronous work when invoice actions require background processing.

Primary sources:

- `frontend_angular/src/app/hddt/`
- `api-cloud-service/`
- `api-qldv-service/`
- `invoicecore/aspnet-core/`

### 5.4 Incoming Invoice / HDDV Integration

The system must support incoming invoice and supplier invoice workflows.

Required capabilities:

- Connect the main portal to BillStore/HDDV runtime endpoints.
- Manage supplier invoice screens and related master data.
- Send required user, enterprise, and authorization headers to custom HDDV APIs.
- Keep HDDV integration isolated through dedicated runtime base URL configuration.

Primary sources:

- `frontend_angular/src/app/hddt/hddv/`
- `frontend_angular/src/services/hddv/`

### 5.5 Bang Ke and DCTT

The system must support bang ke/DCTT workflows for invoice-related summary, signing, file output, mail notification, and lookup.

Required capabilities:

- List bang ke records and source invoices.
- Create bang ke data from selected invoices.
- Manage bang ke detail lines.
- Generate XML and PDF output.
- Sign XML through configured signing/HSM services.
- Upload and download bang ke files through configured file storage.
- Send notification email when required.
- Support public captcha-protected lookup for generated bang ke PDF.

Primary sources:

- `frontend_angular/src/app/hddt/`
- `export-zip-pdf-service/`

### 5.6 Tax and E-Transaction Message Processing

The system must process electronic tax and transaction messages from Kafka or related integrations.

Required capabilities:

- Consume XML payloads from configured Kafka topics.
- Identify message type and dispatch to the correct processing service.
- Process message types such as `102`, `103`, `104`, `110`, `111`, `202`, `204`, `213`, `301`, `302`, and `999` when supported by service code.
- Switch between master and tenant databases safely.
- Update tenant invoice, service-tax, transaction, registration, and response records.
- Call external callback, QLDV, FTP, or email integrations when required.
- Avoid tenant-context leakage across asynchronous processing.

Primary source:

- `etran-teanant-service/`

### 5.7 PDF, ZIP, XML, and Excel Output

The system must generate downloadable and emailable document outputs.

Required capabilities:

- Generate invoice PDFs.
- Generate ZIP packages for invoice batches.
- Generate XML files for tax or document processing.
- Generate Excel exports for invoice lists or reports.
- Import invoice-related data from Excel where supported.
- Store output paths and processing status in tenant data.
- Support FTP or configured file storage for generated files.
- Preserve file-generation status for retries, error handling, and user feedback.

Primary sources:

- `export-zip-pdf-service/`
- `svinvoicesendemail/`

### 5.8 Email Sending

The system must send invoice and document emails asynchronously.

Required capabilities:

- Consume send-mail messages from RabbitMQ.
- Resolve tenant database connection from master/default data.
- Load invoice, chung tu, bang ke, business, template, and attachment data.
- Build email body from configured templates.
- Attach generated PDF/XML files when required.
- Send mail through configured infrastructure.
- Update send-mail status for tracking, retry, or reporting.

Primary source:

- `invoice-sendmail-service/`

### 5.9 Import, Export, Print, and XML Services

The system must support queue-driven import/export/print/XML operations.

Required capabilities:

- Import invoice-related Excel files from configured file storage.
- Export invoice data to Excel.
- Print invoice PDFs and ZIP outputs.
- Download or export XML files.
- Process jobs from RabbitMQ queues.
- Resolve tenant data from master/default database before processing.
- Update service status and output paths after processing.

Primary source:

- `svinvoicesendemail/`

## 6. Functional Requirements

### 6.1 Authentication, Authorization, and Session

- The system must authenticate portal users before allowing access to protected business screens.
- The system must initialize ABP user configuration, session, tenant, localization, and permissions before normal portal use.
- Protected frontend routes must use route guards or equivalent authorization checks.
- Backend APIs must enforce authorization for protected application services.
- Public lookup endpoints must remain narrow and explicitly controlled.
- JWT or bearer token flows must not expose token values in logs or documentation.

### 6.2 Tenant Isolation

- The system must isolate tenant business data.
- Master/default databases may store tenant metadata and connection information.
- Tenant-specific operations must use the resolved tenant database.
- Java services must clear tenant context after master/tenant operations.
- .NET workers must resolve tenant connection strings before accessing tenant invoice data.
- No service should assume a single database for all tenants unless explicitly designed for master-level work.

### 6.3 Invoice Portal Functions

- The portal must support invoice management from creation through output, transmission, and status review.
- The portal must expose master data screens required for invoice operations.
- The portal must expose configuration screens required for enterprise, tax, email, template, and certificate behavior.
- The portal must expose reports and operational history where implemented.
- The portal must integrate with custom HDDV and GDDT base URLs through runtime configuration.

### 6.4 Public Lookup Functions

- Public lookup must support captcha-protected search where required.
- Public lookup must support domain or tenant resolution when configured.
- Public lookup must support XML verification where implemented.
- Public lookup must not expose private tenant data beyond the requested public document context.

### 6.5 Asynchronous Processing

- Long-running or external-dependent work must be processed asynchronously when implemented by queue workers.
- Message contracts must remain backward compatible unless producers and consumers are changed together.
- Queue names, topic names, and credentials must come from configuration.
- Workers must record processing results and failures in service status tables or logs.
- Processing should be idempotent where retry can occur.

### 6.6 File Generation and Storage

- PDF, XML, ZIP, and Excel output must be generated by the responsible service.
- Generated file paths or payloads must be persisted where required for download, mail, lookup, or retry.
- File storage credentials and paths must come from configuration.
- Output generation must handle failure by updating status and preserving useful diagnostic information.

### 6.7 External Integration

- Kafka integrations must use configured bootstrap servers, topics, groups, and authentication settings.
- RabbitMQ integrations must use configured hosts, exchanges, queues, usernames, and passwords.
- FTP integrations must use configured host and credential settings.
- Signing/HSM integrations must use configured endpoints and keys.
- Redis integrations must use configured host/password/database values.
- External callback APIs must be environment-configurable.

## 7. Non-Functional Requirements

### 7.1 Security

- Secrets must not be added to documentation, comments, generated examples, or logs.
- Existing config files must be treated as sensitive because they may contain credentials or internal endpoints.
- Future deployment changes should move secrets to secret managers, Kubernetes Secrets, protected CI variables, or host-managed configuration.
- JWTs, passwords, tokens, raw sensitive XML, and customer/tax data must not be logged casually.
- Public endpoints must be reviewed carefully to prevent data leakage.

### 7.2 Reliability

- Worker services must tolerate transient queue, database, FTP, signing, and external API failures.
- Failed asynchronous work must be visible through logs and status records.
- Queue consumers must preserve message compatibility.
- Tenant context must be cleared after Java service operations.
- Manual retry and resend flows must preserve original business intent.

### 7.3 Performance

- Bulk import/export/PDF/ZIP operations should be handled outside request/response UI flows.
- Large data processing should use batching or paging where implemented.
- Runtime configuration should allow infrastructure endpoints to change without recompiling frontend bundles.
- Worker thread and prefetch settings must be configured cautiously to avoid overloading tenant databases or external services.

### 7.4 Maintainability

- Each change should be made in the smallest responsible service.
- Generated outputs such as `service-proxies.ts`, `target/`, `bin/`, `obj/`, `build/`, `dist/`, and packaged artifacts must not be edited unless explicitly required.
- Backend application services should follow the existing ASP.NET Zero / ABP layering pattern.
- Java services should preserve repository/service/controller and tenant-routing conventions.
- Worker changes must preserve event contract compatibility.

### 7.5 Observability

- Services must log enough context to diagnose failures without exposing secrets or sensitive tax data.
- Background jobs should log message IDs, tenant IDs, service status IDs, or correlation identifiers where available.
- Deployment and runtime config changes should be traceable through CI/CD or environment management.

### 7.6 Deployment Compatibility

- Existing GitLab CI, Ansible, Docker, and Kubernetes deployment patterns must be respected unless a task explicitly changes deployment architecture.
- Kubernetes manifests using `_dockerimage_` are templates and require CI substitution.
- Ansible-packaged .NET services generally expect runtime config outside the published package.
- Frontend runtime appconfig files may be supplied outside the build artifact.

## 8. Service Responsibility Matrix

| Responsibility | Primary Source | Supporting Source |
| --- | --- | --- |
| Main authenticated portal | `frontend_angular/` | ASP.NET APIs. |
| Public invoice lookup | `searchBill/` | ASP.NET lookup APIs. |
| Standard ABP administration | `api-cloud-service/`, `api-qldv-service/`, `invoicecore/aspnet-core/` | `frontend_angular/src/app/admin/`. |
| HDDT business APIs | `api-cloud-service/src/hddt/`, `api-qldv-service/src/hddt/`, `invoicecore/aspnet-core/src/hddt/` | `frontend_angular/src/shared/service-proxies/`. |
| QLDV integration | `api-qldv-service/`, `etran-teanant-service/` | Runtime config. |
| Tax/e-transaction XML processing | `etran-teanant-service/` | Kafka, callback APIs, tenant DB. |
| PDF/ZIP generation | `export-zip-pdf-service/` | FTP, tenant DB. |
| Email sending | `invoice-sendmail-service/` | RabbitMQ, FTP, tenant DB. |
| Import/export/print/XML jobs | `svinvoicesendemail/` | RabbitMQ, FTP, tenant DB. |
| Deployment config | Service-local Dockerfile/YAML/CI files | Host config, registry, Ansible. |

## 9. Data Requirements

### 9.1 Master Data

The system must maintain or access master-level data needed to resolve:

- Tenants.
- Users.
- Tenant database connection information.
- Enterprise/business identity.
- System-level configuration.
- Service integration configuration where stored in database.

### 9.2 Tenant Data

Tenant databases must store business-domain data such as:

- Invoice headers and details.
- POS invoice data.
- Customer and product master data.
- Enterprise configuration.
- Service-tax and transaction-log records.
- Bang ke records and details.
- Email service records.
- Print/export/import job statuses.
- Generated file paths and metadata.

### 9.3 Generated Artifacts

The system must track generated artifacts required by users or downstream systems:

- PDF.
- XML.
- ZIP.
- Excel.
- Email attachments.
- Signing outputs.

Artifact storage may be FTP, local/server file storage, NFS-mounted frontend config, or another configured storage path depending on service.

## 10. Integration Requirements

### 10.1 API Integration

- Frontend must call backend APIs through runtime-configured base URLs.
- Generated service proxies must reflect backend Swagger contracts.
- Custom API wrappers must use the correct runtime base URL and headers.
- Backend endpoint prefixes must be respected:
  - `/api/services/app/*`
  - `/api/services/hddt/*`
  - `/api/services/hddtws/*`
  - explicit endpoints such as `/api/TokenAuth/*`

### 10.2 Queue Integration

- MassTransit-based services must keep event contracts under `EventBus.Messages` compatible with producers and consumers.
- Direct RabbitMQ workers under `svinvoicesendemail/` must preserve queue names and message DTO compatibility.
- Queue consumers must not assume queue names are hard-coded; configuration must be checked.

### 10.3 Kafka Integration

- Kafka topics, groups, bootstrap servers, SASL settings, and gateway credentials must come from configuration.
- Tax/e-transaction processing must parse and handle expected XML payloads safely.
- Kafka-produced XML payloads must preserve tax/GATE contract requirements.

### 10.4 File Storage Integration

- FTP/file storage config must be read from runtime configuration.
- File paths must be stored in status records where later download or email attachment is required.
- Services must avoid logging credentials or full sensitive file content.

### 10.5 Signing Integration

- Signing/HSM endpoint configuration must be environment-specific.
- Signing flows must preserve input XML integrity.
- Signing failures must be captured in status/log output.

### 10.6 Redis/Captcha Integration

- Public lookup captcha validation must use configured Redis connection data.
- Captcha keys should be single-use where implemented.
- Redis failures should fail safely rather than bypassing validation.

## 11. Acceptance Criteria

The system specification is satisfied when:

- A developer can map each major business capability to the responsible source folder and service.
- A frontend change can be traced from route to component to API call to backend or worker service.
- A backend API change can be traced to the correct ABP app-service module and endpoint prefix.
- A queue-based worker change can be traced to message contract, producer, consumer, tenant DB resolution, and status update.
- A Java service change can be traced to controller/listener, service, repository, tenant routing, and external integration.
- Deployment behavior can be traced to Dockerfile, CI file, Kubernetes manifest, Ansible playbook, or runtime config boundary.
- No task-specific specification contradicts the system-level tenant isolation, security, and integration requirements in this document.

## 12. Traceability

Related documentation:

- `docs/architecture.md`: source layout, runtime architecture, deep dives, and AI agent playbooks.
- `docs/design.md`: design decisions and implementation approaches.
- `docs/features/<TICKET-ID>/expect.md`: expected outcome for a specific task.
- `docs/features/<TICKET-ID>/plan.md`: implementation plan for a specific task.
- `docs/features/<TICKET-ID>/report.md`: result and verification report for a specific task.
- `docs/features/<TICKET-ID>/testcase.md`: task-specific test cases.

## 13. Change Control

Update this file when:

- A new major service or application is added.
- A service responsibility changes.
- A system-level integration is added, removed, or replaced.
- Tenant isolation rules change.
- Deployment model changes.
- Security or runtime configuration policy changes.

Do not use this file for detailed implementation steps of a single ticket. Use `docs/features/<TICKET-ID>/` for task-specific expectations, plans, reports, and test cases.
