#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Mar 27 21:16:50 2021

@author: yl254115
"""

import sys, os, argparse
sys.path.append('..')
import os.path as op

import matplotlib.pyplot as plt
import numpy as np
from sklearn.linear_model import LinearRegression, HuberRegressor
from misc import remove_outliers
from pprint import pprint
from data_manip import read_events, read_logs, split_to_blocks, extract_target_triggers

parser = argparse.ArgumentParser()
parser.add_argument('--patient', default = '551')
parser.add_argument('--recording-system', choices=['Neuralynx', 'BlackRock'], default='Neuralynx')
parser.add_argument('--logs', default=['unigrams', 'ngrams', 'pseudowords'], help='Since there could be more cheetah logs than block, these indexes define the log indexes of interest')
parser.add_argument('--merge-logs', action='store_true', default=True)
parser.add_argument('-v', '--verbose', action='store_true', default=True)
args = parser.parse_args()
pprint(args)

block_num2name = {0:'unigrams_visual', 1:'ngrams_visual', 2:'pseudowords_visual', 3:'pseudowords_auditory'}

logs_folder = os.path.join('..', '..', '..', 'data',
                           'patient_' + args.patient, 'logs')


# GrandStart is marked with 9 triggers with id=255.
# Run_visual_block and run_auditory_block are marked with 4 * '255'
# unigrams has a single block
# ngrams and pseudowords have each 3 blocks (so, (9+4), (4) (4) of 255)
# check below with: np.where(np.asarray(event_ids) == 65535) 
# or: np.where(np.asarray(event_ids) == 255) 

if args.recording_system == 'BlackRock':
    event_id_block_starts = [[65535]*4, [65535]*13, [65535]*21, [65535]*21]
    # event_id_block_starts = [[65535]*4, [65535]*13, [65535]*21]
    # target_triggers = [65410, 65416, 65424]
    target_triggers = {0:[65410, 65416, 65424], # dict: block_num -> target_event_ids
                       1:[65410, 65416, 65424],
                       2:[65410, 65416, 65424],
                       3:[65410, 65425]}
elif args.recording_system == 'Neuralynx':
    event_id_block_starts = [[255]*4, [255]*13, [255]*21]
    target_triggers = {0:[2, 8, 16], # dict: block_num -> target_event_ids
                       1:[2, 8, 16],
                       2:[2, 8, 16],
                       3:[2, 9, 17]}


#################
# Read NEV file #
#################

times_device, event_ids, sfreq = read_events(args)
print(f'sfreq = {sfreq}')

# SPLIT TO BLOCKS
dict_device, IX_block_starts = split_to_blocks(times_device, event_ids,
                                               event_id_block_starts=event_id_block_starts,
                                               n_blocks=3)

dict_device = extract_target_triggers(dict_device, target_triggers)

# Plot TTLs
dir_figures = op.join('..', '..', '..',
                      'figures', 'sync_logs', f'patient_{args.patient}')
os.makedirs(dir_figures, exist_ok=True)

fig, ax = plt.subplots()
ax.plot(times_device, event_ids, color='b')
[ax.axvline(x=times_device[IX_block_start], color='k', ls='--', lw=5)
                                for IX_block_start in IX_block_starts]
ax.set_xlabel('Time', fontsize=16)
ax.set_ylabel('Event ID', fontsize=16)
fn_fig = op.join(dir_figures, f'events_pt_{args.patient}.png')
plt.savefig(fn_fig)
plt.close(fig)

####################################################
# READ LOGS AND KEEP ONLY THOSE WITH SENT TRIGGERS #
####################################################

dict_logs = read_logs(args)

##################################
# REGRESS EVENT ON CHEETAH TIMES #
##################################
assert len(dict_logs.keys()) == len(dict_device.keys()) # same number of blocks

# dict_logs.pop('pseudowords_visual')
# dict_device.pop(2)

# RUN REGRESSION FIRST FOR ALL LOGS MERGED TOGETHER
times_log_all_blocks, times_device_all_blocks = [], []
for block_num in dict_device.keys():
    times_log = dict_logs[block_num2name[block_num]]['df_log_stim_on_of']['Time']
    times_device = dict_device[block_num]['times_clean']
    assert len(times_log) == len(times_device)
    # times_log, times_device = remove_outliers(times_log, times_device, i_log, args)
    times_log_all_blocks.extend(times_log)
    times_device_all_blocks.extend(times_device)
model_all = LinearRegression()

times_log_all_blocks = np.asarray(times_log_all_blocks).reshape(-1, 1)
times_device_all_blocks= np.asarray(times_device_all_blocks).reshape(-1, 1)

assert len(times_log_all_blocks) > 0 and len(times_device_all_blocks) > 0
model_all.fit(times_log_all_blocks, times_device_all_blocks)
r2score_all = model_all.score(times_log_all_blocks, times_device_all_blocks)
print('R^2 all logs: ', r2score_all)
_, ax = plt.subplots(1)
ax.scatter(times_log_all_blocks, times_device_all_blocks)
ax.set_title(f'All logs together: R^2 = {r2score_all:1.2f}')

# REGRESSION FOR EACH LOG
for block_num in dict_device.keys():
    block_name = block_num2name[block_num]
    print(dict_logs[block_name]['log_filename'])
    times_log = dict_logs[block_num2name[block_num]]['df_log_stim_on_of']['Time']
    times_device = dict_device[block_num]['times_clean']
    times_log = np.asarray(times_log).reshape(-1, 1)
    times_device= np.asarray(times_device).reshape(-1, 1)

    model = LinearRegression().fit(times_log, times_device)
    r2score = model.score(times_log, times_device)
    print(f'R^2 log {block_num2name[block_num]}: ', r2score)
   
    fig, ax = plt.subplots(1)
    ax.scatter(times_log, times_device)
    ax.set_title(f'log {block_num2name[block_num]}: R^2 = {r2score:1.5f}')
    ax.plot(times_log, model.intercept_[0] + model.coef_[0] * times_log, ls='--', color='k', lw=2)
    ax.set_xlabel('Time (log)', fontsize=16)
    ax.set_ylabel('Time (recording-device)', fontsize=16)
    fn_fig = fn_fig = op.join(dir_figures, f'regrssion_log2device_pt_{args.patient}_{block_name}.png')
    plt.savefig(fn_fig)
    plt.close(fig)
    
    event_names = dict_logs[block_num2name[block_num]]['df_log_stim_on_of']['Event']
    block_nums = dict_logs[block_num2name[block_num]]['df_log_stim_on_of']['Block']
    trial_nums = dict_logs[block_num2name[block_num]]['df_log_stim_on_of']['Trial']
    stimuli = dict_logs[block_num2name[block_num]]['df_log_stim_on_of']['Stimulus']
    positions = dict_logs[block_num2name[block_num]]['df_log_stim_on_of']['Position']
    fonts = dict_logs[block_num2name[block_num]]['df_log_stim_on_of']['Font']
    
    new_log_lines = []
    new_log_lines.append(f'Block-Type\tMini-Block\tTrial\tEvent\tStimulus\tPosition\tFont\tTime')
    for (t, event_name, mini_block, trial, stimulus, position, font) in zip(times_log,
                                                                       event_names,
                                                                       block_nums,
                                                                       trial_nums,
                                                                       stimuli,
                                                                       positions,
                                                                       fonts):
        if args.merge_logs:
            t_estimated = model_all.predict(np.asarray([t]).reshape(1, -1))[0]
        else:
            t_estimated = model.predict(np.asarray([t]).reshape(1, -1))[0]
        new_log_lines.append(f'{block_name}\t{mini_block}\t{trial}\t{event_name}\t{stimulus}\t{position}\t{font}\t{t_estimated[0]:.4f}')
    # SAVE
    fn_log_new = op.join(logs_folder, f'log_morphology_{block_name}_pt_{args.patient}_synched.log')
    with open(fn_log_new, 'w') as f:
        [f.write(l+'\n') for l in new_log_lines]


