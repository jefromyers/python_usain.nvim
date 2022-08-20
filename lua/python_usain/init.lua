local a = vim.api

local M = {}

M.attach_to_buffer = function(output_bufnr, pattern, command)
    vim.api.nvim_create_autocmd("BufWritePost", {
        group = vim.api.nvim_create_augroup('autorunner', { clear = true }),

        pattern = pattern,

        callback = function()
            local append_data = function(_, data)
                if data then
                    vim.api.nvim_buf_set_lines(output_bufnr, -1, -1, false, data)
                end
            end

            vim.api.nvim_buf_set_lines(output_bufnr, 0, -1, false, { "output" })
            vim.fn.jobstart(command, {
                stdout_buffered = true,
                on_stdout = append_data,
                on_stderr = append_data,
            })
        end,
    })
end

M.usain = function()
    local bufnr = a.nvim_get_current_buf() 
    local pattern = "*.py" -- vim.fn.input "Pattern: "
    local command = vim.split(vim.fn.input "Command: ", " ")
    M.attach_to_buffer(bufnr, pattern, command)
end

M.setup = function(opts)
    vim.api.nvim_set_keymap(
        "n", 
        "<Leader>up", 
        ":lua require('python_usain').usain()<Cr>",
        { noremap = true, silent = true }
    )
end

return M
