function run_visual_block(handles, block, stimuli, ...
                          fid_log, triggers, cumTrial, params, events)
% %%%%%% WAIT FOR KEY PRESS
if block>1
    DrawFormattedText(handles.win, 'Press any key...', 'center', 'center', handles.white);
    Screen('Flip',handles.win);
    wait_for_key_press()   
end

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

positions = ['Left', 'Right'];
for trial=1:length(stimuli)
  [stimulus, letter_case, position, font] = stimuli{trial, :};
  % CASE
  if strcmp(letter_case, 'upper')
      stimulus = upper(stimulus);
  end
  % POSITION ON THE SCREEN
  n_blanks = 5;
  switch position
      case 'left'
          stimulus = [stimulus, blanks(n_blanks)];
          f = 0.47;
      case 'right'
          stimulus = [blanks(n_blanks), stimulus];
          f = 0.53;
      otherwise
          stimulus = stimulus; % TODO: complete for other cases
  end
  
  [~, ~, keyCode] = KbCheck;
  if keyCode('ESCAPE')
    DisableKeysForKbCheck([]);
    Screen('CloseAll');
    return
  end
  cumTrial=cumTrial+1;
  fprintf('Block %i, trial %i\n', block, trial)


  % %%%%%%% DRAW FIXATION BEFORE SENTENCE (duration: params.fixation_duration)
  Screen('TextFont',handles.win, params.font_name{1}); % Fixation with standrad font
  DrawFormattedText(handles.win, '+', 'center', 'center', handles.white);
  fixation_onset = Screen('Flip', handles.win);
  if triggers
      send_trigger(triggers, handles, params, events, 'StartFixation', 0)
  end
  [pressed, firstPress]=KbQueueCheck; % Collect keyboard events since KbQueueStart was invoked
  WaitSecs('UntilTime', fixation_onset + params.fixation_duration_visual_block); %Wait before trial
  fixation_offset = Screen('Flip', handles.win);

  % %%%%%%% WRITE TO LOG
  fprintf(fid_log,['Fix\t' ...
          num2str(block) '\t' ...
          num2str(trial) '\t' ...
          num2str(0) '\t' ... % Stimulus serial number in original stimulus text file
          '' '\t' ...  %
          '+' '\t' ...
          num2str(fixation_onset) '\r\n' ...
          ]); % write to log file

  % %%%%%%% START RSVP for current sentence

  % TEXT ON
  Screen('TextFont',handles.win, font);
  rect = get(0, 'ScreenSize');
  DrawFormattedText(handles.win, stimulus, 'center', 'center', handles.white);
  text_onset = Screen('Flip', handles.win); % Word ON
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
        if firstPress(KbName('l')) || firstPress(KbName('L'))

            fprintf(fid_log,['KeyPress\t' ...
              num2str(block) '\t' ...
              num2str(trial) '\t' ...
              stimulus '\t' ...  %
              position '\t' ...
              font '\t' ...
              num2str(firstPress(KbName('l'))) '\t' ...
              '\r\n' ...
              ]); % write to log file
        end
        if firstPress(KbName('escape'))
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


  % %%%%%% WAIT ISI before next sentences
  WaitSecs('UntilTime', text_offset + params.stimulus_offtime + params.ISI_visual);

end  %trial
%     
end