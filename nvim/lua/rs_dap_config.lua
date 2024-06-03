function file_exists(filename)
    f = io.open(filename, "r")
    return f ~= nil and f.close
end

local dap, dapui = require("dap"), require("dapui")
dapui.setup({
    controls = {
        element = "breakpoints",
        enabled = true,
        icons = {
            disconnect = "",
            pause = "",
            play = "",
            run_last = "",
            step_back = "",
            step_into = "",
            step_out = "",
            step_over = "",
            terminate = ""
        }
    },
    element_mappings = {},
    expand_lines = true,
    floating = {
        border = "single",
        mappings = {
            close = { "q", "<Esc>" }
        }
    },
    force_buffers = true,
    icons = {
        collapsed = "",
        current_frame = "",
        expanded = ""
    },
    layouts = { {
        elements = { {
            id = "breakpoints",
            size = 0.25
        }, {
            id = "scopes",
            size = 0.25
        }, {
            id = "stacks",
            size = 0.25
        }, {
            id = "watches",
            size = 0.25
        } },
        position = "right",
        size = 40
    }, {
        elements = { {
            id = "repl",
            size = 0.5
        }, {
            id = "console",
            size = 0.5
        } },
        position = "left",
        size = 40
    }, },
    mappings = {
        edit = "e",
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        repl = "r",
        toggle = "t"
    },
    render = {
        indent = 1,
        max_value_lines = 100
    }
})

-- Set adapters
-- Setup gdb for pc rust
dap.adapters.gdb = {
    type = "executable",
    command = "gdb",
    args = { "-i", "dap" }
}

dap.configurations.rust = {
    {
        name = "pc_launch",
        type = "gdb",
        request = "launch",
        program = "${workspaceFolder}/target/debug/${workspaceFolderBasename}",
        cwd = "${workspaceFolder}"
    },
}

-- Check for launch.json
if file_exists("launch.json") then
    require("dap.ext.vscode").load_launchjs("launch.js")
end

if file_exists("dap_config.json") then
    require("dap.ext.vscode").load_launchjs("dap_config.js")
end

-- Check if the project is embedded rust
if file_exists("memory.x") then
    require("dap_probers")

    -- Route the rtt messages to the dapui console
    local console_buffer = dapui.elements.console.buffer()
    local console_msg = {
        "Console for receiving the RTT defmt logs",
        "----------------------------------------",
        "This has been repurposed from the dapui",
        "'console buffer' because at the time it",
        "was not being used for anything and",
        "these logs seemed useful. If that is a",
        "problem, check the custom config file",
        "for it to modify / disable this.",
        "Also, good luck and you got this! :) ><",
        "----------------------------------------",
    }

    local log_levels = { "Info", "Warn", "Error" }

    vim.api.nvim_buf_set_option(console_buffer, "modifiable", true)
    vim.api.nvim_buf_set_lines(console_buffer, -1, -1, false, console_msg)
    vim.api.nvim_buf_set_option(console_buffer, "modifiable", false)
    local channel_to_buf = {}

    dap.listeners.before["event_probe-rs-rtt-channel-config"]["cm_rs_dap_config"] = function(_session, body)
        dap.session():request(
            "rttWindowOpened",
            { body["channelNumber"], body["channelNumber"] == 0 }, -- the condition is for "windowIsOpen"
            function()
                channel_to_buf[0] = console_buffer
                print("rtt configured to display on dapui console")
            end
        )
    end

    dap.listeners.before["event_probe-rs-rtt-data"]["cm_rs_dap_config"] = function(_session, body)
        if body["channelNumber"] == 0 and channel_to_buf[0] then
            vim.api.nvim_buf_set_option(console_buffer, "modifiable", true)

            for line in string.gmatch(body["data"], ".-\n") do
                line = string.gsub(line, "\n", "")
                vim.api.nvim_buf_set_lines(console_buffer, -1, -1, false, { line, })

                for _index, level in pairs(log_levels) do
                    local pos = string.find(line, string.upper(level))
                    if pos == 1 then -- (Lua indexes from one :())
                        local last_line = vim.api.nvim_buf_line_count(console_buffer) - 1
                        vim.api.nvim_buf_add_highlight(console_buffer, -1, "DiagnosticSign" .. level,
                            last_line, 0, #level)
                    end
                end
            end

            vim.api.nvim_buf_set_option(console_buffer, "modifiable", false)
        end
    end
end

-- Auto open the things when the debugger starts debugging
dap.listeners.before.attach.dapui_config = function()
    dapui.open()
end

dap.listeners.before.launch.dapui_config = function()
    dapui.open()
end

dap.listeners.before.event_terminated.dapui_config = function()
    dapui.close()
end

dap.listeners.before.event_exited.dapui_config = function()
    dapui.close()
end

-- Setting the keymaps
vim.api.nvim_set_keymap("n", "td", "<Cmd> lua require(\"dapui\").toggle()<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", " db", "<Cmd>DapToggleBreakpoint<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", " dc", "<Cmd>DapContinue<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", " di", "<Cmd>DapStepInto<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", " do", "<Cmd>DapStepOut<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", " dv", "<Cmd>DapStepOver<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", " dt", "<Cmd>DapTerminate<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "B", "<Cmd>DapToggleBreakpoint<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<F5>", "<Cmd>DapContinue<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<F6>", "<Cmd>DapStepInto<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<F7>", "<Cmd>DapStepOut<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<F8>", "<Cmd>DapStepOver<CR>", { noremap = true, silent = true })

-- Setting the signs
vim.fn.sign_define('DapBreakpoint', { text = '🌸' })
vim.fn.sign_define('DapBreakpointCondition', { text = '🌺' })
vim.fn.sign_define('DapBreakpointRejected', { text = '🌹' })
vim.fn.sign_define('DapStopped', { text = '🌷' })
vim.fn.sign_define('DapLogPoint', { text = '🌻' })
