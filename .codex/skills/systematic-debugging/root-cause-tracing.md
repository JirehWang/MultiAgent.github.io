# Root Cause Tracing

Use this reference when the symptom is visible but the cause is not.

## Method

1. Name the symptom precisely.
2. Find the first point where expected and actual behavior diverge.
3. Trace backward from the symptom through data, control flow, and side effects.
4. Check boundaries: input parsing, config, cache, network, file IO, database, and time.
5. Test one hypothesis at a time.
6. Stop when you can explain why the symptom happens.

## Evidence To Capture

- command or action used to reproduce
- exact output or error
- input data or request
- relevant config
- file path and function
- last known good behavior
- first bad behavior

## Rules

- Do not patch downstream symptoms.
- Do not assume the nearest changed file is the cause.
- Do not trust logs without checking code paths.
- Prefer one small experiment over a broad rewrite.
- If the cause is external, prove the boundary and failure mode.
