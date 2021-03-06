function run_auditory_block(handles, block, stimuli, ...
                             stimuli_wavs,fs, image_fixation, ...
                             fid_log, triggers, cumTrial, params, events)
                         
% %%%%%% BLOCK START: mark a new block with four 255 triggers separated 200ms from each other
block_start = GetSecs;
for i=1:4
    send_trigger(triggers, handles, params, events, 'event255', 0.2)
end
% %%%%%%% WRITE TO LOG
fprintf(fid_log,['BlockStart\t' ...
      num2str(block) '\t' ...
      num2str(0) '\t' ...
      num2str(0) '\t' ... % Stimulus serial number in original stimulus text file
      '' '\t' ...  %
      '-' '\t' ...
      num2str(block_start) '\t' ...
      '' '\r\n' ...
      ]); % write to log file

% %%%%%%% DRAW FIXATION (duration: params.fixation_duration)
texture = Screen('MakeTexture', handles.win, image_fixation);
Screen('DrawTexture', handles.win, texture, [], []);
fixation_onset = Screen('Flip', handles.win); % Fixation ON
if triggers
  send_trigger(triggers, handles, params, events, 'StartFixation', 0)
end
% %%%%%%% WRITE TO LOG
fprintf(fid_log,['Fix\t' ...
      num2str(block) '\t' ...
      num2str(0) '\t' ...
      num2str(0) '\t' ... % Stimulus serial number in original stimulus text file
      '' '\t' ...  %
      '+' '\t' ...
      num2str(fixation_onset) '\r\n' ...
      ]); % write to log file
WaitSecs('UntilTime', fixation_onset + params.fixation_duration_visual_block);
fixation_offset = Screen('Flip', handles.win); % Fixation OFF  

handles.pahandle = PsychPortAudio('Open',[],[],[],fs(1),2);

for trial=1:length(stimuli)
  [stimulus, ~, ~, ~, ~] = stimuli{trial, :};
  if length(stimulus)==1
      switch stimulus
          case '1'
              stimulus = 'one';
          case '2'
              stimulus = 'two';
          case '3'
              stimulus = 'three';
          case '4'
              stimulus = 'four';
          case '5'
              stimulus = 'five';
          case '6'
              stimulus = 'six';
          case '7'
              stimulus = 'seven';
          case '8'
              stimulus = 'eight';
          case '9'
              stimulus = 'nine';
      end
  end
  
  cumTrial=cumTrial+1;
  fprintf('Block %i, trial %i\n', block, trial)

  % %%%%%%% START presentation  

  % AUDIO ON
  clear wavedata;
  wavedata = formatAudioForPsychToolbox(stimuli_wavs.(stimulus));
  
  % %%%%%% Echo status
  fprintf('Block %i, trial %i, stimulus %s\n', block, trial, stimulus)
  
  % %%%%%%% Present fixation and fill buffer
  
  PsychPortAudio('FillBuffer', handles.pahandle, wavedata);
  WaitSecs('UntilTime', fixation_onset + params.fixation_duration_visual_block);
  fixation_offset = Screen('Flip', handles.win);      
  
  % %%%%%%% START AUDIO AND SEND TRIGGER AT START AND END
  audioOnset = PsychPortAudio('Start', handles.pahandle);%, 1, 0, 0); % it takes ~15ms to start the sound
  KbQueueStart;
%   stimulusDuration = length(wavedata)/fs(1);
  
  if triggers
      send_trigger(triggers, handles, params, events, 'StartAudio', 0)
  end
%   WaitSecs(stimulusDuration)
  
  
  
  [~, ~, ~, audioStopTime]=PsychPortAudio('Stop', handles.pahandle,1);
  [pressed, firstPress]=KbQueueCheck; 
  if pressed
      if triggers
          send_trigger(triggers, handles, params, events, 'PressKey', 0)
          %       else
          %           disp('pressed a key');
      end
  end
  if triggers
      send_trigger(triggers, handles, params, events, 'EndAudio', 0)
  end

  % %%%%%%% CLEAR-UP (buffer and screen)
  PsychPortAudio('DeleteBuffer',[],1); % clear the buffer
  
  % WRITE TO LOG
  if pressed
        if firstPress(KbName('space'))
              fprintf(fid_log,['KeyPress\t' ...
              num2str(block) '\t' ...
              num2str(trial) '\t' ...
              '\t' ...  %
              '\t' ...
              '\t' ...
              num2str(firstPress(KbName('space'))) '\t' ...
              '\r\n' ...
              ]); % write to log file
        end
        if firstPress(KbName('escape'))
            KbName('space')
            error('Escape key was pressed')
        end
  end
  
  fprintf(fid_log,['StimAudioOn\t' ...
          num2str(block) '\t' ...
          num2str(trial) '\t' ...
          stimulus '\t' ...
          '\t' ...
          '\t' ...
          num2str(audioOnset) '\r\n' ...
          ]); % write to log file
  fprintf(fid_log,['StimAudioOff\t' ...
          num2str(block) '\t' ...
          num2str(trial) '\t' ...
          '\t' ...
          '\t' ...
          '\t' ...
          num2str(audioStopTime) '\r\n' ...
          ]); % write to log file


  % %%%%%% WAIT ISI
  WaitSecs('UntilTime', audioStopTime + params.ISI_audio); %Wait before showing next sentencesw

end  %trial
%     
end

function y = formatAudioForPsychToolbox(y)

if size(y,1)>size(y,2)
    y = y';
end
if size(y,1)==1
    y = [y;y];
end
end