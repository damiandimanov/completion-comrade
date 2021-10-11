
local match_api = require'completion.matching'

local M = {}

M.is_async = false

function M.getCompletionItems(prefix)
    local cursor = vim.api.nvim_win_get_cursor(0)
    local bufnr = vim.api.nvim_get_current_buf()

    local ret = {
        buf_id = bufnr,
        buf_name = vim.fn.bufname(bufnr),
        buf_changedtick = vim.api.nvim_buf_get_changedtick(bufnr),
        row = cursor[1] - 1,
        col = cursor[2],
        new_request = not M.is_async,
    }

    local results = vim.fn['comrade#RequestCompletion'](bufnr, ret)
    if type(results.is_finished) == 'boolean' then
        M.is_async = not results.is_finished

        local complete_items = {}
        for _, item in ipairs(results.candidates) do
            match_api.matching(complete_items, prefix, {
                word = item.word,
                priority = 99,
                abbr = item.abbr,
                kind = item.kind,
                icase = 1,
                dup = 0,
                empty = 1,
            })
        end

        return complete_items
    end

    M.is_async = false
    return {}
end

function M.register()
    if require'completion' then
        require'completion'.addCompletionSource('comrade', M.complete_item)
    end
end

M.complete_item = {
    item = M.getCompletionItems
}

return M

