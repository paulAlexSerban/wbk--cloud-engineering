# Span Reliability Patterns and Practices

## Overview

Patterns and architectural solutions you can use to prevent or recover from stale, long-running, or never-ended spans in your distributed tracing system. These patterns are not specific to any one tracing system, but are general solutions that can be applied to any system that uses spans to represent work.

## Patterns

### 1. Span Timeouts - Time-Bound Spans/Span Expiry Pattern

- Type: Passive
- Description: When emitting a span, set a max expected duration, and on the backend or in a post-processor, flag any span exceeding that threshold.

Then, use Datadog (or other monitoring solutions) monitors to:

- Detect spans open for >5 minutes
- Flag spans that never completed

- Pros
  - Works passively, no heartbeat needed
  - Cheap to implement
- Cons
  - Only detects the problem, doesn’t prevent it
  - Can’t capture partial progress

When to use: All long tasks
Prevents or detects: detects stale spans

### 2. Heartbeat (Span) Pattern

- Type: Active
- Description: Emit a heartbeat span at regular intervals (e.g., every 5 seconds) to indicate that the span is still active. If the heartbeat stops, the span is considered stale.
- Pros
  - Can be used to detect long-running spans
  - Can be used to detect spans that are stuck in a loop
- Cons

  - Requires additional overhead to emit heartbeats
  - May generate false positives if not tuned properly

- Goal: To detect and handle incomplete, stalled, or orphaned operations (like spans or tasks) in environments prone to:

  - App crashes or terminations
  - Network instability or latency
  - Lack of clean shutdown (especially on mobile)

- What is a Heartbeat?: A heartbeat is a periodic signal (event, metric, log, or span) sent from a process or service to indicate it is still alive and performing an operation.

Use Case

- Used to track and manage long-lived or fragile processes like:
  - Mobile background uploads/downloads
  - IoT or edge devices syncing data
  - Async server-side jobs (data ingestion, stream processing)

Pattern Structure

1. Parent Span or Operation
   - Represents the full operation (e.g., file upload, sync job).
   - Starts when the task begins.
   - Intentionally not immediately closed—needs tracking.
2. Heartbeat Signal (Child Spans / Metrics / Logs)
   - Emitted every N seconds/minutes to signal activity.
   - Carries progress, health, or simple liveness info.
3. Monitoring Layer
   - Tracks if a heartbeat has not been received within expected interval (i.e., a "dead" task).
   - Triggers auto-cleanup, marking, or alerting if missing.

Implementation options

1. Child Spans as Heartbeats (Datadog APM)
   - Pros: Structured tracing view, visual heartbeat stream
   - Cons: Can flood trace volume if not throttled

```ts
// Start parent span
const parentSpan = tracer.startSpan("sync_session");

// Every 30s, send a heartbeat span
setInterval(() => {
  const heartbeat = tracer.startSpan("heartbeat", { childOf: parentSpan });
  heartbeat.setTag("progress", "50%");
  heartbeat.finish();
}, 30_000);

// On completion
parentSpan.finish();
```

2. Heartbeat as Custom Metric

- use Datadog monitor: "Alert if no `sync.heartbeat` from user `user_id:123` in the last 5 minutes"
- Pros: Lightweight, easy to alert on
- Cons: Decoupled from trace

```ts
statsd.increment("sync.heartbeat", 1, ["user_id:123", "session_id:abc"]);
```

3. Heartbeat as Structured Log

- ingested into Datadog via log ingestion pipelines
- Pros: very flexible, works well with mobile and disconnected clients
- Cons: requires log volume management

```json
{
  "timestamp": "2025-05-19T10:00:00Z",
  "event": "heartbeat",
  "session": "abc",
  "progress": "75%",
  "status": "active"
}
```

Recovery Handling

- When the heartbeat stops unexpectedly, your system can:
  - alert the ops team
  - mark the session as orphaned
  - retry or rollback the task
  - close the trace with a `timeout` or `error` tag

Benefits
| Benefit | Description |
| ------------------------- | --------------------------------------------------- |
| Detect long-running tasks | Identify tasks that are taking too long to complete |
| Auto-recovery | Use stale heartbeats to trigger retries or cleanup |
| Mobile resilience | Handles lifecycle quirks (e.g., app terminated) |
| Observability | Visualize ongoing progress or failures in Datadog |

When to use: Async ops with progress
Prevents or Detects: Detects loss of activity

### 3. Deferred Close Pattern

Type: Recovery
Description: When emitting a span from mobile or frontend, persist the span context locally (e.g., to AsyncStorage, SQLite, IndexedDB). On next startup or retry, attempt to gracefully close or annotate the span.

Use Case:

- App dies before finishing upload
- On next boot, detect unfinished span and close it with reason "abandoned" or "restarted"

Pros:

- Prevents zombie spans across restarts
- Adds postmortem metadata

Cons:

- Requires local persistence
- Not possible if crash prevents context saving
  when to use: Mobile/Web clients
  Prevents or detects: Prevents lost spans

### 4. Supervisor/Watchdog Pattern

Type: Centralized
Description: Introduce a background monitor (watchdog) that tracks "alive" sessions (via memory, DB, or cache), and flags sessions that stop emitting signals after N minutes.

Implementation

- Backend stores active session IDs with last update time
- Cron job or event processor checks for stale sessions
- Marks spans as failed/abandoned

Pros

- Centralized monitoring
- Works across all clients/devices

Cons

- Backend complexity increases
- Requires coordination between client and backend

When to use: Server-heavy systems
Prevents or detects: Flags zombie sessions

### 5. Timeout-Wrapped Operations

Type: Guardrails
Description: Wrap all async operations with a timeout handler that forcibly ends the span if it takes too long.

Example (Node.js)

```ts
const runWithTimeout = async (fn, timeoutMs = 300000) => {
  const timeout = new Promise((_, reject) =>
    setTimeout(() => reject(new Error("Timed out")), timeoutMs)
  );
  return Promise.race([fn(), timeout]);
};

runWithTimeout(() => performTask(span), 5 * 60 * 1000).catch((err) => {
  span.setTag("error", true);
  span.setTag("reason", "timeout");
  span.finish();
});
```

Pros

- Ensures spans are not open forever
- Easy to enforce globally

Cons

- Still susceptible to OS termination (mobile)
- Doesn’t handle network drop well
  When to use: Async ops in backend
  Prevents or detects: Prevents runaway spans

### 6. Reverse Span Finalization (Backend Ownership) / Backend Finalization

Type: Ownership Shift
Description: Backend owns span lifecycle. Client sends updates or "I'm alive" pings, but backend is responsible for closing or flagging the span if client drops off.

Example:

1. Client sends start_job → backend starts span
2. Client sends periodic job_progress → backend attaches as logs or sub-spans
3. If no progress in 10 minutes → backend closes span with "status: dead"

Pros

- More reliable than client-controlled span finalization
- Works even if client is unstable

Cons

- Increases backend logic
- Needs good event sourcing / correlation ID discipline

When to use: Reliable backend
Prevents or detects: Detects and closes unclosed spans

### 7. Fire-and-Forget Span Detectors

Description: Set up Datadog monitors (APM or log-based) to catch anomalies like:

- Spans > N hours
- Spans without end_time
- Spans missing expected child spans

Can be used to raise alerts after the fact and trigger automated remediation.

### 8. Graceful Degradation Pattern (Client-Side)

Type: Mobile/Web Specific - Client-Side
Description: On mobile, if connectivity is lost or the app is backgrounded, send a “closing summary span” or buffered trace segment with the known context and "status": "partial".

This relies on:

- Lifecycle hooks (e.g., onPause, AppState, componentWillUnmount)
- Persistent buffering of trace data

When to use: Background-prone UIs
Prevents or detects: Prevents trace gaps

### 9. Idempotent Retry Pattern

Problem: A span is started but the operation fails silently — and retrying it might re-trigger the span incorrectly.

Solution:

- Use an operation ID or span ID tied to a unique task/session.
- On retries or resume, check if a span for that ID was already started/finished.
- This allows safe span continuation without duplication or zombie spans.

```json
{
  "op_id": "upload_4fa3-29db",
  "span_status": "resumed"
}
```

### 10. Client Trace Cache & Sync Pattern

Problem: On mobile or offline-first apps, spans are lost if the device disconnects mid-trace.

Solution:

- Buffer traces locally (SQLite, IndexedDB, file).
- When app regains connectivity, sync queued spans with a flush interval.
- Use TTL or max retention to avoid stale data uploads.

Bonus: Add a “flush before unload” on web/mobile events (beforeunload, onPause, app backgrounded).

### 11. Event-Sourced Tracing

Problem: You want to reconstruct a trace or session even if it wasn't captured completely.

Solution:

- Use event sourcing to log discrete events (task_started, task_progress, task_failed, task_completed).
- Reconstruct the trace graph offline or post-processed in Datadog based on correlation IDs.

Tools: This is similar to how tools like Segment or custom event pipelines enrich trace data.

### 12. Correlated Lifecycle Hooks (for Mobile/Web)
Problem: Spans are cut off when the app crashes, is paused, or backgrounded.

Solution:
- Hook into mobile lifecycle events:
  - Android: onPause, onStop, onDestroy
  - iOS: applicationWillResignActive, applicationDidEnterBackground

On these events, check for unfinished spans and finalize them or write them to local storage for deferred upload.

### 13. Dead Letter Queue for Stuck Spans
Problem: You want to debug and analyze "stuck" spans.

Solution:
- Ingest long-running or broken spans into a separate observability queue (e.g., a Dead Letter Queue).
- Tag them as "incomplete": true and analyze patterns (device models, network types, endpoints).

Useful for:
- Debugging root causes
- Feeding data into ML models to predict broken flows

### 14. Trace Lifecycle Contract Enforcement
Problem: Inconsistent client instrumentation leads to span start/stop imbalance.

Solution:
- Define a trace lifecycle contract (e.g., each span_type: upload must end with a span.finish() or status code).
- Add lint rules or CI tests to enforce trace instrumentation completeness.
- Example: Every span must have duration, end_time, or error.

### 15. Span Linking or Contingent Span Closure
Problem: You have distributed systems where parent-child spans may exist on different devices/services.

Solution:
- Use link or follows_from to create semantic relationships across spans.
- If the downstream span finishes, but upstream never did, you can retroactively finalize or flag the upstream one.

### 16. Trace Anomaly Detection & Automated Remediation
Problem: You need real-time alerting or self-healing for broken spans.

Solution:
- Use Datadog Monitors, Watchdog, or anomaly detection on trace duration, span count, or open span rates.
- If anomaly detected:
  - Trigger alert
  - Auto-close stale spans
  - Mark them as "status": "recovered", "reason": "watchdog-intervention"

### 17. Bulk Finalizer Job (Scheduled Cleanup)
Problem: You accumulate thousands of dangling spans daily.

Solution:
- Schedule a post-processor job (e.g., every hour) to:
- Scan traces missing end_time after N minutes
- Auto-finish them with reason: "timeout", "client-crash", etc.

### 18. Trace Session Token Expiry
Problem: Users or devices can create traces that never expire.

Solution:
- Create trace sessions with a TTL-based token (e.g., JWT, Redis key).
- If token expires and no span was finished, trigger a fallback mechanism to close or invalidate the trace.
