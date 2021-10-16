%% 
% This is the main script for the experiment
% ------------------------------------------------
clear all; close all; clc
debug_mode = 0; 

%% INITIALIZATION
addpath('functions')
KbName('UnifyKeyNames')
[params, events] = getParamsUCLAParadigm(debug_mode);

%% SUBJECT AND SESSION NUMBERS
if debug_mode
    params.subject = "1";
    params.session = 1;
else
    subject = inputdlg({'Enter subject number'},...
        'Subject Number',1,{''});
    params.subject=subject{1};

    session = inputdlg({'Enter session number'},...
        'Subject Number',1,{''});
    params.session=str2double(session);
end
rng(str2double(params.subject)*params.session);

%% UCLA TTL settings
params.location='UCLA';  %options: 'UCLA' or 'TLVMC', affecting hardware to use for TTL
params.portA = 0;
params.portB = 1;

%% Running on PTB-3? Abort otherwise.
AssertOpenGL;

%% TRIGGERS
%#################################################################
% Send TTLs though the DAQ hardware interface
if debug_mode
    triggers = false;
else
    triggers = questdlg('Send TTLs?','TTLs status', ...
                        'Yes (recording session)','No (just playing)', ...
                        'Yes (recording session)');
    if triggers(1) == 'Y', triggers = 1; else triggers = 0; end
    if ~triggers 
        uiwait(msgbox('TTLs  will  *NOT*  be  sent - are you sure you want to continue?', ...
                      'TTLs','modal'))
    end

end
%################################################################
handles = initialize_TTL_hardware(triggers, params, events);

%% LOAD LOG, STIMULI, PTB handles.
if triggers
    for i=1:9 % Mark the beginning of the experiment with NINE consective '255' triggers separated by 0.1 sec
        send_trigger(triggers, handles, params, events, 'event255', 0.1)
    end
end
fid_log=createLogFileUCLAParadigm(params); % OPEN LOG

%% EXTEND STIMULI (ADD REPETITIONS, CASE, NUMBERS)
stimuli = load_stimuli(params); % LOAD STIMULI
stimuli = extend_letters(stimuli, params); % ADD CASE, FONT, POSITION
stimuli = stimuli(randperm(length(stimuli)), :);
stimuli = combine_with_numbers(stimuli, params); % ADD NUMBERS RANDOMLY
stimuli_blocks = split_to_blocks(stimuli, params.n_blocks);

fn = ['../../stimuli/visual/images/fixation.png'];
image_fixation = imread(fn);

%% PTB
%stimDur = cellfun(@(x) size(x, 1), stimuli_wavs, 'UniformOutput', false);  %in samples
handles = Initialize_PTB_devices(params, handles, debug_mode);
warning off; HideCursor
  
 
%% START EXPERIMENT
try 
    if ~debug_mode
        present_intro_slide(params, handles);
        KbStrokeWait;
    end
    KbQueueStart;
    cumTrial=0;
      
    % START LOOP  OVER BLOCKS
    for i_block = 1:params.n_blocks 
        if  i_block == 1
            % %%%%%%% WRITE TO LOG
              fprintf(fid_log,['GrandStart\t' ...
              '\t' ...
              '\t' ...
              '\t' ... % Stimulus serial number in original stimulus text file
              '\t' ...  %
              '---' '\t' ...
              num2str(GetSecs) '\t' ...
              '' '\r\n' ...
              ]); % write to log file
        end
        % %%%%%% WAIT FOR KEY PRESS
        DrawFormattedText(handles.win, 'Press any key...', 'center', 'center', handles.white);
        Screen('Flip',handles.win);
        wait_for_key_press()   
         
        % %%%%%% LOOP OVER STIMULI
        run_visual_block(handles, i_block, stimuli_blocks{i_block}, ...
                         image_fixation, ...
                         fid_log, triggers, cumTrial, params, events)
        
    end
catch
    sca
    psychrethrow(psychlasterror);
    KbQueueRelease;
    fprintf('Error occured\n')
end

%% %%%%%%% CLOSE ALL - END EXPERIMENT
fprintf('Done\n')
KbQueueRelease;
sca