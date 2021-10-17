function stimuli_extended = extend_stimuli(stimuli, params)
                              
    % ADD UPPERCASE CHARACTER FOR EACH ENTRY IN INPUT CELL ARRAY
    
    n_stimuli = length(stimuli);
    n_cases = length(params.letter_cases);
    n_fonts = length(params.fonts);
    n_positions = length(params.positions);
    stimuli_extended = cell(n_stimuli*n_cases*n_fonts*n_positions, 5);
    
    cnt = 0;
    for i_stim = 1:n_stimuli
        for letter_case=params.letter_cases
            for position=params.positions
                for font=params.fonts
                    stimuli_extended{cnt + 1, 1} = stimuli{i_stim};
                    stimuli_extended{cnt + 1, 2} = letter_case{1};
                    stimuli_extended{cnt + 1, 3} = position{1};
                    stimuli_extended{cnt + 1, 4} = font{1};
                    fn = fullfile(params.path2images, ...
                          [stimuli_extended{i_stim}, '_', ...
                          position{1}, '_', ...
                          font{1}, '_', ...
                          letter_case{1}, '.png']);
                    stimuli_extended{cnt + 1, 5} = imread(fn);
                    cnt = cnt + 1;
                end
            end
        end
    end
    
    stimuli_extended = repmat(stimuli_extended, params.repetitions, 1);
    
end