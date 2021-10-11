
if !exists('g:loaded_completion') || exists('g:loaded_completion_comrade')
    finish
endif

lua require'completion-comrade'.init()
