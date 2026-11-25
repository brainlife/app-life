<h1 align="center">LiFE: Linear Fascicle Evaluation</h1>

<p align="center">
  Fascicle weights and model error for a tractogram, from how well its streamlines predict the measured diffusion signal.
</p>

<p align="center">
  <a href="https://github.com/brainlife/abcd-spec"><img src="https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg" alt="ABCD Spec v1.1"></a>
  <a href="https://doi.org/10.25663/bl.app.104"><img src="https://img.shields.io/badge/Brainlife-bl.app.104-blue.svg" alt="Run on brainlife.io"></a>
  <a href="https://github.com/brainlife/app-life/blob/master/LICENSE"><img src="https://img.shields.io/badge/License-MIT-lightgrey.svg" alt="MIT license"></a>
</p>

> **This branch, `1.10`, runs 2 brainlife.io Apps** that share the same code:
>
> - LiFE (dwi) ([doi:10.25663/bl.app.104](https://doi.org/10.25663/bl.app.104))
> - LiFE with dtiInit ([doi:10.25663/bl.app.1](https://doi.org/10.25663/bl.app.1))
>
> The other Apps in this repository are listed under **Versions on brainlife.io** below.

## At a glance

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

### LiFE (dwi)

> **Evaluates a tractogram with LiFE (Linear Fascicle Evaluation), predicting a preprocessed DWI from the streamlines of a .tck file, and outputs fascicle weights and model error.**

Builds the LiFE model from the tractogram and the DWI, fits non-negative fascicle weights with the bbnnls solver, and reports the voxel-wise RMSE and the number of streamlines with non-zero weight. Use it to remove streamlines that do not contribute to predicting the diffusion signal (connectome evaluation) before further analysis. Needs a tractogram and a preprocessed DWI from the same subject, in the same space; large tractograms need substantial memory.

| | |
|---|---|
| **Inputs** | `neuro/track/tck` · `neuro/dwi` |
| **Outputs** | `neuro/LiFE` |
| **Container** | `brainlife/mcr:r2019a` |
| **Resources** | 10 CPUs |
| **Run it** | [doi.org/10.25663/bl.app.104](https://doi.org/10.25663/bl.app.104) |

#### Inputs

| Input | Datatype | Required | Description |
|---|---|---|---|
| `track` | `neuro/track/tck` | yes | Whole-brain tractogram (.tck) to evaluate, in the same space as the DWI. |
| `dwi` | `neuro/dwi` | yes | you should feed preprocessed dwi. we will add preprocessed datatype tag once we have most preprocessed dwi tagged with "preprocessed" |

#### Outputs

| Output | Datatype | Description |
|---|---|---|
| `fe` | `neuro/LiFE` | LiFE model (output_fe.mat) with the fitted fascicle weights and voxel-wise RMSE, plus a subsampled JSON of the non-zero-weight streamlines for visualisation. |

<details>
<summary><b>Parameters</b> (2)</summary>

| Parameter | Type | Default | Description |
|---|---|---|---|
| `life_discretization` | number | `360` | Number of discretised orientations used to build the LiFE fascicle model (feConnectomeInit). |
| `num_iterations` | number | `100` | Number of iterations of the bbnnls solver used to fit the LiFE model weights. |

</details>

### LiFE with dtiInit

> **Evaluates a tractogram with LiFE (Linear Fascicle Evaluation), predicting the diffusion signal from the streamlines of a .tck file and dtiInit-aligned DWI, and outputs fascicle weights and model error.**

Builds the LiFE model from the tractogram and the aligned DWI found in the dtiInit output, fits non-negative fascicle weights with the bbnnls solver, and reports the voxel-wise RMSE and the number of streamlines with non-zero weight. Use it to remove streamlines that do not contribute to predicting the diffusion signal (connectome evaluation) before further analysis. Needs a tractogram and a dtiInit output from the same subject, in the same space; large tractograms need substantial memory.

| | |
|---|---|
| **Inputs** | `neuro/track/tck` · `neuro/dtiinit` |
| **Outputs** | `neuro/LiFE` |
| **Container** | `brainlife/mcr:r2019a` |
| **Resources** | 10 CPUs |
| **Run it** | [doi.org/10.25663/bl.app.1](https://doi.org/10.25663/bl.app.1) |

#### Inputs

| Input | Datatype | Required | Description |
|---|---|---|---|
| `track` | `neuro/track/tck` | yes | Whole-brain tractogram (.tck) to evaluate, in the same space as the DWI. |
| `dtiinit` | `neuro/dtiinit` | yes | vistasoft dtiInit output; its aligned DWI (dt6.json alignedDwRaw) is the signal LiFE predicts. |

#### Outputs

| Output | Datatype | Description |
|---|---|---|
| `fe` | `neuro/LiFE` | LiFE model (output_fe.mat) with the fitted fascicle weights and voxel-wise RMSE, plus a subsampled JSON of the non-zero-weight streamlines for visualisation. |

<details>
<summary><b>Parameters</b> (2)</summary>

| Parameter | Type | Default | Description |
|---|---|---|---|
| `life_discretization` | integer | `360` | Number of discretised orientations used to build the LiFE fascicle model (feConnectomeInit). |
| `num_iterations` | integer | `100` | Number of iterations of the bbnnls solver used to fit the LiFE model weights. |

</details>

<!-- brainlife-app:end -->

## Versions on brainlife.io

Both Apps are built from the same branch and differ only in how the diffusion data are provided.

| App | Diffusion input | Branch | Run it | Status |
|---|---|---|---|---|
| **LiFE (dwi)** (this branch) | `neuro/dwi` (preprocessed) | [`1.10`](https://github.com/brainlife/app-life/tree/1.10) | [doi:10.25663/bl.app.104](https://doi.org/10.25663/bl.app.104) | current |
| **LiFE with dtiInit** (this branch) | `neuro/dtiinit` | [`1.10`](https://github.com/brainlife/app-life/tree/1.10) | [doi:10.25663/bl.app.1](https://doi.org/10.25663/bl.app.1) | available |

## Running the App

### On brainlife.io

Open the App at [doi.org/10.25663/bl.app.104](https://doi.org/10.25663/bl.app.104) (or [doi.org/10.25663/bl.app.1](https://doi.org/10.25663/bl.app.1) for a dtiInit input), choose a whole-brain `neuro/track/tck` tractogram and the preprocessed diffusion data of the same subject, in the same space, and press **Execute**.

The App runs [LiFE](https://github.com/brain-life/life-1): it builds the fascicle model from the tractogram and the DWI (`life_discretization`, default 360 orientations), fits non-negative fascicle weights with the bbnnls solver (`num_iterations`, default 100), and reports the voxel-wise RMSE and the number of streamlines with non-zero weight. The result is a `neuro/LiFE` dataset. Use it to remove streamlines that do not contribute to predicting the diffusion signal (connectome evaluation) before further analysis. Large tractograms need substantial memory.

### Locally

You need [Singularity/Apptainer](https://apptainer.org/). The compiled MATLAB code runs inside the MATLAB Runtime R2019a container.

1. Clone this repository and check out the branch brainlife.io runs: `git checkout 1.10`.
2. Create `config.json` with the paths to your inputs (for a dtiInit input, replace `dwi` with `"dtiinit": "/input/dtiinit"`):

   ```json
   {
       "track": "/input/track/track.tck",
       "dwi": "/input/dwi/dwi.nii.gz",
       "life_discretization": 360,
       "num_iterations": 100
   }
   ```

3. Run the App:

   ```bash
   ./main
   ```

## Outputs

```text
output_fe.mat                    LiFE model (fe): fascicle weights, fit and voxel-wise RMSE
tracts/subsampledtracts.json     30% subsample of the non-zero-weight streamlines, for visualisation
life_results.json                summary statistics (input and non-zero-weight streamline counts)
product.json                     plots and statistics shown on brainlife.io
```

## Troubleshooting

- **`output_fe.mat missing`**: the LiFE fit did not complete. Check the log; make sure the tractogram and DWI are aligned and that enough memory is available.

## Citing

> [!TIP]
> If you use this App in your work, please cite the App, the software it builds on and brainlife.io (below). GitHub's **Cite this repository** button gives the App citation in APA and BibTeX.

- LiFE (dwi). brainlife.io App. [doi:10.25663/bl.app.104](https://doi.org/10.25663/bl.app.104)
- LiFE with dtiInit. brainlife.io App. [doi:10.25663/bl.app.1](https://doi.org/10.25663/bl.app.1)
- Pestilli et al. Evaluation and statistical inference for human connectomes. *Nature Methods* 11:1058-1063 (2014). [doi:10.1038/nmeth.3098](https://doi.org/10.1038/nmeth.3098)
- Hayashi S, Caron BA, Heinsfeld AS, et al. brainlife.io: a decentralized and open-source cloud platform to support neuroscience research. *Nature Methods* 21:809–813 (2024). [doi:10.1038/s41592-024-02237-2](https://doi.org/10.1038/s41592-024-02237-2)
- Avesani P, McPherson B, Hayashi S, et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. *Scientific Data* 6:69 (2019). [doi:10.1038/s41597-019-0073-y](https://doi.org/10.1038/s41597-019-0073-y)

## Authors

- Franco Pestilli (project director)
- Soichi Hayashi

**Contributors:** Lindsey Kitchell, Brent McPherson, Brad Caron, Ariel Rokem, Brian Wandell, Hiromasa Takemura

## Funding

[![Wellcome-226486/Z/22/Z](https://img.shields.io/badge/Wellcome-226486%2FZ%2F22%2FZ-purple.svg)](https://wellcome.org/)
[![NIH-NINDS-U24NS140384](https://img.shields.io/badge/NIH_NINDS-U24NS140384-green.svg)](https://reporter.nih.gov/project-details/11261037)
[![NIH-NINDS-UM1NS132207](https://img.shields.io/badge/NIH_NINDS-UM1NS132207-green.svg)](https://reporter.nih.gov/project-details/11411328)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://reporter.nih.gov/project-details/10262925)
[![NIH-NIBIB-R01EB030896](https://img.shields.io/badge/NIH_NIBIB-R01EB030896-green.svg)](https://reporter.nih.gov/project-details/10428625)
[![NIH-NIMH-R01MH126699](https://img.shields.io/badge/NIH_NIMH-R01MH126699-green.svg)](https://reporter.nih.gov/project-details/10460628)
[![NIH-NIDCD-R01DC020088](https://img.shields.io/badge/NIH_NIDCD-R01DC020088-green.svg)](https://reporter.nih.gov/project-details/11140284)
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-2203524](https://img.shields.io/badge/NSF_BCS-2203524-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2203524)
[![NSF-IIS-1636893](https://img.shields.io/badge/NSF_IIS-1636893-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-OAC-2148729](https://img.shields.io/badge/NSF_OAC-2148729-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148729)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NSF-IIS-2148700](https://img.shields.io/badge/NSF_IIS-2148700-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148700)
[![NSF-OAC-1916518](https://img.shields.io/badge/NSF_OAC-1916518-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1916518)

<sub>brainlife.io is publicly funded, and acknowledging that support helps keep it running. This App was developed with support from Wellcome, the U.S. National Institutes of Health (including the BRAIN Initiative BRAIN CONNECTS program: The Axonal Projectome EXchange, U24NS140384, and the Center for Mesoscale Connectomics, UM1NS132207) and the U.S. National Science Foundation.</sub>

## License

[MIT](https://github.com/brainlife/app-life/blob/master/LICENSE).
