# Specification

| Field | Value |
|---|---|
| Artifact | Specification (what) |
| Status | Retrospective — reverse-engineered from the existing code (as-built) |
| Applies to | Original implementation in [`src/`](../../src/) (April 2020) |
| Related | [intent.md](intent.md) · [plan.md](plan.md) · [code overview](../code-overview.md) |

> This specification describes **what the original code does**, not what it should do.
> Requirements are written in the present tense against the as-built behavior. Known
> deviations between the report and the code are listed in section 7.

## 1. System context

Three MATLAB scripts executed manually, in order, in one MATLAB session:
training → generalization → online application. State is shared through workspace
variables (`data`, `wO`, `wS`). See [architecture](../architecture.md).

## 2. Data contract

**`entrenamientoTodo.txt`** (external, not versioned)

| Property | Specification | Evidence |
|---|---|---|
| Format | Numeric delimited text readable by `dlmread` | Confirmed |
| Rows | One sample per row; > 40,000 rows (50,000 per report) | Confirmed / Inferred |
| Columns 1…end-10 | Pixel intensities, 784 values (28×28, row-major) | Inferred |
| Last 10 columns | One-hot label; column *j* ↔ digit *j−1* | Confirmed |
| Pixel scale | [0, 1], white digit on black background | Inferred |

## 3. Model specification

| ID | Requirement |
|---|---|
| M-1 | The network has one hidden layer of 50 neurons with `tanh` activation. |
| M-2 | The output layer has 10 neurons with logistic sigmoid activation. |
| M-3 | Each layer receives a bias input fixed at 1, stored as the first row of its weight matrix. |
| M-4 | Weights are initialized as `rand(...)*0.001`. |
| M-5 | The predicted digit is the index of the maximum output minus one. |

## 4. Functional requirements

### Training (`MLP_Entrenamiento_DeteccionDeNumeros.m`)

| ID | Requirement |
|---|---|
| FR-T1 | Loads `entrenamientoTodo.txt` from the current MATLAB folder. |
| FR-T2 | Uses rows 1–40,000 as the training set. |
| FR-T3 | Trains for 300 epochs with per-sample (online) backpropagation and learning rate 0.2. |
| FR-T4 | Prints the current epoch number every epoch. |
| FR-T5 | Accumulates the signed output error per epoch and plots one figure per output, titled `Erro en la salida: <digit>`. |
| FR-T6 | Leaves `data`, `wO` (785×50) and `wS` (51×10) in the workspace. |

### Generalization (`MLP_Generalizacion_DeteccionDeNumeros.m`)

| ID | Requirement |
|---|---|
| FR-G1 | Uses `data`, `wO`, `wS` from the workspace; does not read files. |
| FR-G2 | Uses rows 40,001–end as the test set. |
| FR-G3 | Counts a sample as correct only when all 10 rounded outputs equal the one-hot target. |
| FR-G4 | Prints the accuracy percentage to the console. |

### Online application (`MLP_Aplicacion_DeteccionDeNumeros.m`)

| ID | Requirement |
|---|---|
| FR-A1 | Clears all workspace variables except `wS`, `wO` and `data`. |
| FR-A2 | Opens the installed image-acquisition adaptor and shows a live preview. |
| FR-A3 | Captures 10,000 snapshots in a loop, pausing 0.01 s per iteration. |
| FR-A4 | Pre-processes each frame: grayscale → threshold at 100 (ink → 255, background → 0) → resize to 28×28 → scale to [0, 1]. |
| FR-A5 | Displays the processed 28×28 image. |
| FR-A6 | Flattens the image row by row (`reshape(im', 784, [])`) before inference. |
| FR-A7 | Prints the recognized digit as a Spanish word (`CERO` … `NUEVE`). |

## 5. Non-functional characteristics (as built)

| ID | Characteristic |
|---|---|
| NF-1 | Environment: MATLAB, R2016b or newer (Inferred from local functions in scripts and `string`). |
| NF-2 | Requires the Image Acquisition Toolbox with a camera adaptor, and image functions such as `imresize` (Image Processing Toolbox). |
| NF-3 | No persistence: the model exists only for the lifetime of the MATLAB session. |
| NF-4 | Training cost: 300 × 40,000 = 12,000,000 per-sample updates, executed in interpreted loops. |

## 6. Acceptance criteria (historical)

| ID | Criterion | Result reported |
|---|---|---|
| AC-1 | Training completes and produces decreasing error curves | Met — 9 of 10 plots included in the report |
| AC-2 | Held-out accuracy is reported | Met — 92.55 % |
| AC-3 | Live webcam recognition works | Met per report — demonstrated in the linked video |

These results cannot be reproduced from this repository alone, because the dataset and
the trained weights are not included.

## 7. Known deviations and open questions

| ID | Item | Status |
|---|---|---|
| Q-1 | The report says weights are "saved"; the code only keeps them in memory. | Deviation (documented) |
| Q-2 | Exact origin/variant of the 50,000-sample "MNIST" file. | Unknown |
| Q-3 | Pixel scale of the dataset file. | Inferred, not confirmed |
| Q-4 | Camera adaptor / hardware used. | Unknown |
| Q-5 | MATLAB release used. | Unknown (R2016b+ inferred) |
