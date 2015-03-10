#!/bin/bash

bashDecisionTask(){
    
    #run motion correction
	bsub -q long -W 96:00 -R "rusage[tmp=5000,mem=10000]" -o decisionTaskOut/call%I_job matlab -nodesktop -r "fitDecisionTaskOrchestra($1,$2)"
	
	}
	
#call arguments verbatim
$@