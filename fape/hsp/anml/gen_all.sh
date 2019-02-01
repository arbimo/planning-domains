#!/bin/bash

echo "Bash version ${BASH_VERSION}..."

for h in {1..1}
do
    for np in {3..9..1}
    do

        for nb in {1..9..1}
        do

	    ../generator.py --mode=anml --num_hoists=${h} --num_positions=${np} --num_bars=${nb} > instance/hsp.p${h}_${np}_${nb}.pb.anml
        ../generator.py --mode=anml_htn --num_hoists=${h} --num_positions=${np} --num_bars=${nb} > htn/hsp-htn.p${h}_${np}_${nb}.pb.anml
        ../generator.py --mode=anml_htn --num_hoists=${h} --num_positions=${np} --num_bars=${nb} > htn/hsp-htn-full.p${h}_${np}_${nb}.pb.anml
        done
    done    
done