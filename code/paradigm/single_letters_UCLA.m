%% 
% This is the main script for the experiment
% ------------------------------------------------
clear all; close all; clc
debug_mode = 1; 

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
stimuli = load_stimuli(params); % LOAD STIMULI

%% EXTEND STIMULI (ADD REPETITIONS, CASE, NUMBERS)
stimuli = extend_stimuli(stimuli, ...
                         params.repetitions_letters, ...
                         params.repetitions_numbers, params);
% %%%%%%% RANDOMIZE TRIAL LIST
stimuli=stimuli(randperm(size(stimuli, 1)), :);
 

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
    % PRESENT LONG FIXATION ONLY AT THE BEGINING
    DrawFormattedText(handles.win, '+', 'center', 'center', handles.white);
    Screen('Flip', handles.win);
    WaitSecs(1.5); %Wait before experiment start
    % START LOOP OVER BLOCKS
    for block = 1:1
        if block == 1
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
  
        % %%%%%% LOOP OVER STIMULI
        run_visual_block(handles, block, stimuli, ...
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