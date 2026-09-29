# Possible Improvements

> **These improvements have NOT been applied.** The source code in [`src/`](../src/) is
> deliberately preserved exactly as it was originally written, to retain the historical
> context and the original development approach. This list exists only as a reference
> for a hypothetical future version of the project.

## Reproducibility

- **Persist the trained model.** Save `wO` and `wS` with `save` after training and
  `load` them in the other scripts, instead of relying on the shared workspace.
- **Document or include the dataset.** Record the exact source of the 50,000-sample file
  and the script used to convert it to `entrenamientoTodo.txt`, or provide a loader for
  the official MNIST files.
- **Seed the random generator** (`rng(...)`) so training runs are repeatable.

## Correctness and evaluation

- **Use arg-max accuracy.** The generalization script counts a hit only when all 10
  rounded outputs equal the one-hot target; comparing `argmax(yS)` with the true label is
  the usual metric. Every sample that passes the strict check is also correct under
  arg-max, so the arg-max accuracy is always greater than or equal to the reported value.
- **Loop over `size(xd,2)`** instead of `length(xd)`, which depends on the test set having
  at least 784 samples.
- **Track a proper loss.** The plotted error is the signed sum of errors, so positive and
  negative errors cancel out; mean squared error or cross-entropy would be more informative.
- **Shuffle the samples** each epoch to reduce order effects in online gradient descent.
- **Center the initial weights** (e.g. `(rand-0.5)*scale` or Xavier initialization)
  instead of using only positive values in [0, 0.001).

## Code structure

- Extract the forward pass into a single function reused by all three scripts.
- Move hyperparameters (hidden size, eta, epochs, split index) to one configuration block.
- Replace the `if/elseif` chain that prints digit names with a lookup array.
- Vectorize `PrepararImagen` (`img_gray = uint8(img_gray <= 100) * 255;`) instead of
  looping over every pixel.
- Remove unused variables (`infCam`, `ic` in the generalization script).
- Use English or consistent Spanish identifiers and fix typos in comments.

## Application robustness

- Allow choosing the camera adaptor/device instead of assuming a single installed adaptor.
- Release the camera at the end (`closepreview`, `delete(cam)`) and allow a clean exit
  instead of a fixed 10,000-iteration loop.
- Center and crop the digit (bounding box) before resizing, as MNIST digits are
  size-normalized and centered; this usually improves real-world recognition.
- Use adaptive thresholding (e.g. Otsu via `imbinarize`) instead of a fixed threshold of 100.

## Modernization options

- Port to Python (NumPy) or use MATLAB's Deep Learning Toolbox for comparison.
- Replace the MLP with a small convolutional network for higher accuracy.
