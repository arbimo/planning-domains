#!/bin/bash

echo "Bash version ${BASH_VERSION}..."

for robots in {1..3}
do
    for jobs in {1..4}
    do
        for pallets in {1..4}
        do
	    for positions in {2..6}
	    do
		./generator.py --num_robots=${robots} --num_positions=${positions} --num_pallets=${pallets} --num_treatments=${jobs} > anml/majsp.p_${jobs}_${robots}_${pallets}_${positions}.pb.anml
	    done	
        done
    done    
done
