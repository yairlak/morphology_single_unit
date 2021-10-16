function stimuli_blocks = split_to_blocks(stimuli,n_blocks)
%SPLIT_TO_BLOCKS Summary of this function goes here
%   Detailed explanation goes here
stimuli_blocks = cell(n_blocks, 1);
n_stimuli = length(stimuli);

block_size = ceil(n_stimuli/n_blocks);
for i_block = 1:n_blocks
    st = 1 + (i_block-1)*block_size;
    if i_block<n_blocks
        ed = block_size*i_block;
        stimuli_blocks{i_block} = stimuli(st:ed, :);
    else
        stimuli_blocks{i_block} = stimuli(st:end, :);
    end
end

end