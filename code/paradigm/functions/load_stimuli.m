function stimuli_letters = load_stimuli(params)

%%%%%%%%%%%%%%%%%%%%%%%%%
% Load the WAV segments
%---------------------

timestamp=gettimestamp();
subses=['P' num2str(params.subject) '_S' num2str(params.session)];

%%%%%%%%%%%%%%%%%%%%%%%%%
% Load the visual stimuli
%---------------------
text_filename = fullfile(params.path2stimuli, 'visual', params.text_filename);
fid_visual_stimuli = fopen(text_filename, 'r'); 
stimuli = textscan(fid_visual_stimuli,'%s','delimiter','\n');
fclose(fid_visual_stimuli);
stimuli_letters = stimuli{1};

end

