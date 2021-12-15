function [params, events] = getParamsUCLAParadigm(block_type, ngram_type)
%function params = getParams
%This function makes the struct that holds the parameters for the presentation of the stimuli and such.

%% %%%%%%% PATHS
params.path2intro_slide = '../../stimuli/instructions_single_letters.png';
if ismac || isunix %comp == 'h'
    params.default_path = fileparts(fileparts(fileparts(which('getParamsUCLAParadigm'))));
    %'~/Projects/Yair/morphology_single_unit/code';
    params.path2images = fullfile('..', '..', 'stimuli', 'visual', ngram_type);
    params.path2sounds = fullfile('..', '..', 'stimuli', 'audio', ngram_type);
    params.path2stimuli = fullfile('..', '..', 'stimuli');
    params.path2logs = fullfile('..', '..', 'logs');
    params.sio = '/dev/tty.usbserial';
elseif ispc % strcmp(comp,'l')
    params.defaultpath = '~/Projects/single_unit_syntax/Paradigm_Yair/Code';
    params.Visualpath = fullfile('..', 'Stimuli', 'visual');
    params.sio='COM1';
end

%% %%%%%%% Text info and params
params.font_size = 50; % Fontsize for words presented at the screen center
% params.font_color = 'ffffff';

params.mean_delay_between_numbers = 6; % [sec]
params.error_delay_between_numbers = 2; % [sec]
%params.repetitions_numbers = 6;

%% %%%%%%% TIMING params
% VISUAL BLOCK
params.fixation_duration_visual_block = 1.5; %
params.ISI_visual = 0; % from end of last trial to beginning of first trial

% AUDITORY BLOCK
params.ISI_audio = 0.5;
% params.patientChannel = 1;
% params.TTLChannel = 1;

%% EVENTS NUMBERS (TRIGGERS)
% FIXATION
events.StartFixation = 2;
events.EndFixation = 4;

% VISUAL BLOCK
events.StartVisualWord = 8;
events.EndVisualWord = 16;

% AUDIO BLOCK
events.StartAudio = 9;
events.EndAudio = 17;

% KEY PRESS
events.PressKey = 128;

% MISC
events.event255        = 255;
events.eventreset      = 0;
events.ttlwait         = 0.01;
events.audioOnset      = 0;
events.eventResp       = 145;

end
