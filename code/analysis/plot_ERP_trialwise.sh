

for comparison in "all_unigrams" "all_ngrams" "all_pseudowords"; do
    for datatype in "micro" "macro"; do
	    for filt in "raw"; do
	        echo python plot_ERP_trialwise.py --patient 546 --comparison-name $comparison --data-type $datatype --filter $filt &
        done
    done
done
