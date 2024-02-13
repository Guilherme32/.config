local dap = require("dap")

-- For embedded
dap.adapters.probers = function(callback, dap_config, parent_sess)
    vim.cmd(":!cargo embed")

    callback({
        type = "server",
        port = 3021,
        executable = {
            command = "probe-rs",
            args = { "dap-server", "--port", "3021", "--single-session" }
        },
    })
end

-- right now it is working, though without the rtt
dap.configurations.rust = {
    {
        name = "embed_launch",
        type = "probers",
        port = "${port}",
        cwd = "${workspaceFolder}",
        request = "launch",
        preLaunchTask = "cargo build",
        chip = "stm32f401ccux",
        flashingConfig = {
            flashingEnable = true,
            haltAfterReset = true,
        },
        coreConfigs = { {
            programBinary = "target/thumbv7em-none-eabihf/debug/${workspaceFolderBasename}",
            coreIndex = 0,
            rttEnabled = true,
            rttChannelFormats = { {
                channelNumber = 0,
                dataFormat = "Defmt",
                showTimestamps = true,
                showLocation = false,
            } }
        } },
        consoleLogLevel = "Info",
    },
}
