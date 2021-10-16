function stimuli_extended = combine_with_numbers(stimuli, params)
    
    %%
    numbers = {'1', '2', '3', '4', '5', '6', '7', '8', '9'};
    letters = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', ...
               'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', ...
               'w', 'x', 'y', 'z'};
    letter_cases = {'lower', 'upper'};
    positions = {'center'};
    fonts = params.font_names;
    %%
    SOA = params.stimulus_ontime + params.stimulus_offtime; % [sec]
    step = params.mean_delay_between_numbers; % [sec]
    delta_step = params.error_delay_between_numbers; % [sec]
    step_min = floor((step-delta_step)/SOA);
    step_max = ceil((step+delta_step)/SOA);
    blink_duration = 1; % [sec]; for adding sham trials after target numbers
    
    %% ADD NUMBERS
    i_stimuli = 1;
    i_extended = 1;
    stimuli_extended = {};
    while i_stimuli <= length(stimuli)
        n_stimuli_step = randi([step_min, step_max], 1);
        for i=1:n_stimuli_step
            if i_stimuli > length(stimuli)
                break
            end
            stimuli_extended = [stimuli_extended; stimuli(i_stimuli, :)];
            i_stimuli = i_stimuli + 1; 
            i_extended = i_extended + 1; 
        end
        % INSERT A NUMBER
        random_char = sample_character(stimuli_extended, ...
                                           numbers, ...
                                           letter_cases, ...
                                           positions, ...
                                           {fonts{1}});
        stimuli_extended = [stimuli_extended; random_char];
        i_extended = i_extended + 1;
        for i_sham=1:ceil(blink_duration/SOA)
            random_char = sample_character(stimuli_extended, ...
                                               letters, ...
                                               letter_cases, ...
                                               positions, ...
                                               fonts);
            stimuli_extended = [stimuli_extended; random_char];
            i_extended = i_extended + 1;
        end
    end
    
end