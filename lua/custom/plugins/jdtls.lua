return {
  {
    'mfussenegger/nvim-jdtls',
    ft = { 'java', 'javaproperties' }, -- use the filetypes you like
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'mfussenegger/nvim-dap', -- optional: for debugging support
      'folke/which-key.nvim', -- optional: the key-hints below
    },

    opts = function()
      --------------------------------------------------------------------------
      -- 1. Compute the basic 'cmd' we’ll pass to jdtls
      --------------------------------------------------------------------------
      local cmd = { vim.fn.exepath 'jdtls' }

      -- Add lombok if Mason installed jdtls
      local ok, mr = pcall(require, 'mason-registry')
      if ok and mr.is_installed 'jdtls' then
        local lombok = mr.get_package('jdtls'):get_install_path() .. '/lombok.jar'
        table.insert(cmd, ('--jvm-arg=-javaagent:%s'):format(lombok))
      end

      --------------------------------------------------------------------------
      -- 2. Helper functions: project root, workspace dir, etc.
      --------------------------------------------------------------------------
      local util = require 'lspconfig.util'

      local function root_dir(fname)
        return util.root_pattern('.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle')(fname) or util.path.dirname(fname)
      end

      local function project_name(root)
        return root and vim.fs.basename(root) or 'unknown'
      end

      local cache = vim.fn.stdpath 'cache'
      local function cfg_dir(name)
        return cache .. '/jdtls/' .. name .. '/config'
      end
      local function ws_dir(name)
        return cache .. '/jdtls/' .. name .. '/workspace'
      end

      --------------------------------------------------------------------------
      -- 3. Extra bundles (java-debug, java-test) if present
      --------------------------------------------------------------------------
      local bundles = {}
      if ok and mr.is_installed 'java-debug-adapter' then
        local dbg = mr.get_package('java-debug-adapter'):get_install_path()
        vim.list_extend(bundles, vim.split(vim.fn.glob(dbg .. '/extension/server/*.jar'), '\n'))
      end
      if ok and mr.is_installed 'java-test' then
        local tst = mr.get_package('java-test'):get_install_path()
        vim.list_extend(bundles, vim.split(vim.fn.glob(tst .. '/extension/server/*.jar'), '\n'))
      end

      --------------------------------------------------------------------------
      -- 4. Final opts table returned to Lazy (Kickstart uses it verbatim)
      --------------------------------------------------------------------------
      return {
        root_dir = root_dir,
        cmd = cmd,
        -- jdtls needs these extra args *per project*
        full_cmd = function(opts)
          local root = opts.root_dir(vim.api.nvim_buf_get_name(0))
          local pname = project_name(root)
          local full = vim.deepcopy(opts.cmd)
          if pname then
            vim.list_extend(full, {
              '-configuration',
              cfg_dir(pname),
              '-data',
              ws_dir(pname),
            })
          end
          return full
        end,

        -- nvim-dap / java-test toggles
        dap = { hotcodereplace = 'auto', config_overrides = {} },
        dap_main = {},
        test = true,

        -- Example of extra jdtls settings
        settings = {
          java = {
            inlayHints = { parameterNames = { enabled = 'all' } },
          },
        },
      }
    end,

    config = function(_, opts)
      ------------------------------------------------------------------------
      -- Helper that actually launches/attaches jdtls
      ------------------------------------------------------------------------
      local function start_jdtls()
        local fname = vim.api.nvim_buf_get_name(0)
        local root = opts.root_dir(fname)
        local config = vim.tbl_deep_extend('force', {
          cmd = opts.full_cmd(opts),
          root_dir = root,
          init_options = { bundles = opts.init_options or {} },
          settings = opts.settings,
          capabilities = (pcall(require, 'cmp_nvim_lsp') and require('cmp_nvim_lsp').default_capabilities()) or nil,
        }, opts.jdtls or {})

        require('jdtls').start_or_attach(config)
      end

      ------------------------------------------------------------------------
      -- Autocmds: attach on every Java buffer (first one done immediately)
      ------------------------------------------------------------------------
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'java', 'javaproperties' },
        callback = start_jdtls,
      })
      start_jdtls() -- for the buffer that triggered plugin load

      ------------------------------------------------------------------------
      -- Nice Which-Key mappings (optional)
      ------------------------------------------------------------------------
      local wk_ok, wk = pcall(require, 'which-key')
      if wk_ok then
        wk.register({
          ['<leader>cx'] = { name = '+jdtls-extract' },
          ['<leader>cxv'] = { "<cmd>lua require('jdtls').extract_variable_all()<cr>", 'Extract Variable' },
          ['<leader>cxc'] = { "<cmd>lua require('jdtls').extract_constant()<cr>", 'Extract Constant' },
          ['<leader>cgs'] = { "<cmd>lua require('jdtls').super_implementation()<cr>", 'Goto Super' },
          ['<leader>co'] = { "<cmd>lua require('jdtls').organize_imports()<cr>", 'Organize Imports' },
        }, { mode = 'n', buffer = vim.api.nvim_get_current_buf() })
      end
    end,
  },
}
