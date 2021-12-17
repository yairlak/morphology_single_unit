clear all; close all; clc
pth = fileparts(which('morphology_block_3')); cd(pth);
addpath('functions')
block_type = 'visual';
stimulus_type = 'pseudowords';
repetitions = 8;
fonts = {'LiberationMono-Regular.ttf'};
letter_cases = {'lower'};
positions = {'center'};
n_blocks = 3;
stimulus_ontime = 0.25;
morphology_single_unit

