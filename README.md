[![Abcdspec-compliant](https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg)](https://github.com/brain-life/abcd-spec)
[![Run on Brainlife.io](https://img.shields.io/badge/Brainlife-bl.app.33-blue.svg)](https://doi.org/10.25663/bl.app.33)

# brainlife/LiFE

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

