function fid=createLogFileUCLAParadigm(params)
timestamp=gettimestamp();
subses=['P' num2str(params.subject) '_S' num2str(params.session)];
fid=fopen(fullfile(params.path2logs, ['log_morphology_' ...
                                      params.stimulus_type '_' ...
                                      timestamp '_' subses '.csv']) ,'w');
fprintf(fid,['Event\t'...
    'Block\t'...
    'Trial\t'...
    'Stimulus\t'...     % String with presented stimuls
    'Position\t'...      % Based on stimulus order in text file.
    'Font\t'...      % Based on stimulus order in text file.
    'Time\r\n']);

% copy code used for running to the log folder
copyfile(fullfile('functions', 'getParamsUCLAParadigm.m'), fullfile(params.path2logs, sprintf('params_single_letters_%s_%s.m',timestamp,subses)))

end