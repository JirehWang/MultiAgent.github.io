# Condition Based Waiting

Use this reference when tests or automation need to wait for async behavior.

## Rule

Wait for an observable condition, not for a fixed time.

## Prefer

- element is visible
- request finished
- file exists
- process is ready
- text appears
- database row exists
- event is emitted
- status endpoint returns healthy

## Avoid

- arbitrary sleep
- retry loops without timeout
- waiting for more time after every failure
- hiding race conditions with long delays

## Pattern

1. Define the condition.
2. Poll or subscribe until it is true.
3. Set a clear timeout.
4. On timeout, report the last observed state.

## Example

```
wait until health endpoint returns 200
timeout after 30 seconds
on failure, print last status and response body
```
