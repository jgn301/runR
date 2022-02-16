#!/bin/bash
echo helper: running script $1 with $2 CPUs and $3 mem.

if [ -z $SLURM_ARRAY_TASK_COUNT ]; then
	SLURM_ARRAY_TASK_COUNT=1
fi	

if (($SLURM_ARRAY_TASK_COUNT > 1)); then
	echo part of an array job. SLURM_ARRRAY_TASK_ID is $SLURM_ARRAY_TASK_ID
fi
SECONDS=0

if (($SLURM_ARRAY_TASK_COUNT > 1)); then
	if Rscript $1 --taskid $SLURM_ARRAY_TASK_ID; then
		ret=0
	else
		ret=1
	fi
else
	if Rscript $1; then
		ret=0
	else
		ret=1
	fi
fi	

dr=$((SECONDS % (24*60*60)))
dy=$((SECONDS / (24*60*60)))
runtime=$(TZ=UTC0 printf '%(%H:%M:%S)T' $dr)

echo -e "$SLURM_JOB_ID\t$dy-$runtime\t$ret\t$2\t$3\t$PWD\t$1" >> $HOME/slurm-overview.txt
echo "***** DONE *****"