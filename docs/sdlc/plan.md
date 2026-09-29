# Plan

| Field | Value |
|---|---|
| Artifact | Plan (how) |
| Status | Retrospective — reconstructed as-built plan, plus the repository preservation plan |
| Applies to | Original implementation in [`src/`](../../src/) and the repository layout |
| Related | [intent.md](intent.md) · [spec.md](spec.md) |

> Part A reconstructs how the original project was built, based on the development
> section of the report and on the code. Part B records the plan followed when the
> repository was later reorganized. Neither part changes the original source code.

## Part A — Original implementation (as built, April 2020)

### A.1 Approach

Build a fully-connected MLP by hand in MATLAB, train it offline on a digit dataset,
evaluate it on a held-out split, and reuse the in-memory weights for live webcam
inference.

### A.2 Technical decisions (as reflected in the code)

| Decision | Choice | Rationale (from the report, or Inferred) |
|---|---|---|
| Language / environment | MATLAB scripts | Course environment (Inferred) |
| Model | 784–50–10 MLP | 50 hidden neurons gave the best result among the trials (report) |
| Activations | `tanh` hidden, sigmoid output | Best configuration reported |
| Optimizer | Online gradient descent, eta = 0.2, 300 epochs | Best configuration reported |
| Initialization | `rand*0.001` | Best configuration reported |
| Data split | 40,000 train / remaining test | Report: 40,000 of 50,000 used for training |
| Flattening | Row-major (`reshape(im', ...)`) | Report conclusion: MATLAB's default column-major order did not match the data |
| Camera pre-processing | Fixed threshold + inversion + resize | Match MNIST's white-on-black 28×28 format (Inferred) |
| Model hand-off | Shared workspace variables | Simplicity (Inferred) |

### A.3 Work breakdown

| Step | Task | Output | Spec |
|---|---|---|---|
| 1 | Implement the MLP forward/backward pass for n inputs, m hidden, l outputs | Training loop | M-1…M-4, FR-T3 |
| 2 | Download "MNIST" and prepare `entrenamientoTodo.txt` (784 pixels + 10 one-hot columns per row) | Dataset file (not versioned) | Data contract |
| 3 | Train on rows 1–40,000; plot error per output | `wO`, `wS`, 10 figures | FR-T1…FR-T6 |
| 4 | Evaluate on rows 40,001–end | Accuracy % | FR-G1…FR-G4 |
| 5 | Tune eta, initial weights, epochs, hidden neurons; keep best (92.55 %) | Final hyperparameters | AC-2 |
| 6 | Build webcam application with image preparation and live inference | Application script | FR-A1…FR-A7 |
| 7 | Record the demo video and write the report | PDF + YouTube video | AC-3, O-4 |

### A.4 Execution order

1. Place `entrenamientoTodo.txt` in the MATLAB current folder.
2. Run `MLP_Entrenamiento_DeteccionDeNumeros.m`.
3. Run `MLP_Generalizacion_DeteccionDeNumeros.m` in the same session.
4. Run `MLP_Aplicacion_DeteccionDeNumeros.m` in the same session with a webcam connected.

## Part B — Repository preservation plan (later reorganization)

### B.1 Guardrails

- The three `.m` files are **immutable**: they may be moved, never edited
  (see [`AGENTS.md`](../../AGENTS.md)).
- The original PDF is preserved unchanged in `docs/original/`.
- Documentation distinguishes **Confirmed**, **Inferred** and **Unknown** information.
- No build systems, CI, containers or tooling that the original project did not have.

### B.2 Steps

| Step | Task | Status |
|---|---|---|
| 1 | Inventory all files; extract and visually review every page of the PDF | Done |
| 2 | Verify that the code annexes in the report match the scripts | Done — identical |
| 3 | Move scripts to `src/` and the PDF to `docs/original/` using renames only | Done |
| 4 | Extract the report's training-error figures to `docs/assets/training-error/` | Done |
| 5 | Write `README.md` and `docs/` (context, report summary, code overview, architecture, improvements) | Done |
| 6 | Write retrospective SDLC artifacts (`intent.md`, `spec.md`, `plan.md`) | Done |
| 7 | Add `.gitignore` and `AGENTS.md` | Done |

### B.3 Verification

The original source files must keep these SHA-256 checksums (identical to the files
uploaded in February 2021):

```text
71506e7bd46942b4ee208a3cea554c19cd2a3dce3b78f9fedc97fe10c2a93287  src/MLP_Entrenamiento_DeteccionDeNumeros.m
1e4b0f73dad33fb650919a0fa0c4da283479c9cc6fc3839bffb2260cb66176b4  src/MLP_Generalizacion_DeteccionDeNumeros.m
651e30a2ca3320c2ab595e86fdaea29e978f0d154257091dfb1775b248adf535  src/MLP_Aplicacion_DeteccionDeNumeros.m
```

Check with:

```bash
sha256sum -c <<'EOF'
71506e7bd46942b4ee208a3cea554c19cd2a3dce3b78f9fedc97fe10c2a93287  src/MLP_Entrenamiento_DeteccionDeNumeros.m
1e4b0f73dad33fb650919a0fa0c4da283479c9cc6fc3839bffb2260cb66176b4  src/MLP_Generalizacion_DeteccionDeNumeros.m
651e30a2ca3320c2ab595e86fdaea29e978f0d154257091dfb1775b248adf535  src/MLP_Aplicacion_DeteccionDeNumeros.m
EOF
```

Git also shows the moves as pure renames (100 % similarity):

```bash
git log --follow --stat -M -- src/MLP_Entrenamiento_DeteccionDeNumeros.m
```
