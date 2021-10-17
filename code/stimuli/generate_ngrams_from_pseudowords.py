#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Oct 17 12:08:05 2021

@author: yl254115
"""
import os

path2stimuli = '../../stimuli/visual/'
n_repetitions = 6

with open(os.path.join(path2stimuli, 'pseudowords.csv'), 'r') as f:
    lines = f.readlines()
target_stimuli = [l.split(',')[1].strip() for l in lines 
                  if l.split(',')[2].strip() == 'target']
control_stimuli = [l.split(',')[1].strip() for l in lines 
                   if l.split(',')[2].strip() == 'control']

def get_bigrams(stimuli):
    bigrams = [s[i]+s[i+1] for s in stimuli 
               for i, c in enumerate(s[:-1])]
    return list(set(bigrams))

def get_trigrams(stimuli):
    trigrams = [s[i]+s[i+1]+s[i+2] for s in stimuli 
                for i, c in enumerate(s[:-2])]
    return list(set(trigrams))

def get_quadrigrams(stimuli):
    quadrigrams = [s[i]+s[i+1]+s[i+2]+s[i+3] for s in stimuli 
                   for i, c in enumerate(s[:-3])]
    return list(set(quadrigrams))


# BIGRAMS
target_bigrams = get_bigrams(target_stimuli)
control_bigrams = get_bigrams(control_stimuli)
all_bigrams = list(set(target_bigrams + control_bigrams))
print(f'Number of bigrams {len(all_bigrams)}')
print(f'Total time: {n_repetitions*len(all_bigrams)/3/60}')
with open(os.path.join(path2stimuli, 'bigrams.csv'), 'w') as f:
    for ngram in sorted(all_bigrams):
        f.write(f'{ngram}\n')

# TRIGRAMS
target_trigrams = get_trigrams(target_stimuli)
control_trigrams = get_trigrams(control_stimuli)
all_trigrams = list(set(target_trigrams + control_trigrams))
print(f'Number of trigrams {len(all_trigrams)}')
print(f'Total time: {n_repetitions*len(all_trigrams)/3/60}')
with open(os.path.join(path2stimuli, 'trigrams.csv'), 'w') as f:
    for ngram in sorted(all_trigrams):
        f.write(f'{ngram}\n')

# QUADRIGRAMS
target_quadrigrams = get_quadrigrams(target_stimuli)
control_quadrigrams = get_quadrigrams(control_stimuli)
all_quadrigrams = list(set(target_quadrigrams + control_quadrigrams))
print(f'Number of quadrigrams {len(all_quadrigrams)}')
print(f'Total time: {n_repetitions*len(all_quadrigrams)/3/60}')
with open(os.path.join(path2stimuli, 'quadrigrams.csv'), 'w') as f:
    for ngram in sorted(all_quadrigrams):
        f.write(f'{ngram}\n')