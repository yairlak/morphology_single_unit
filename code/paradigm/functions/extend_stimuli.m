function stimuli = extend_stimuli(letters_lowercase, ...
                                  repetitions_letters, ...
                                  repetitions_numbers, ...
                                  params)
    % ADD UPPERCASE CHARACTER FOR EACH ENTRY IN INPUT CELL ARRAY
    
    letter_cases = {'lower', 'upper'};
    positions = {'left', 'right'};
    fonts = params.font_name;
    
    n_letters = length(letters_lowercase);
    letters = cell(n_letters * 2 * 2 * 2, 4);
    
    cnt = 0;
    for i_stim = 1:n_letters
        for letter_case=letter_cases
            for position=positions
                for font=fonts
                    letters{cnt + 1, 1} = letters_lowercase{i_stim};
                    letters{cnt + 1, 2} = letter_case{1};
                    letters{cnt + 1, 3} = position{1};
                    letters{cnt + 1, 4} = font{1};
                    cnt = cnt + 1;
                end
            end
        end
    end
    
    letters = repmat(letters, repetitions_letters, 1);
    
    %% NUMBERS
    numbers_list = {'1'; '2'};
    n_numbers = length(numbers_list);
    numbers = cell(n_numbers * 2);
    
    cnt = 0;
    for i_num = 1:n_numbers
        for position=positions
            numbers{cnt + 1, 1} = numbers_list{i_num};
            numbers{cnt + 1, 2} = 'lower';
            numbers{cnt + 1, 3} = position{1};
            numbers{cnt + 1, 4} = 'Arial';
            cnt = cnt + 1;
        end
    end
    
    numbers = repmat(numbers, repetitions_numbers, 1);
    
    %% CAT ALL TOGETHER
    stimuli = cat(1, letters, numbers);

end