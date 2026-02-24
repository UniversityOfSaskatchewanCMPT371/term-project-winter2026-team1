# Pre-Push Checklist

> **Purpose**
>
> This checklist exists to maintain code quality, testability, and traceability as the project evolves.
> This is meant to ensure that changes are reviewable, testable, and are aligned with 
> team process and course expectations.
>
> Every developer should review this checklist **before pushing code or opening a pull request**.

---

## Git Commit Message Recommendations

- [ ] First line offers a concise overview of the change
- [ ] Commit describes **what** and **why** the change was made
- [ ] Corresponding issues are referenced where applicable

---

## 1. Scope & Intent

- [ ] The change has a **clear purpose** and does not mix unrelated concerns
- [ ] Large changes have been broken into **reviewable chunks**
- [ ] Experimental or partial work is clearly marked

---

## 2. Testing Requirements

- [ ] At least **3 unit tests** exist for new or modified logic  
  - Tests cover:
    - expected behavior
    - at least one edge case
    - at least one failure or invalid input case
- [ ] Existing tests have been updated if behavior changed
- [ ] Tests are deterministic 
- [ ] All tests pass locally

---

## 3. Code Quality & Style

- [ ] Code is readable and self-explanatory
- [ ] Naming is clear and consistent with existing code
- [ ] No commented-out code or debug prints remain
- [ ] Logic is not unnecessarily duplicated
- [ ] UI code does not contain business or data-access logic (where avoidable)

---

## 5. Issue Tracking & Traceability

- [ ] An associated **GitHub Issue exists**
- [ ] The issue number is referenced in the commit message or PR description  
  *(e.g., `Fixes #42`, `Refs #17`)*
- [ ] The issue accurately describes the change and current status

---

## 6. Labels & Metadata

- [ ] Appropriate labels are applied to the issue and/or PR:
  - `feature`
  - `bug`
  - `test`
  - `refactor`
  - `documentation`
- [ ] High-risk or blocking issues are clearly labeled

---

You're ready to push!
