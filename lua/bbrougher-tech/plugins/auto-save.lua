return {
    "Pocco81/auto-save.nvim",
    config = function()
        require("auto-save").setup({
            execution_message = {
                message = function()
                    return ""
                end,
                dim = 0.18,
                cleaning_interval = 1250,
            },
            condition = function(buf)
                local fn = vim.fn
                local utils = require("auto-save.utils.data")

                if vim.api.nvim_buf_is_loaded(buf) == 0 then
                    return false
                end

                -- don't save the harpoon menu
                local bufName = ""
                if pcall(function()
                        bufName = vim.api.nvim_buf_get_name(buf)
                    end) then
                    if string.match(bufName, "__harpoon.menu__") then
                        return false
                    end
                else
                    return false
                end

                if fn.getbufvar(buf, "&modifiable") == 1 and utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
                    return true -- met condition(s), can save
                end
                return false -- can't save
            end,
        })
    end,
}
