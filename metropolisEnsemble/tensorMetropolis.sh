#!/bin/bash
nohup matlab -nodisplay -nodesktop -nosplash -r "run('/home/jhass2/Code/tensorEigValues/metropolisEnsemble/testMetropolisRangeEnsemble.m'); exit;" > output.log 2>&1 &
