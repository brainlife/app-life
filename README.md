[![Abcdspec-compliant](https://img.shields.io/badge/ABCD_Spec-v1.0-green.svg)](https://github.com/soichih/abcd-spec)

# brainlife/LiFE

This service Executes Linear Fascicle Evaluation ([LiFE](https://github.com/brain-life/life-1)) - statistical evaluation for brain fasicles.

## Running 

### Docker

First, create output directory and store your config.json contaning path to your input files (relative to /input that you are going to specify below)

```bash
cat > config.json << CONF
{
        "anatomy": { "t1": "/input/sub-FP/anatomy/t1.nii.gz" },
        "trac": { "ptck": "/input/sub-FP/tractography/run01_fliprot_aligned_trilin_csd_lmax10_wm_SD_PROB-NUM01-500000.tck" },
        "diff": {
                "dwi": "/input/sub-FP/dwi/run01_fliprot_aligned_trilin.nii.gz",
                "bvecs": "/input/sub-FP/dwi/run01_fliprot_aligned_trilin.bvecs",
                "bvals": "/input/sub-FP/dwi/run01_fliprot_aligned_trilin.bvals"
        },
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

* You have to run this where you have cloned this git repository. Otherwise, update `pwd`/msa to point to where you have cloned the repository.
* Replace <input directory> to where you have your input files. 
* You can specify any output directory you'd like to use, but leave `pwd` to use your current directory (you need to store config.json in this directory - the container will read from the workdir which is set to /output)

### On Command Line

Currently, this service can be launched on IU Karst cluster.

First, create your config.json

```bash
cat > config.json << CONF
{
        "anatomy": { "t1": "/input/sub-FP/anatomy/t1.nii.gz" },
        "trac": { "ptck": "/input/sub-FP/tractography/run01_fliprot_aligned_trilin_csd_lmax10_wm_SD_PROB-NUM01-500000.tck" },
        "diff": {
                "dwi": "/input/sub-FP/dwi/run01_fliprot_aligned_trilin.nii.gz",
                "bvecs": "/input/sub-FP/dwi/run01_fliprot_aligned_trilin.bvecs",
                "bvals": "/input/sub-FP/dwi/run01_fliprot_aligned_trilin.bvals"
        },
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

> TODO.. explain this a bit more..
