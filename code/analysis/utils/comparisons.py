def comparison_list():
    comparisons = {}
    
# ALL WORDS
    comparisons['all_unigrams'] = {}
    comparisons['all_unigrams']['queries'] = "Stimulus_insensitive"
    comparisons['all_unigrams']['fixed_constraint'] = 'Event=="StimVisualOn" and Block==1'
    comparisons['all_unigrams']['condition_names'] = [] 
    comparisons['all_unigrams']['colors'] = []
    comparisons['all_unigrams']['sort'] = ['Case', 'Font']
    comparisons['all_unigrams']['y-tick-step'] = 4
    comparisons['all_unigrams']['level'] = 'word'
    comparisons['all_unigrams']['tmin_tmax'] = [-0.2, 0.5]

    comparisons['all_ngrams'] = {}
    comparisons['all_ngrams']['queries'] = "Stimulus_insensitive"
    comparisons['all_ngrams']['fixed_constraint'] = 'Event=="StimVisualOn" and Block==2'
    comparisons['all_ngrams']['condition_names'] = [] 
    comparisons['all_ngrams']['colors'] = []
    comparisons['all_ngrams']['sort'] = ['Case', 'Font']
    comparisons['all_ngrams']['y-tick-step'] = 4
    comparisons['all_ngrams']['level'] = 'word'
    comparisons['all_ngrams']['tmin_tmax'] = [-0.2, 0.5]

    comparisons['all_pseudowords'] = {}
    comparisons['all_pseudowords']['queries'] = "Stimulus_insensitive"
    comparisons['all_pseudowords']['fixed_constraint'] = 'Event=="StimVisualOn" and Block==3'
    comparisons['all_pseudowords']['condition_names'] = [] 
    comparisons['all_pseudowords']['colors'] = []
    comparisons['all_pseudowords']['sort'] = ['Case', 'Font']
    comparisons['all_pseudowords']['y-tick-step'] = 4
    comparisons['all_pseudowords']['level'] = 'word'
    comparisons['all_pseudowords']['tmin_tmax'] = [-0.2, 0.5]

    return comparisons
