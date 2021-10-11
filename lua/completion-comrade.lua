
local completion = require'completion-comrade.source'

local M = {}

function M.init()
    completion.register()
end

return M

