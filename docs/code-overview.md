# Code Overview

Walkthrough of the three original MATLAB scripts in [`src/`](../src/). The code is
described as-is; **nothing in it has been changed**. Identifiers and comments are in
Spanish in the original; English explanations are given here.

| Script | Stage | Report annex |
|---|---|---|
| [`MLP_Entrenamiento_DeteccionDeNumeros.m`](../src/MLP_Entrenamiento_DeteccionDeNumeros.m) | Training | Annex 1 |
| [`MLP_Generalizacion_DeteccionDeNumeros.m`](../src/MLP_Generalizacion_DeteccionDeNumeros.m) | Generalization (test accuracy) | Annex 2 |
| [`MLP_Aplicacion_DeteccionDeNumeros.m`](../src/MLP_Aplicacion_DeteccionDeNumeros.m) | Online webcam application | Annex "4" |

The scripts are meant to be run **in this order within the same MATLAB session**,
because they exchange data through workspace variables rather than files
(see [architecture](architecture.md)).

## Network at a glance

| Element | Value | Variable |
|---|---|---|
| Inputs | 784 (28×28 pixels) + bias | `nP` |
| Hidden layer | 50 neurons, `tanh` activation | `nO`, `wO` (785×50) |
| Output layer | 10 neurons (digits 0–9), logistic sigmoid | `nS`, `wS` (51×10) |
| Target encoding | One-hot vector of length 10 | `d` |
| Learning | Online (per-sample) backpropagation, gradient descent | `eta = 0.2` |
| Epochs | 300 | outer `for i=1:300` |
| Weight init | `rand(...)*0.001` (uniform in [0, 0.001)) | `wO`, `wS` |

## Dataset format expected by the code

The dataset file `entrenamientoTodo.txt` is **not in the repository**. Its layout can be
inferred from how the code indexes it:

- Read with `dlmread` → a numeric, delimiter-separated text matrix (Confirmed).
- One sample per **row** (Confirmed: rows `1:40000` for training, `40001:end` for test).
- Columns `1:end-10` are the pixel inputs; the last 10 columns are the one-hot label
  (Confirmed).
- 784 pixel columns (28×28), flattened row by row (Inferred from the report and from the
  `reshape(im', ...)` used in the application).
- Pixel values scaled to [0, 1] with white digits on a black background, like MNIST
  (Inferred: the application feeds values in [0, 1] with the digit set to white).
- 50,000 rows in total (Inferred from the report; the code only requires > 40,000).

## Training script

`MLP_Entrenamiento_DeteccionDeNumeros.m`

1. `clearvars -except data; close all; clc;` — clears everything except a previously
   loaded `data` matrix.
2. `data = dlmread('entrenamientoTodo.txt');` — loads the dataset from the current folder.
3. Defines `sigmoide = @(v) 1./(1+exp(-v))` as a vectorized anonymous function.
4. Splits the first 40,000 rows into inputs `xd` (784×40000) and targets `d` (10×40000),
   both transposed so each **column** is one sample.
5. Initializes `wO` (785×50) and `wS` (51×10) with small random values; row 1 of each is
   the bias weight.
6. For 300 epochs, iterates over every sample `k`:
   - **Forward pass:** `xO=[1; x]`, `yO=tanh(wO'*xO)`, `xS=[1; yO]`, `yS=sigmoide(wS'*xS)`.
   - **Error:** `e = d(:,k) - yS`, accumulated (signed) into `eA`.
   - **Backward pass:** `deltaS = e.*yS.*(1-yS)` (sigmoid derivative);
     `deltaO = (1-yO).*(1+yO).*(wS(2:end,:)*deltaS)` (tanh derivative, bias row excluded).
   - **Update:** `wS += eta*(deltaS*xS')'`, `wO += eta*(deltaO*xO')'`.
   - The epoch number `i` is printed to the console on every epoch.
7. Stores each epoch's accumulated error vector in `eVector` (10×300) and plots one figure
   per output neuron titled `Erro en la salida: <digit>` (the `sal-1` offset maps output
   index 1–10 to digits 0–9, as the in-code comment explains).

**Outputs left in the workspace:** `data`, `wO`, `wS`, `eVector` and training variables.
No file is written.

## Generalization script

`MLP_Generalizacion_DeteccionDeNumeros.m`

1. The `dlmread` line is commented out: the script **reuses `data`, `wO` and `wS`** from
   the workspace left by the training script.
2. Uses rows `40001:end` as the test set.
3. For each test sample, runs the same forward pass (`tanh` hidden, sigmoid output).
4. Counts a prediction as correct when `round(yS')` equals the one-hot target. Because
   MATLAB's `if` on an array is true only when **all** elements are true, a sample only
   counts when **all 10 rounded outputs** match the target exactly. This is stricter than
   an arg-max comparison (Confirmed by MATLAB semantics). The arg-max `ic` is computed but
   not used.
5. Prints `El procentaje de aciertos es:` ("The percentage of hits is:") followed by
   `100*correctos/nK`.

The loop bound is `length(xd)`, which returns the larger dimension of `xd`; it equals the
number of test samples as long as there are at least 784 of them.

## Online application script

`MLP_Aplicacion_DeteccionDeNumeros.m`

1. `clearvars -except wS wO data` — keeps only the trained weights and the dataset.
2. Sets the target resolution `taFilPix = taColuPix = 28`.
3. Detects the installed image-acquisition adaptor with `imaqhwinfo`, opens it with
   `videoinput(...)` and shows a live `preview`. The code assumes a single installed
   adaptor (Inferred from `string(inf.InstalledAdaptors)`); `infCam` is queried but not used.
4. Runs 10,000 iterations of:
   - `getsnapshot(cam)` → frame;
   - `PrepararImagen(...)` → 28×28 image in [0, 1];
   - `imshow` of the processed image;
   - `x = reshape(im', 784, [])` — transposed before reshaping so pixels are taken **row by
     row**, matching the dataset. The column-major alternative is left commented out
     (this is the issue discussed in the report's conclusion);
   - `pause(.01)`;
   - forward pass and `max` over the outputs;
   - `disp` of the digit name in Spanish: `CERO`, `UNO`, `DOS`, `TRES`, `CUATRO`,
     `CINCO`, `SEIS`, `SIETE`, `OCHO`, `NUEVE` (0–9).
5. `closepreview(cam)` at the top of the file is commented out.

### Local function `PrepararImagen(imagen, tamanioColumnasEnPixeles, tamanioFilasEnPixeles)`

1. Converts the RGB frame to grayscale (`rgb2gray`).
2. Pixel-by-pixel threshold at 100: dark pixels (≤ 100, i.e. ink) become 255 and bright
   pixels (paper) become 0. This both **binarizes and inverts** the image so the digit is
   white on black, like MNIST.
3. Resizes to 28×28 with `imresize` and scales to [0, 1] by dividing by 255.

An earlier approach (`rgb2gray` → `imcomplement` → `normalize(...,'range')`) is kept as
comments at the top of the function.

Note: the parameter names are swapped relative to their use (`tamanioColumnasEnPixeles`
is passed as the number of rows to `imresize`); this has no effect because both values
are 28.

## Dependencies observed in the code

| Dependency | Used for | Evidence |
|---|---|---|
| MATLAB | Everything | Confirmed (`.m` files, MATLAB syntax) |
| MATLAB R2016b or newer | Local functions inside a script and `string(...)` | Inferred (language features introduced in R2016b) |
| Image Acquisition Toolbox (+ a camera adaptor/support package) | `imaqhwinfo`, `videoinput`, `preview`, `getsnapshot` | Confirmed functions; exact adaptor Unknown |
| Image Processing Toolbox | `imresize` (and, depending on the release, `rgb2gray`/`imshow`) | Inferred |
| Deep Learning / Neural Network Toolbox | Not used — the MLP is implemented manually | Confirmed |

## Console and figure outputs

| Script | Output |
|---|---|
| Training | Epoch counter printed each epoch; 10 figures with per-output error curves |
| Generalization | Accuracy percentage printed to the console |
| Application | Live camera preview, processed 28×28 image, detected digit name printed to the console |
