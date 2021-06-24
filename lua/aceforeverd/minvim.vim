lua <<<
local treesitter_config = require('nvim-treesitter.configs')
treesitter_config.setup {
    rainbow = { enable = true, extended_mode = true, max_file_lines = 1000 },
    }
EOF
