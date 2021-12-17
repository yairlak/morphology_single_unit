function stimuli_extended = combine_with_numbers(stimuli, params)
    
    %%
    numbers = {'1', '2', '3', '4', '5', '6', '7', '8', '9'};
    stimulus_set = union(stimuli(:, 1), stimuli(:, 1));
%     letters = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', ...
%                'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', ...
%                'w', 'x', 'y', 'z'};
    letter_cases = params.letter_cases;
    positions = params.positions;
    fonts = params.fonts;
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
        n_stimuli_step = randi([step_min,  ], 1);
        for i=1:n_stimuli_step
            if i_stimuli > length(stimuli)
                break
            end
            stimuli_extended = [stimuli_extended; stimuli(i_stimuli, :)];
            i_stimuli = i_stimuli + 1; 
            i_extended = i_extended + 1; 
        end
        % INSERT A NUMBER
        random_stimulus = sample_character(numbers, ...
                                           letter_cases, ...
                                           positions, ...
                                           {fonts{1}}, params);
        stimuli_extended = [stimuli_extended; random_stimulus];
        i_extended = i_extended + 1;
        % for i_sham=1:ceil(blink_duration/SOA)
        for i_sham=1:2  % ADD TWO SHAM TRIALS DUE TO ATTENTIONAL BLINK
            random_stimulus = sample_character(stimulus_set, ...
                                               letter_cases, ...
                                               positions, ...
                                               fonts, params);
            stimuli_extended = [stimuli_extended; random_stimulus];
            i_extended = i_extended + 1;
        end
    end
    
end