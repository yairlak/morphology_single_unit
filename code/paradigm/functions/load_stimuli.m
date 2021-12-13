function stimuli = load_stimuli(params)

%%%%%%%%%%%%%%%%%%%%%%%%%
% Load the visual stimuli
%---------------------
text_filename = fullfile(params.path2stimuli, params.text_filename);
fid_visual_stimuli = fopen(text_filename, 'r'); 
stimuli = textscan(fid_visual_stimuli,'%s','delimiter','\n');
fclose(fid_visual_stimuli);
stimuli = stimuli{1};

end

