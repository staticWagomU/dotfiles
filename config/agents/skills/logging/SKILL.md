---
name: logging
description: Guide logging practices based on Dave Cheney's minimalist philosophy. Use when adding log.Info/Debug/Error/Warn/Fatal calls, reviewing logging code, handling errors with log+return pattern, discussing log levels, or designing error handling strategies.
---

<purpose>
Apply Dave Cheney's logging philosophy: simplify ruthlessly, handle errors properly, and log only what matters.
</purpose>

<rules priority="critical">
  <rule>Only two log levels matter: Info (for operators/users) and Debug (for developers)</rule>
  <rule>Never log an error AND return it (causes duplicate logs up the stack)</rule>
  <rule>Never log errors in library code (caller decides what to do)</rule>
  <rule>Let errors bubble up to where they can be meaningfully handled</rule>
</rules>

<rules priority="standard">
  <rule>Warning level: Remove it. "Nobody reads warnings" - either it's an error or info</rule>
  <rule>Fatal level: Avoid it. Bypasses `defer`, prevents cleanup. Let errors bubble to `main()`</rule>
  <rule>Error level: Rethink it. If handled, it's info. If not handled, return it to caller</rule>
  <rule>Exception: Warnings from runtimes and external libraries should be logged at warning level (you don't control these sources)</rule>
  <rule>Prefer structured logging formats over string interpolation</rule>
</rules>

<patterns>
  <pattern name="error-bubbling">
    <description>Let errors propagate to where they can be meaningfully handled</description>
    <example>
```go
// GOOD: Just return (let caller decide)
if err != nil {
    return fmt.Errorf("connect: %w", err)
}
```
    </example>
  </pattern>

  <pattern name="terminal-error-handler">
    <description>At the boundary where errors become user-facing unexpected failures (e.g., 5xx responses), error-level logging is correct</description>
    <rationale>
      - The error chain ends here - no caller to return to
      - The user receives a generic message (for security/UX)
      - Operators need the full error details for debugging
    </rationale>
    <example>
```go
// At HTTP handler boundary - error level is appropriate
if err != nil {
    log.Error("unexpected failure",
        "error", err,
        "request_id", requestID,
    )
    http.Error(w, "Internal Server Error", http.StatusInternalServerError)
    return
}
```
    </example>
    <note>This is NOT the same as logging mid-stack - this is the terminal handler where errors are finally consumed, not propagated.</note>
  </pattern>

  <pattern name="structured-logging">
    <description>When logging is appropriate, prefer structured formats</description>
    <example>
```go
// Prefer structured fields over string interpolation
log.Info("request completed",
    "method", r.Method,
    "path", r.URL.Path,
    "duration", time.Since(start),
)
```
    </example>
  </pattern>
</patterns>

<anti_patterns>
  <avoid name="log-and-return">
    <description>Logging an error AND returning it causes duplicate logs up the stack</description>
    <example>
```go
// BAD: Log and return (duplicate logs)
if err != nil {
    log.Error("failed to connect", err)
    return err
}
```
    </example>
    <instead>Just return the error and let the caller decide</instead>
  </avoid>
  <avoid name="unused-warning">
    <description>Warning that nobody will act on</description>
    <example>
```go
// BAD: Warning that nobody will act on
log.Warn("connection pool running low")
```
    </example>
    <instead>Either info (if expected) or error (if action needed): `log.Info("connection pool at 80% capacity")`</instead>
  </avoid>
</anti_patterns>

<best_practices>
  <practice priority="critical">Is this log statement for users (info) or developers (debug)?</practice>
  <practice priority="critical">Am I logging an error AND returning it? (Remove the log)</practice>
  <practice priority="high">Is this a terminal handler (5xx boundary)? (Error level is appropriate here)</practice>
  <practice priority="high">Is this a warning? (Convert to info or error, or remove)</practice>
  <practice priority="high">Is this `Fatal`/`panic` in library code? (Return error instead)</practice>
  <practice priority="medium">Does this log message help the operator understand system state?</practice>
</best_practices>

<reference>Based on: [Let's talk about logging](https://dave.cheney.net/2015/11/05/lets-talk-about-logging) by Dave Cheney (2015)</reference>
