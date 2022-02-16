#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Oct 17 12:08:05 2021

@author: yl254115
"""
import os
import itertools

path2stimuli = '../../stimuli/'

elements = {}
elements['prefixes'] = ['re', 'un', 'dis']
elements['suffixes'] = ['er', 'ly', 'able']
elements['CVCs'] = ['kag', 'tis', 'viv']
elements['affix_patterns'] = ['root', '1P', '1S', '2P', '1P1S', '2P1S']

def get_affixes(affix_pattern, elements):
    if affix_pattern == 'root':
        prefixes = ['']
        suffixes = ['']
    elif affix_pattern == '1P':
        prefixes = elements['prefixes']
        suffixes = ['']
    elif affix_pattern == '1S':
        prefixes = ['']
        suffixes = elements['suffixes']    
    elif affix_pattern == '2P':
        prefixes = ['unre', 'undis']
        suffixes = ['']
    elif affix_pattern == '1P1S':
        prefixes = elements['prefixes']
        suffixes = ['ly', 'able'] # only suffixes that can combine with verbs
    elif affix_pattern == '2P1S':
        prefixes = ['unre', 'undis']
        suffixes = elements['suffixes']    
    return prefixes, suffixes


def get_control_stimulus(prefix, CVC, suffix):
    
    #
    control_CVC = CVC
    
    #
    if prefix == 'unre':
        control_prefix = 'ernu'
    elif prefix == 'undis':
        control_prefix = 'nusid'
    else:
        control_prefix = prefix[::-1]
    
    #
    if suffix == 'able':
        control_suffix = 'elba'
    elif suffix == 'er':
        control_suffix = 're'
    elif suffix == 'ly':
        control_suffix = 'yl'
    elif suffix == '':
        control_suffix = ''
        
    control_stimulus = control_prefix + control_CVC + control_suffix
    return control_stimulus

f_features = open(os.path.join(path2stimuli, 'pseudowords_features.csv'), 'w')
f = open(os.path.join(path2stimuli, 'pseudowords.csv'), 'w')

cnt = 0
target_stimuli = []
control_stimuli = []
for CVC in elements['CVCs']:
    print(f'Current root: {CVC}')
    for affix_pattern in elements['affix_patterns']:
        prefixes, suffixes = get_affixes(affix_pattern, elements)
        for prefix, suffix in list(itertools.product(prefixes, suffixes)):
            target_stimulus = prefix + CVC + suffix
            cnt += 1
            print(target_stimulus)
            target_stimuli.append(target_stimulus)
            
            line = f'{cnt}, {target_stimulus}, target, {CVC}, {prefix}, {suffix}, {affix_pattern}\n'
            f_features.write(line)
            f.write(f'{target_stimulus}\n')
            
            if affix_pattern != 'root':
                control_stimulus = get_control_stimulus(prefix, CVC, suffix)
                cnt += 1
                print(control_stimulus)
                control_stimuli.append(control_stimulus)
                
                line = f'{cnt}, {control_stimulus}, control, {affix_pattern}, {CVC}, {prefix}, {suffix}\n'
                f_features.write(line)
                f.write(f'{control_stimulus}\n')
f.close()
f_features.close()
   
print(f'Number of stimuli {cnt}')
n_repetitions = 8
print(f'Total time: {cnt*n_repetitions/2/60}')
