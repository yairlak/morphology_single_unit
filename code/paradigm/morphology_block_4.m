% Auditory block
clear all; close all; clc
addpath('functions')
block_type = 'auditory';
stimulus_type = 'pseudowords';
repetitions = 8;
% For compatibility with the visual blocks,
% the next three lines should be left unchanged
fonts = {'LiberationMono-Regular.ttf'};
letter_cases = {'lower'};
positions = {'center'};
%
n_blocks = 3;
stimulus_ontime = 0.25;
morphology_single_unit

