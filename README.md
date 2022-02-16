# runR
## About
A little piece of code to quickly and easily run R scripts on the cluster. Useful to run R-scripts on cluster without having to think about `sbatch` parameters in detail. Also keeps track of the finished jobs (runtime, exit status, job filename etc.) and records the executed commands and requested resources in the `.out` files. 

## Preparation
`runR.sh`, `runR_helper.sh` and `slurm-overview.txt` should be placed in the `~`(home) directory. The `.sh` files need to be made executable, like `chmod -X runR.sh` and 
`chmod -X runR_helper.sh`. 

## Usage
The script works as follows. Suppose that there is a directory `dir1`, where an R-script called `samplescript.R` shall be run in, using 1 node with 10 CPUs and 1500 MB of RAM. After `cd`ing into `dir1`, the command would be:

`~/runR.sh samplescript.R 10 1500`

A job will be submitted to `slurm`, and a job ID will be printed to the screen. As soon as resources are available, the R-script will be run on the cluster. The standard output of the script will be saved to `dir1/slurm-[jobid].out`, as usual. In the first line of the `.out` file, the command that is being executed will be repeated so you can keep track of the options that were used. Moreover, once the job is finished, a job summary will be appended to `~/slum-overview.txt` and it will be checked if the job completed successfully. This is a nice way of keeping track of finished jobs and will look like this: 

```
JOB-ID  runtime      failed  CPUs  memory   directory         command  
146049  0-08:26:39   0       10    1500     /home/dir1        samplescript.R
```

### arguments
Of course, there is also the possibility of passing command line arguments. The command then needs to be enclosed in apostrophes, like:

`~/runR.sh 'samplescript.R --optiona=something --optionb=12345 -x T' 10 1500`

The arguments can then be evaluated by the R-script using for example the `getopt` package, as shown in the example script `samplescript.R`. 

### array jobs
Array jobs can be run like 

`~/runR.sh 'samplescript.R --optiona=something --optionb=12345 -x T' 10 1500 5`

This would run 5 array jobs with 10 CPUs and 1500 MB of memory each. To each instance of the job, this script passes on the argument `--taskid X`, where X is an integer number which can be evaluated by the R-script using `getopt`. This could be useful in a scenario where, for example, the same calculations need to be performed on 5 batches of the same dataset, an [embarassingly parralel](https://en.wikipedia.org/wiki/Embarrassingly_parallel) problem. The `--taskid` argument in combination with `getopt` could then be used to tell each instance of the script on which batch of data it shall operate. An example is shown in `samplescript.R`. 
