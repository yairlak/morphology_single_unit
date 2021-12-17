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

    comparisons['all_pseudowords_visual'] = {}
    comparisons['all_pseudowords_visual']['queries'] = "Stimulus_insensitive"
    comparisons['all_pseudowords_visual']['fixed_constraint'] = 'Event=="StimVisualOn" and Block==3'
    comparisons['all_pseudowords_visual']['condition_names'] = [] 
    comparisons['all_pseudowords_visual']['colors'] = []
    comparisons['all_pseudowords_visual']['sort'] = ['Case', 'Font']
    comparisons['all_pseudowords_visual']['y-tick-step'] = 4
    comparisons['all_pseudowords_visual']['level'] = 'word'
    comparisons['all_pseudowords_visual']['tmin_tmax'] = [-0.2, 0.5]
    
    comparisons['all_pseudowords_auditory'] = {}
    comparisons['all_pseudowords_auditory']['queries'] = "Stimulus_insensitive"
    comparisons['all_pseudowords_auditory']['fixed_constraint'] = 'Event=="StimAudioOn" and Block==4'
    comparisons['all_pseudowords_auditory']['condition_names'] = [] 
    comparisons['all_pseudowords_auditory']['colors'] = []
    comparisons['all_pseudowords_auditory']['sort'] = ['Case', 'Font']
    comparisons['all_pseudowords_auditory']['y-tick-step'] = 4
    comparisons['all_pseudowords_auditory']['level'] = 'word'
    comparisons['all_pseudowords_auditory']['tmin_tmax'] = [-0.2, 0.5]

    return comparisons
