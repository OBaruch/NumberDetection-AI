# Project Context

This document reconstructs the origin and context of the project from the material
available in the repository. Every statement is tagged with its level of evidence:

- **Confirmed** – directly supported by a file in this repository.
- **Inferred** – reasonably deduced from the repository, but not stated explicitly.
- **Unknown** – cannot be determined from the repository.

## Classification

**Project origin: Academic / University Project — Coursework / Assignment** (Confirmed)

The original report (`docs/original/MLP_DeteccionDeNumeros_OmarBaruchMoronLopez.pdf`)
has a university cover page that identifies the work as a graded course activity.

## Academic details

| Item | Value | Evidence |
|---|---|---|
| University | Universidad de Guadalajara | Confirmed (report cover) |
| Campus / school | Centro Universitario de Ciencias Exactas e Ingenierías (CUCEI) | Confirmed (report cover and header logo) |
| Course | *Sistemas Inteligentes* (Smart Systems) | Confirmed (report cover and page header) |
| Instructor | M.C. José de Jesús Hernández Barragán | Confirmed (report cover) |
| Activity | *Actividad 5 — Reconocimiento de números* (Activity 5 — Number recognition) | Confirmed (report cover) |
| Author | Omar Baruch Morón López, robotics student at the University of Guadalajara | Confirmed (report cover and page header) |
| Report date | Monday, 6 April 2020 | Confirmed (page header and PDF metadata) |
| Upload to GitHub | 20 February 2021 | Confirmed (git history) |
| Original assignment statement | Not included | Unknown — only the student's report is available |

## Timeline

| Date | Event | Evidence |
|---|---|---|
| 2020-04-06 | Report written and exported from Microsoft Word to PDF | Confirmed (PDF metadata `creationDate`) |
| 2021-02-20 | Repository created (MIT License) and the three scripts plus the PDF uploaded | Confirmed (git history) |
| Later | Repository reorganized and documented; source code left unchanged | This documentation |

## Objective

The report states that the goal of the activity was to **identify handwritten digits
through the computer's webcam and tell which number is shown**, despite the complexity
of non-standardized, hand-written digits. (Confirmed, report section *Objetivos*.)

## Scope

The work covers three stages (Confirmed, report section *Desarrollo* and the code):

1. Programming a multilayer perceptron (MLP) with *n* inputs, *m* hidden neurons and
   *l* output neurons, trained with backpropagation.
2. Training it on a digit dataset described as "MNIST" (28×28 images, digits 0–9) and
   measuring accuracy on held-out samples ("generalization").
3. Running the trained network online on live webcam frames.

## Learning context

Inferred from the report's conclusion, the activity was intended to practice:

- implementing an MLP and backpropagation from scratch (no neural-network toolbox is used);
- preparing and standardizing 2-D image data into a 1-D input vector;
- tuning hyperparameters (learning rate, initial weights, iterations, hidden neurons).

## Additional historical material

- A demonstration video is linked from the report: <https://youtu.be/ikjpB5z8S34>
  (Confirmed link; the content of the video was not reviewed as part of this documentation.)
- The training/test dataset file `entrenamientoTodo.txt` is referenced by the code but is
  **not included** in the repository (Confirmed).
- The trained weights are **not included** in the repository (Confirmed).

## Related documents

- [Report summary](report.md)
- [Code overview](code-overview.md)
- [Architecture](architecture.md)
