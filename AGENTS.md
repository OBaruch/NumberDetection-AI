# Contributor and Agent Guidelines

Rules for anyone — human or automated coding agent — working in this repository.

## Project in one paragraph

A MATLAB university project (Universidad de Guadalajara, CUCEI, *Sistemas
Inteligentes*, April 2020) that trains a hand-written 784–50–10 multilayer perceptron
to recognize digits and runs it on live webcam frames. The repository is preserved as
a historical portfolio piece. Start with [README.md](README.md) and
[docs/sdlc/](docs/sdlc/).

## Hard rules

1. **Never modify files in `src/`.** No edits, reformatting, line-ending changes,
   renames or "fixes". The code is kept exactly as originally written.
   Verify with the checksums in [docs/sdlc/plan.md](docs/sdlc/plan.md#b3-verification).
2. **Never modify or delete `docs/original/`.** It contains the original report.
3. **Do not add infrastructure** (build tools, CI, containers, package managers,
   linters, test frameworks) that the original project did not have.
4. **Do not invent facts.** Label information as *Confirmed*, *Inferred* or *Unknown*.
5. Improvement ideas go to [docs/possible-improvements.md](docs/possible-improvements.md),
   never into `src/`.

## Where things live

| Path | Content | Editable |
|---|---|---|
| `src/` | Original MATLAB scripts | No |
| `docs/original/` | Original report (PDF) | No |
| `docs/assets/` | Figures extracted from the original report | No (derived from the PDF) |
| `docs/sdlc/` | Intent, spec and plan (retrospective) | Yes |
| `docs/*.md`, `README.md` | Modern documentation | Yes |

## Workflow for documentation changes

1. Update `docs/sdlc/intent.md` → `spec.md` → `plan.md` when the understanding of the
   project changes, keeping them consistent with each other.
2. Keep links relative and in English.
3. Before committing, confirm `git diff --stat -- src/ docs/original/` is empty.
