#!/bin/bash

if [ -z "$4" ] || [ "$4" -lt 2 ]; then
	echo running script "$1" with $2 CPUs and $3 mem
	echo calling helper
	sbatch -c $2 --mem $3 $HOME/runR_helper.sh "$1" $2 $3
else
	echo running script "$1" with $2 CPUs and $3 mem in $4 instances
	echo calling helper
	sbatch -c $2 --mem $3 --array=1-$4 $HOME/runR_helper.sh "$1" $2 $3
fi

echo "***** WRAPPER DONE *****"