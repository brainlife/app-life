[![Abcdspec-compliant](https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg)](https://github.com/brain-life/abcd-spec)
[![Run on Brainlife.io](https://img.shields.io/badge/Brainlife-bl.app.33-blue.svg)](https://doi.org/10.25663/bl.app.33)

# brainlife/LiFE

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

**Evaluates a tractogram with LiFE (Linear Fascicle Evaluation), predicting a preprocessed DWI from the streamlines of a .tck file, and outputs fascicle weights and model error.**

Builds the LiFE model from the tractogram and the DWI, fits non-negative fascicle weights with the bbnnls solver, and reports the voxel-wise RMSE and the number of streamlines with non-zero weight. Use it to remove streamlines that do not contribute to predicting the diffusion signal (connectome evaluation) before further analysis. Needs a tractogram and a preprocessed DWI from the same subject, in the same space; large tractograms need substantial memory.

Run it on brainlife.io: [https://doi.org/10.25663/bl.app.104](https://doi.org/10.25663/bl.app.104)

| Input | Datatype | Required | Description |
|---|---|---|---|
| `track` | `neuro/track/tck` | yes | Whole-brain tractogram (.tck) to evaluate, in the same space as the DWI. |
| `dwi` | `neuro/dwi` | yes | you should feed preprocessed dwi. we will add preprocessed datatype tag once we have most preprocessed dwi tagged with "preprocessed" |

| Output | Datatype | Description |
|---|---|---|
| `fe` | `neuro/LiFE` | LiFE model (output_fe.mat) with the fitted fascicle weights and voxel-wise RMSE, plus a subsampled JSON of the non-zero-weight streamlines for visualisation. |

| Parameter | Type | Default | Description |
|---|---|---|---|
| `life_discretization` | number | `360` | Number of discretised orientations used to build the LiFE fascicle model (feConnectomeInit). |
| `num_iterations` | number | `100` | Number of iterations of the bbnnls solver used to fit the LiFE model weights. |

Runtime: container `brainlife/mcr:r2019a`; 10 CPUs.

<!-- brainlife-app:end -->

This service Executes Linear Fascicle Evaluation ([LiFE](https://github.com/brain-life/life-1)) - statistical evaluation for brain fasicles.

### Authors
- Soichi Hayashi (hayashis@iu.edu)
- Franco Pestilli (franpest@indiana.edu)

### Project director
- Franco Pestilli (franpest@indiana.edu)

### Funding 
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-1636893](https://img.shields.io/badge/NSF_BCS-1636893-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1636893)

## Running 

### Docker

First, create output directory and store your config.json contaning path to your input files (relative to /input that you are going to specify below)

```bash
cat > config.json << CONF
{
        "t1": "/input/sub-FP/anatomy/t1.nii.gz",
        "track": "/input/sub-FP/tractography/run01_fliprot_aligned_trilin_csd_lmax10_wm_SD_PROB-NUM01-500000.tck",
	"dwi": "/input/sub-FP/dwi/run01_fliprot_aligned_trilin.nii.gz",
	"bvecs": "/input/sub-FP/dwi/run01_fliprot_aligned_trilin.bvecs",
	"bvals": "/input/sub-FP/dwi/run01_fliprot_aligned_trilin.bvals",
        "life_discretization": 360,
        "num_iterations": 100
}
CONF
```

Then, launch brainlife/life

```bash
docker run --rm -it \
	-v /mnt/v1/testdata:/input \
	-v `pwd`:/output \
	brainlife/life
```

* Replace `/mnt/v1/testdata` to where you have your input files. 
* Replace `pwd` to point to your output directory (if you don't want them to go to your current working directory). If you change this, be sure to move your config.json there also. This container starts up with current directory set to /output.

### On Command Line

Currently, this service can be launched on IU Karst cluster.

First, create your config.json

```bash
cat > config.json << CONF
{
        "t1": "/input/sub-FP/anatomy/t1.nii.gz",
        "track": "/input/sub-FP/tractography/run01_fliprot_aligned_trilin_csd_lmax10_wm_SD_PROB-NUM01-500000.tck",
	"dwi": "/input/sub-FP/dwi/run01_fliprot_aligned_trilin.nii.gz",
	"bvecs": "/input/sub-FP/dwi/run01_fliprot_aligned_trilin.bvecs",
	"bvals": "/input/sub-FP/dwi/run01_fliprot_aligned_trilin.bvals",
        "life_discretization": 360,
        "num_iterations": 100
}
CONF
```

Then, execute `start.sh` which will submit a job to PBS queue.

## Output

The main output will be a file called `output_fe.mat`. This file contains following object.

```
fe = 

    name: 'temp'
    type: 'faseval'
    life: [1x1 struct]
      fg: [1x1 struct]
     roi: [1x1 struct]
    path: [1x1 struct]
     rep: []
```

`output_fg.pdb` contains all fasicles with >0 weights withtin fg object (fibers)

> TODO.. explain this a bit more..

## Shared Library

Content under /msa-shared can be used to run LiFE as part of another application. It is created by compiling LiFE using `libraryCompiler`
> https://www.mathworks.com/help/compiler_sdk/gs/create-a-cc-application-with-matlab-code.html

