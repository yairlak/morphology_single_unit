

for comparison in "all_unigrams" "all_ngrams" "all_pseudowords_visual" "all_pseudowords_auditory"; do
    for datatype in "spike"; do
	    for filt in "raw"; do
	        echo python plot_ERP_trialwise.py --patient 546 --comparison-name $comparison --data-type $datatype --filter $filt &
        done
    done
done
