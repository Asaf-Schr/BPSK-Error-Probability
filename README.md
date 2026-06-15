# BPSK Error Probability: Gaussian vs. Laplace Noise

Analysis and simulation of symbol error probability for a **BPSK** constellation
transmitted over an additive white noise channel, under two noise models:
**Gaussian** and **Laplace**. The project pairs closed-form analytical
derivations with a MATLAB simulation, and confirms that the two agree.

---

## Problem setup

The channel is memoryless and additive:

$$R_n = S_n + W_n, \qquad S_n \in \{-\sqrt{E_s},\, +\sqrt{E_s}\}$$

with equally likely symbols, $\mathbb{P}(S_n=+\sqrt{E_s}) = \mathbb{P}(S_n=-\sqrt{E_s}) = 0.5$.
The noise $W_n$ has zero mean and variance $N_0/2$, and is modeled either as
Gaussian or as Laplace. The signal-to-noise ratio per symbol is
$\mathrm{SNR} = E_s / N_0$.

The receiver uses the **MAP** decision rule, which here coincides with **ML**
(equal priors) and with the **minimum-distance detector**.

---

## Key results

For both noise distributions, the optimal decision boundary is the **threshold
$r = 0$**, a purely geometric consequence of the symmetric noise and equal
priors, independent of the specific distribution. The decision regions are:

$$\hat{S}(r) = \begin{cases} +\sqrt{E_s}, & r > 0 \\ -\sqrt{E_s}, & r < 0 \end{cases}$$

The average error probabilities are fully **closed-form**:

| Noise | Error probability |
|-------|-------------------|
| Gaussian | $P_e^{\mathrm{Gauss}} = Q\!\left(\sqrt{2\,\mathrm{SNR}}\right)$ |
| Laplace  | $P_e^{\mathrm{Lap}} = \tfrac{1}{2}\, e^{-2\sqrt{\mathrm{SNR}}}$ |

**Which noise is "worse"?** It depends on the SNR. The two curves cross at
$\mathrm{SNR} \approx 1.41$ (the exact value requires numerical root-finding,
since $Q(\cdot)$ has no elementary inverse). The qualitative high-SNR behavior,
however, can be proven analytically: applying the Chernoff bound
$Q(u) \le \tfrac{1}{2} e^{-u^2/2}$ shows that the Gaussian error decays faster,
so **Gaussian noise yields the lower error probability at high SNR**.

---

## Repository structure

```
.
├── main.m                 # Simulation (Gaussian + Laplace channels)
├── laprnd.m               # i.i.d. Laplace random number generator
├── doc/
│   └── analysis.pdf       # Full analytical write-up (sections 1.1.1 to 1.1.5)
└── README.md
```

---

## Running the simulation

Requirements: **MATLAB** (no toolboxes needed beyond base).

```matlab
% From the repository root:
run('main.m')
```

The script:

1. Generates $10^5$ BPSK symbols with equal priors.
2. Transmits them over the Gaussian channel for $\mathrm{SNR} = -6 : 6$ dB,
   decodes with the MAP rule, and measures the empirical error rate.
3. Repeats for the Laplace channel (noise drawn via `laprnd.m`).
4. Plots the empirical error curves against the closed-form analytical
   expressions, on a single figure, for direct comparison.

The simulated curves track the analytical ones across the full SNR range, and
reproduce the crossover predicted by the analysis.

---

## Analytical write-up

The full derivation lives in [`doc/analysis.pdf`](doc/analysis.pdf) and covers:

- **1.1.1 / 1.1.3**: MAP decision rule and optimal decision regions for
  Gaussian and Laplace noise.
- **1.1.2 / 1.1.4**: Closed-form average error probability for each model.
- **1.1.5**: Comparison of the two error curves, the crossover, and the
  high-SNR dominance argument.

---

## Acknowledgments

Developed as part of the course **Introduction to Modern Communications** at
Ben-Gurion University of the Negev, taught by **Prof. Kobi Cohen**.
