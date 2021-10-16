function letters = extend_letters(letters_lowercase, params)
                              
    % ADD UPPERCASE CHARACTER FOR EACH ENTRY IN INPUT CELL ARRAY
    
    letter_cases = {'lower', 'upper'};
    positions = {'center'};
    fonts = params.font_names;
    
    n_letters = length(letters_lowercase);
    letters = cell(n_letters * 2 * 2, 5);
    
    cnt = 0;
    for i_stim = 1:n_letters
        for letter_case=letter_cases
            for position=positions
                for font=fonts
                    letters{cnt + 1, 1} = letters_lowercase{i_stim};
                    letters{cnt + 1, 2} = letter_case{1};
                    letters{cnt + 1, 3} = position{1};
                    letters{cnt + 1, 4} = font{1};
                    fn = ['../../stimuli/visual/images/single_letters/', ...
                          letters_lowercase{i_stim}, '_', ...
                          position{1}, '_', ...
                          font{1}, '_', ...
                          letter_case{1}, '.png'];
                    letters{cnt + 1, 5} = imread(fn);
                    cnt = cnt + 1;
                end
            end
        end
    end
    
    letters = repmat(letters, params.repetitions_letters, 1);
    
end