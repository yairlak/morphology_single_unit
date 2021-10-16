function [params, events] = getParamsUCLAParadigm(debug_mode)
%function params = getParams
%This function makes the struct that holds the parameters for the presentation of the stimuli and such.

%% %%%%%%% PATHS
params.path2intro_slide = '../../stimuli/instructions_sentences.png';
if ismac || isunix %comp == 'h'
    params.default_path = '~/Projects/Yair/morphology_single_unit/code';
    params.path2stimuli = fullfile('..', '..', 'stimuli');
    params.path2logs = fullfile('..', '..', 'logs');
    params.sio = '/dev/tty.usbserial';
elseif ispc % strcmp(comp,'l')
    params.defaultpath = '~/Projects/single_unit_syntax/Paradigm_Yair/Code';
    params.Visualpath = fullfile('..', 'Stimuli', 'visual');
    params.sio='COM1';
end

%% %%%%%%% Text info and params
if debug_mode
    params.text_filename = 'characters_debug.txt';
else
    params.text_filename = 'characters.txt';
end
params.font_size = 50; % Fontsize for words presented at the screen center
params.font_name = {'LiberationMono-Regular.ttf', 'AlexBrush-Regular.ttf'}; % First standard, second cursif
params.font_color = 'ffffff';

params.repetitions_letters = 6;
params.repetitions_numbers = 6;

%% %%%%%%% TIMING params
% VISUAL BLOCK
params.fixation_duration_visual_block = 0.6; %
params.stimulus_ontime = 0.1; % Duration of each word
params.stimulus_offtime = 0.1; % Duration of black between stimuli
params.SOA_visual = params.stimulus_ontime + params.stimulus_offtime;
params.ISI_visual = 0; % from end of last trial to beginning of first trial

%% EVENTS NUMBERS (TRIGGERS)
% FIXATION
events.StartFixation = 2;
events.EndFixation = 4;

% VISUAL BLOCK
events.StartVisualWord = 8;
events.EndVisualWord = 16;

% KEY PRESS
events.PressKey = 128;

% MISC
events.event255        = 255;
events.eventreset      = 0;
events.ttlwait         = 0.01;
events.audioOnset      = 0;
events.eventResp       = 145;

end
