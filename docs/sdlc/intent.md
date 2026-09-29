# Intent

| Field | Value |
|---|---|
| Artifact | Intent (why) |
| Status | Retrospective — reconstructed from the existing repository |
| Applies to | Original implementation in [`src/`](../../src/) (April 2020) |
| Sources | [Original report](../original/MLP_DeteccionDeNumeros_OmarBaruchMoronLopez.pdf), source code, git history |
| Related | [spec.md](spec.md) · [plan.md](plan.md) |

> This intent was written **after the fact**. It captures the purpose of the project as
> evidenced by the original report and code; it does not introduce new goals for the code.

## 1. Problem

A computer should recognize **handwritten digits (0–9)** shown to a **webcam** in real
time, even though handwritten digits are not standardized (Confirmed, report *Objetivos*).

## 2. Why this project existed

The project is the deliverable for *Actividad 5 — Reconocimiento de números* of the
course *Sistemas Inteligentes* at the Universidad de Guadalajara (CUCEI)
(Confirmed, report cover). The learning purpose (Inferred from the report) was to:

- implement a multilayer perceptron and backpropagation from first principles;
- learn how to standardize image data into network inputs;
- experience the effect of hyperparameter selection on accuracy.

## 3. Desired outcomes

| ID | Outcome | Evidence of achievement |
|---|---|---|
| O-1 | A trained MLP able to classify 28×28 digit images | Training script + error plots in the report |
| O-2 | A measured accuracy on held-out data | 92.55 % reported for the best configuration |
| O-3 | A working live demo with a webcam | Application script + YouTube video linked in the report |
| O-4 | A written report with results and conclusions | Original PDF |

## 4. Users and stakeholders

| Stakeholder | Interest |
|---|---|
| Student (author) | Learn and demonstrate MLP implementation |
| Course instructor | Evaluate the activity |
| Portfolio reader (today) | Understand what was built, how, and in what context |

## 5. Constraints

- MATLAB as the implementation environment (Confirmed).
- No neural-network toolbox: the network is implemented manually (Confirmed).
- Input resolution fixed at 28×28 to match the dataset (Confirmed).
- Run interactively on a personal computer with a webcam (Confirmed/Inferred).

## 6. Non-goals

The original project did not aim to provide (Inferred from its scope):

- a reusable library, API or packaged application;
- persistence of trained models;
- automated tests, deployment or production-grade robustness.

## 7. Intent of the repository preservation effort

Separately from the original project, the later reorganization of this repository has
its own intent:

- present the project clearly as part of a technical portfolio;
- recover and document its academic context from the original report;
- **keep the original source code byte-for-byte unchanged**;
- clearly separate modern documentation from the historical implementation.
