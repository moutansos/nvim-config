-- Remappings

vim.keymap.set("n", "<leader>sdn", ":Stashdown nf<CR>")
vim.keymap.set("n", "<leader>sde", ":Stashdown ne<CR>")
vim.keymap.set("n", "<leader>sda", ":Stashdown a<CR>")
vim.keymap.set("n", "<leader>sdi", ":Stashdown ii<CR>")

-- Start Stashdown Code
local function new_file(file_name, doc_title)
    local full_path = vim.fn.expand('%:p:h')
    local file_path = full_path .. '/' .. file_name
    local file = io.open(file_path, 'w')
    if file == nil then
        print('Error creating file')
        return
    end

    file:write('# ' .. doc_title .. '\n\n')
    file:write('Date: ' .. os.date('%A, %b %d, %Y') .. '\n\n')
    file:write('## Notes\n\n')
    file:write('### ' .. os.date('%A, %b %d, %Y') .. '\n\n')
    file:write('#### ' .. os.date('%I:%M:%S %p') .. '\n\n')
    file:close()

    vim.cmd('e ' .. file_path)
    vim.cmd('norm! G')
    vim.cmd('startinsert')
end

local function find_last_day_line(buffer_text)
    local last_day_line = nil
    for i = #buffer_text, 1, -1 do
        if string.match(buffer_text[i], '^###%s') then
            last_day_line = buffer_text[i]
            break
        end
    end

    return last_day_line
end

local function new_entry(buff_num)
    local buffer_text = vim.api.nvim_buf_get_lines(buff_num, 0, -1, false)
    local last_day_line = find_last_day_line(buffer_text)
    local current_day_line = '### ' .. os.date('%A, %b %d, %Y')

    -- check to see if last line of buffer is a blank line
    if buffer_text[#buffer_text] ~= '' then
        vim.cmd('norm! G')
        vim.cmd('norm! o')
    end

    if last_day_line == nil or last_day_line ~= current_day_line then
        vim.api.nvim_buf_set_lines(buff_num, -1, -1, false, { current_day_line })

        vim.cmd('norm! G')
        vim.cmd('norm! o')
    end


    vim.api.nvim_buf_set_lines(buff_num, -1, -1, false, { '#### ' .. os.date('%I:%M:%S %p') })

    vim.cmd('norm! G')
    vim.cmd('norm! o')
    vim.cmd('norm! o')
    vim.cmd('startinsert')
end

local function copy_file(old_path, new_path)
    local old_file = io.open(old_path, "rb")
    local new_file_handle = io.open(new_path, "wb")
    local old_file_sz, new_file_sz = 0, 0
    if not old_file or not new_file_handle then
        return false
    end
    while true do
        local block = old_file:read(2 ^ 13)
        if not block then
            old_file_sz = old_file:seek("end")
            break
        end
        new_file_handle:write(block)
    end
    old_file:close()
    new_file_sz = new_file_handle:seek("end")
    new_file_handle:close()
    return new_file_sz == old_file_sz
end

local function archive_file()
    local archive_dir = vim.fn.expand('%:p:h') .. '/archive'

    if vim.fn.isdirectory(archive_dir) == 0 then
        vim.fn.mkdir(archive_dir)
    end

    local current_file_path = vim.fn.expand('%:t:r')
    local current_file_directory = vim.fn.expand('%:p:h')
    local assets_dir = current_file_directory .. '/' .. current_file_path .. '-assets'

    local assets_dir_exists = vim.fn.isdirectory(assets_dir)
    if assets_dir_exists == 1 then
        vim.fn.rename(assets_dir, archive_dir .. '/' .. current_file_path .. '-assets')
    end

    local current_file_name = '' .. vim.fn.expand('%:p')
    vim.fn.rename(current_file_name, archive_dir .. '/' .. vim.fn.expand('%:t'))
    vim.cmd('bd')
end

local function insert_image(buff_num)
    local image_file_location = vim.fn.input('Enter image file location: ', '', 'file')

    local image_file_exists = vim.fn.filereadable(image_file_location)
    if image_file_location == nil then
        print(' No image file location provided')
        return
    elseif image_file_exists == 0 then
        print(' Image file does not exist')
        return
    end

    -- make sure assets directory exists
    local current_file_path = vim.fn.expand('%:t:r')
    local current_file_directory = vim.fn.expand('%:p:h')
    local assets_dir = current_file_directory .. '/' .. current_file_path .. '-assets'
    local assets_dir_exists = vim.fn.isdirectory(assets_dir)
    if assets_dir_exists == 0 then
        vim.fn.mkdir(assets_dir)
    end

    -- copy image file to assets directory
    local image_file_name = os.date('%Y%m%d%H%M%S') .. '-' .. vim.fn.fnamemodify(image_file_location, ':t')
    local new_image_file_location = assets_dir .. '/' .. image_file_name
    copy_file(image_file_location, new_image_file_location)

    local buffer_text = vim.api.nvim_buf_get_lines(buff_num, 0, -1, false)

    if buffer_text[#buffer_text] ~= '' then
        vim.cmd('norm! G')
        vim.cmd('norm! o')
    end

    local relative_new_image_file_location = './' .. current_file_path .. '-assets/' .. image_file_name
    vim.api.nvim_buf_set_lines(buff_num, -1, -1, false, { '![' .. image_file_location .. '](' .. relative_new_image_file_location .. ')' })
end

vim.api.nvim_create_user_command('Stashdown', function(opts)
    local current_file_type = vim.opt.filetype:get()
    local input_command = opts.fargs[1]

    if input_command == nil then
        print('No command provided')
        return
    elseif input_command == 'nf' then
        local file_name = vim.fn.input('Enter file name: ')
        if file_name == nil then
            print('No file name provided')
            return
        end

        local doc_title = vim.fn.input('Enter note title: ')
        if doc_title == nil then
            print('No title provided')
            return
        end

        local full_file_name = file_name
        if string.match(file_name, '%.md$') == nil then
            full_file_name = file_name .. '.md'
        end

        new_file(full_file_name, doc_title)
        return
    end

    if current_file_type ~= 'markdown' then
        print('Current file type is not markdown. Stashdown only supports markdown files')
        return
    end

    -- Commands that can be used within a markdown file

    if input_command == 'ne' then
        new_entry(vim.api.nvim_get_current_buf())
        return
    elseif input_command == 'ii' then
        insert_image(vim.api.nvim_get_current_buf())
        return
    elseif input_command == 'a' then
        archive_file()
        return
    end
end, { nargs = 1 })
