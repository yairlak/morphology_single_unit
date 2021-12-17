#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Apr 13 15:19:24 2021

@author: yl254115
"""

import sys, os, argparse, glob
sys.path.append('..')
#from utils import load_settings_params
from neo import io
import numpy as np
import scipy.io as sio
import pandas as pd

def read_events(args):
    session_folder = os.path.join('..', '..', '..',
                                  'data', 'patient_' + args.patient,
                                  'raw', 'nev')
    print(session_folder)
    nev_files = glob.glob(os.path.join(session_folder, 'Events.*'))
    assert len(nev_files) > 0
    
    event_nums_zero, time_stamps, IXs2nev = [], [], []
    duration_prev_nevs = 0 # For blackrock: needed to concat nev files. Adds the duration of the previous file(s)
    for i_nev, nev_file in enumerate(sorted(nev_files)):
        if nev_file[-3:] == 'nev':
            if args.recording_system == 'Neuralynx':
                reader = io.NeuralynxIO(os.path.join(session_folder, '..', 'micro'))
                sfreq = reader.get_signal_sampling_rate(0)
                reader = io.NeuralynxIO(session_folder)
                blks = reader.read(lazy=False)
                #time0, timeend = reader.global_t_start, reader.global_t_stop
                events_times, events_ids = [], []
                for segment in blks[0].segments:
                    event_times_mat = segment.events
                    for neo_event_times in event_times_mat:
                        ttl = int(neo_event_times.name.split('ttl=')[-1])
                        #if IX2event_id[IX] in event_id.values():
                        times = np.asarray(neo_event_times.times)
                        events_times.extend(times) # in SECONDS
                        events_ids.extend([ttl] * len(times))
                events_ids = np.asarray(events_ids) 
                events_times = np.asarray(events_times)
                print(f'Number of events in nev {nev_file}: {len(events_times)}')
                IX_chrono = events_times.argsort()
                time_stamps.extend(events_times[IX_chrono])
                event_nums_zero.extend(events_ids[IX_chrono])
                del reader, blks, segment
            elif args.recording_system == 'BlackRock':
                reader = io.BlackrockIO(nev_file)
                #time0, timeend = reader._seg_t_starts[0], reader._seg_t_stops[0]
                sfreq = reader.header['unit_channels'][0][-1] # FROM FILE
                # sfreq = reader.header['spike_channels'][0][-1] # FROM FILE
                events = reader.nev_data['NonNeural'][0]
                events_times = duration_prev_nevs + np.asarray([float(e[0]/sfreq) for e in events])
                time_stamps.extend(events_times)
                event_nums = [e[4] for e in events] 
                event_nums_zero = event_nums
                # event_nums_zero.extend(event_nums - min(event_nums)-128) # HACK (128)
                
        elif nev_file[-3:] == 'mat':
            assert len(nev_files) == 1
            events = loadmat(nev_file)
            if 'timeStamps' in events:
                print(events['timeStamps'])
                time_stamps = events['timeStamps']
                event_nums_zero = event_nums = events['TTLs']
            else:
                time_stamps = events['NEV']['Data']['SerialDigitalIO']['TimeStampSec']
                event_nums_zero = event_nums = events['NEV']['Data']['SerialDigitalIO']['UnparsedData']

            # get time0, timeend and sfreq from ncs files
            if args.recording_system == 'Neuralynx':
                reader = io.NeuralynxIO(os.path.join(session_folder, '..', 'micro'))
                sfreq = reader._sigs_sampling_rate
                time0, timeend = reader.global_t_start, reader.global_t_stop
            elif args.recording_system == 'BlackRock':
                nev_files = glob.glob(os.path.join(session_folder, '*.nev'))
                reader = io.BlackrockIO(nev_files[0])
                time0, timeend = reader._seg_t_starts[0], reader._seg_t_stops[0]
                sfreq = reader.header['unit_channels'][0][-1] # FROM FILE
            time_stamps -= time0 # timestamps in mat file are in absolute time for Neuralynx, unlike timestamps in nev file!
        else:
            raise(f'Unrcognized event file: {nev_file}')
        # if timeend:
        #     duration_prev_nevs += timeend
    assert len(event_nums_zero) == len(time_stamps)
    
    return time_stamps, event_nums_zero, sfreq


def split_to_blocks(times_device,
                    event_ids,
                    IX_block_starts = None,
                    event_id_block_starts = [[255]*4, [255]*13, [255]*13],
                    n_blocks=4):


    dict_device = {}
    if not IX_block_starts:
        # FIND BLOCK STARTS
        IX_block_starts = []
        i_event = 0
        while len(IX_block_starts)<n_blocks:
            for event_id_block_start in event_id_block_starts:
                remaining_events_to_find = event_id_block_start
                is_block_start = False
                while not is_block_start:
                    event_id = event_ids[i_event]
                    if event_id == remaining_events_to_find[0]:
                        remaining_events_to_find.pop(0)
                        if not remaining_events_to_find:
                            IX_block_starts.append(i_event)
                            is_block_start = True
                    i_event += 1
                    if i_event > len(event_ids):
                        raise('problem with event IDs')

    # SPLIT TO BLOCKS
    IX_block_starts_ends = [(IX, IX_block_starts[i_IX+1])
                            for i_IX, IX in enumerate(IX_block_starts[:-1])]
    IX_block_starts_ends.append((IX_block_starts[-1], -1))
    for i_block, starts_ends in enumerate(IX_block_starts_ends):
        st, ed = starts_ends
        dict_device[i_block] = {}
        dict_device[i_block]['times'] = times_device[st:ed]
        print(i_block, times_device[st], times_device[ed])
        dict_device[i_block]['event_ids'] = event_ids[st:ed]

    return dict_device, IX_block_starts

def extract_target_triggers(dict_device, target_triggers):
    for block_num in dict_device.keys():
        times_clean, ids_clean = [], []
        for t, event_id in zip(dict_device[block_num]['times'],
                               dict_device[block_num]['event_ids']):
            if event_id in target_triggers:
                times_clean.append(t)
                ids_clean.append(event_id)
        dict_device[block_num]['times_clean'] = times_clean
        dict_device[block_num]['ids_clean'] = ids_clean
    return dict_device

def read_logs(args):
    
    logs_folder = os.path.join('..', '..', '..', 'data', 
                               'patient_' + args.patient, 'logs')
    
    dict_logs = {}
    IX_time_stamps = 0
    cnt_log = 0
    fns_logs = glob.glob(os.path.join(logs_folder, 'log_morphology_*.csv'))
    #fns_logs_with_CHEETAH = []
    num_triggers_per_log = []
    for i_log, fn_log in enumerate(fns_logs):
        block_name = os.path.basename(fn_log).split('_')[2]
        block_type = os.path.basename(fn_log).split('_')[3]
        print(f'Reading log: {i_log+1}, {block_name} ({block_type}): {fn_log}')
        df_log = pd.read_csv(fn_log, delimiter='\t', index_col=False)
        df_log_stim_on_off = df_log.loc[df_log['Event'].isin(['StimVisualOn', 'StimVisualOff', 'Fix'])]
        df_log_keypress = df_log.loc[df_log['Event']=='KeyPress']
        
        num_triggers = len(df_log_stim_on_off['Time'].tolist())    
        if num_triggers>0:
            dict_logs[f'{block_name}_{block_type}'] = {}
            dict_logs[f'{block_name}_{block_type}']['log_filename'] = fn_log
            dict_logs[f'{block_name}_{block_type}']['df_log_keypress'] = df_log_keypress
            dict_logs[f'{block_name}_{block_type}']['df_log_stim_on_of'] = df_log_stim_on_off
            dict_logs[f'{block_name}_{block_type}']['num_triggers'] = num_triggers
    return dict_logs


def loadmat(filename):
    '''
    this function should be called instead of direct spio.loadmat
    as it cures the problem of not properly recovering python dictionaries
    from mat files. It calls the function check keys to cure all entries
    which are still mat-objects
    '''
    data = sio.loadmat(filename, struct_as_record=False, squeeze_me=True)
    return _check_keys(data)


def _check_keys(dict):
    '''
    checks if entries in dictionary are mat-objects. If yes
    todict is called to change them to nested dictionaries
    '''
    for key in dict:
        if isinstance(dict[key], sio.matlab.mio5_params.mat_struct):
            dict[key] = _todict(dict[key])
    return dict        


def _todict(matobj):
    '''
    A recursive function which constructs from matobjects nested dictionaries
    '''
    dict = {}
    for strg in matobj._fieldnames:
        elem = matobj.__dict__[strg]
        if isinstance(elem, sio.matlab.mio5_params.mat_struct):
            dict[strg] = _todict(elem)
        else:
            dict[strg] = elem
    return dict

