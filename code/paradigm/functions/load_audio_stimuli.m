function [stimuli_wavs, Fs] = load__audio_stimuli(stimuli, params)

%%%%%%%%%%%%%%%%%%%%%%%%%
% Load the audio files
%---------------------
stimuli_wavs = struct;
n_stimuli = length(stimuli)
for i=1:n_stimuli
     fn = [stimuli{i}, '.aiff'];
     wav_filename = fullfile(params.path2stimuli, 'audio', 'pseudowords', fn);
     temp = audioinfo(wav_filename);
     Fs(i) = temp.SampleRate;
     stimuli_wavs.(stimuli{i}) = audioread(wav_filename);
%     stimuli_wavs{i}(:,:) = audioread(wav_filename);
end


end