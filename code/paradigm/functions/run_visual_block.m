function run_visual_block(handles, block, stimuli, image_fixation, ...
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

for trial=1:length(stimuli)
  [stimulus, letter_case, position, font, image] = stimuli{trial, :};
  % CASE
  if strcmp(letter_case, 'upper')
      stimulus = upper(stimulus);
  end
  
  cumTrial=cumTrial+1;
  fprintf('Block %i, trial %i\n', block, trial)

  % %%%%%%% START RSVP for current sentence

  % TEXT ON
  texture = Screen('MakeTexture', handles.win, image);
  Screen('DrawTexture', handles.win, texture, [], []);
  text_onset = Screen('Flip', handles.win); % Word ON
  
  % Collect keyboard events since KbQueueStart was invoked
  [pressed, firstPress]=KbQueueCheck; 

  
  if triggers
      send_trigger(triggers, handles, params, events, 'StartVisualWord', 0)
  end
  if pressed
      if triggers
           send_trigger(triggers, handles, params, events, 'PressKey', 0)
      end
  end
  WaitSecs('UntilTime', text_onset + params.stimulus_ontime);
  % TEXT OFF
  text_offset = Screen('Flip', handles.win); % Word OFF
  if triggers
      send_trigger(triggers, handles, params, events, 'EndVisualWord', 0)
  end
  
  
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
  % WRITE TO LOG
  fprintf(fid_log,['StimVisualOn\t' ...
          num2str(block) '\t' ...
          num2str(trial) '\t' ...
          stimulus '\t' ...
          position '\t' ...
          font '\t' ...
          num2str(text_onset) '\r\n' ...
          ]); % write to log file
  fprintf(fid_log,['StimVisualOff\t' ...
          num2str(block) '\t' ...
          num2str(trial) '\t' ...
          '\t' ...
          '\t' ...
          '\t' ...
          num2str(text_offset) '\r\n' ...
          ]); % write to log file


  WaitSecs('UntilTime', text_offset + params.stimulus_offtime);

  
end  %trial
%     
end