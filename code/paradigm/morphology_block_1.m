clear all; close all; clc
pth = fileparts(which('morphology_block_1')); cd(pth);
addpath('functions')
block_type = 'visual';
stimulus_type = 'unigrams';
repetitions = 6;
fonts = {'LiberationMono-Regular.ttf', 'AlexBrush-Regular.ttf'};
letter_cases = {'lower', 'upper'};
positions = {'center'};
n_blocks = 1;
stimulus_ontime = 0.15;
morphology_single_unit
  
