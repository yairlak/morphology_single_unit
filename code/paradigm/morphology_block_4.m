% Auditory block  
clear all; close all; clc
makeDiary = 1;
pth = fileparts(which('morphology_block_4')); cd(pth);
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
if makeDiary
diary('WhyIsThisFreezing')
disp('about to call morphology single unt')
end
morphology_single_unit

