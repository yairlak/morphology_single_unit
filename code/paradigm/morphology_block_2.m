clear all; close all; clc
pth = fileparts(which('morphology_block_2')); cd(pth);
addpath('functions')
block_type = 'visual';
stimulus_type = 'ngrams';
repetitions = 8;
fonts = {'LiberationMono-Regular.ttf'};
letter_cases = {'lower'};
positions = {'center'};
n_blocks = 3;
stimulus_ontime = 0.15;
morphology_single_unit

