# Architecture

The project is small: three MATLAB scripts that form a sequential workflow and share
state through the **MATLAB workspace** rather than through files or functions. There
are no modules, packages, services or persisted models.

## Workflow

```mermaid
flowchart LR
    DS[("entrenamientoTodo.txt<br/>(not in repo)")] -->|dlmread| T

    subgraph WS["Same MATLAB session / workspace"]
        T["1 · Training<br/>MLP_Entrenamiento_…m<br/>rows 1–40,000"]
        G["2 · Generalization<br/>MLP_Generalizacion_…m<br/>rows 40,001–end"]
        A["3 · Online application<br/>MLP_Aplicacion_…m"]
        T -->|"data, wO, wS"| G
        T -->|"data, wO, wS"| A
    end

    T --> F["10 error-per-epoch figures"]
    G --> P["Accuracy % (console)"]
    CAM(["Webcam"]) -->|getsnapshot| A
    A --> D["Detected digit name (console)"]
```

- **Training** is the only stage that reads from disk and the only one that creates
  the weights `wO` and `wS`.
- **Generalization** depends on `data`, `wO` and `wS` already being in the workspace.
- **Application** explicitly clears every variable except `wS`, `wO` and `data`, so it
  also depends on a previous training run in the same session.

## Model structure

```mermaid
flowchart LR
    I["Input<br/>784 pixels + bias"] -->|"wO (785×50)"| H["Hidden layer<br/>50 neurons · tanh"]
    H -->|"+ bias · wS (51×10)"| O["Output layer<br/>10 neurons · sigmoid"]
    O --> Y["argmax → digit 0–9"]
```

## Online inference pipeline

```mermaid
flowchart LR
    S["RGB snapshot"] --> G1["rgb2gray"]
    G1 --> B["Threshold at 100<br/>(binarize + invert)"]
    B --> R["imresize 28×28"]
    R --> N["÷ 255 → [0,1]"]
    N --> F["reshape(im', 784, 1)<br/>row-major flatten"]
    F --> M["MLP forward pass"]
    M --> L["disp(digit name)"]
```

## Architectural characteristics (as implemented)

| Aspect | Observation |
|---|---|
| Coupling | Scripts are coupled through implicit workspace variables (`data`, `wO`, `wS`). |
| Duplication | The forward pass is written out in each of the three scripts. |
| Persistence | None; weights live only in memory for the duration of the session. |
| Configuration | Hyperparameters and sizes are literals inside the scripts. |
| Entry points | Each script is run manually from the MATLAB environment. |

These characteristics are recorded here to explain the original design; possible
alternatives are listed separately in [possible improvements](possible-improvements.md).
