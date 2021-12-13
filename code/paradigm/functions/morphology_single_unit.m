%% 
% This is the main script for the experiment
% ------------------------------------------------
debug_mode = 0; 

%% INITIALIZATION
addpath('functions')
KbName('UnifyKeyNames')
[params, events] = getParamsUCLAParadigm(block_type, stimulus_type);
params.block_type = block_type;
params.text_filename = [stimulus_type, '.csv'];
params.stimulus_type = stimulus_type;
params.repetitions = repetitions;
params.fonts = fonts;
params.letter_cases = letter_cases;
params.positions = positions;
params.n_blocks = n_blocks;
params.stimulus_ontime = stimulus_ontime; % Duration of each word
params.stimulus_offtime = params.stimulus_ontime; % Duration of black between stimuli
params.SOA_visual = params.stimulus_ontime + params.stimulus_offtime;


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
if strcmp(params.block_type, 'auditory')
  % Create a struct (dict) with field names that correspond to stimulus names
  % e.g., stimuli_wav.kag, stimuli_wav.unkag, etc. 
  % each field contains a vector of the audio waveform.
  [stimuli_wavs, Fs] = load_audio_stimuli(stimuli, params);
end
stimuli = extend_stimuli(stimuli, params); % ADD CASE, FONT, POSITION
stimuli = stimuli(randperm(length(stimuli)), :);
stimuli = combine_with_numbers(stimuli, params); % ADD NUMBERS RANDOMLY
if debug_mode
    stimuli = stimuli(1:100, :);
end
stimuli_blocks = split_to_blocks(stimuli, params.n_blocks);

fn = ['../../stimuli/visual/fixation.png'];
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
        DrawFormattedText(handles.win, 'Press any key...', 'center', ...
                          'center', handles.white);
        Screen('Flip',handles.win);
        wait_for_key_press()   

        % %%%%%% LOOP OVER STIMULI
        if strcmp(params.block_type, 'visual')
            run_visual_block(handles, i_block, stimuli_blocks{i_block}, ...
                             image_fixation, ...
                             fid_log, triggers, cumTrial, params, events)
        elseif strcmp(params.block_type, 'auditory')
            run_auditory_block(handles, i_block, stimuli_blocks{i_block}, ...
                             stimuli_wavs, image_fixation, ...
                             fid_log, triggers, cumTrial, params, events)
        end
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