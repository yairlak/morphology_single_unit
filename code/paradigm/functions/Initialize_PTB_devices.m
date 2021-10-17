function handles = Initialize_PTB_devices(params, handles, debug_mode)

%% SCREEN
Screen('Preference', 'SkipSyncTests', 1)
screens = Screen('Screens');
handles.screenNumber = max(screens);
handles.black = BlackIndex(handles.screenNumber);
handles.white = WhiteIndex(handles.screenNumber);

rect = get(0, 'ScreenSize');
handles.rect = [0 0 rect(3:4)];
handles.win = Screen('OpenWindow',handles.screenNumber, handles.black, handles.rect);
% if debug_mode
%      PsychDebugWindowConfiguration([0],[0.5])
% end

%% TEXT ON SCREEN
Screen('TextSize',handles.win, 160);   % 160 --> ~25mm text height (from top of `d' to bottom of `g').
Screen('TextStyle', handles.win, 1);   % 0=normal text style. 1=bold. 2=italic.

%% KEYBOARD
handles.escapeKey = KbName('ESCAPE');
% handles.LKey = KbName('L');
keysOfInterest=zeros(1,256);
keysOfInterest(KbName({'space', 'ESCAPE'}))=1;
KbQueueCreate(-1, keysOfInterest);


end