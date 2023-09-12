local has_cmp = function ()
  return require("lazy.core.config").spec.plugins["nvim-cmp"] ~= nil
end

local enabled_vtsls = true

return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
    "folke/neodev.nvim",
    { "hrsh7th/cmp-nvim-lsp", cond = has_cmp },
    { "hrsh7th/cmp-nvim-lsp-document-symbol", cond = has_cmp },
  },
  opts = function()
    local o = { opts = {} }

    o.opts.capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    has_cmp() and require("cmp_nvim_lsp").default_capabilities() or {}
    )
    o.opts.capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

    o.node_root_dir = {
      "package.json",
      "tsconfig.json",
      "tsconfig.jsonc",
      "node_modules",
    }

    o.deno_root_dir = {
      "deno.json",
      "deno.jsonc",
    }

    o.html_like = {
      "astro",
      "html",
      "htmldjango",
      "css",
      "javascriptreact",
      "javascript.jsx",
      "typescriptreact",
      "typescript.tsx",
      "svelte",
      "vue",
    }

    o.disable_formatting = function(client)
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false
      client.server_capabilities.documentFormattingProvider = false
    end

    return o
  end,
  config = function(_, opts)
    local html_like = opts.html_like
    -- local node_root_dir = opts.node_root_dir
    -- local disable_formatting = opts.disable_formatting
    -- local deno_root_dir = opts.deno_root_dir
    opts = opts.opts

    -- sign columnのアイコンを変更
    local signs = { Error = "", Warn = "", Hint = "", Info = "" }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end
    require("neodev").setup({})
    local lspconfig = require("lspconfig")
    require("mason-lspconfig").setup({
      ensure_installed = {
        "astro",
        "denols",
        "vtsls",
        "tsserver",
        "lua_ls",
        "tailwindcss",
        "gopls",
        "emmet_ls",
        "cssls",
        "ruby_ls",
        "zls",
        "svelte",
        "volar",
        "rust_analyzer",
      },
    })
    require("mason-lspconfig").setup_handlers({
      function(server_name)
        lspconfig[server_name].setup()
      end,
      ["astro"] = function()
        lspconfig["astro"].setup({
          root_dir = lspconfig.util.root_pattern("astro.config.mjs", ".astro/")
        })
      end,
      ["denols"] = function()
        lspconfig["denols"].setup({
          root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc", "deps.ts", "import_map.json"),
          init_options = {
            lint = true,
            unstable = true,
            suggest = {
              imports = {
                hosts = {
                  ["https://deno.land"] = true,
                  ["https://cdn.nest.land"] = true,
                  ["https://crux.land"] = true,
                },
              },
            },
          },
        })
      end,
      ["vtsls"] = function()
        local is_node = require("lspconfig").util.find_node_modules_ancestor(".")
        if is_node and enabled_vtsls then
          lspconfig["vtsls"].setup({})
        end
      end,
      ["tsserver"] = function ()
        local is_node = require("lspconfig").util.find_node_modules_ancestor(".")
        if is_node and (not enabled_vtsls) then
          lspconfig["tsserver"].setup({})
        end
      end,
      ["lua_ls"] = function()
        lspconfig["lua_ls"].setup({
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
            },
          },
        })
      end,
      ["tailwindcss"] = function()
        lspconfig["tailwindcss"].setup({
          root_dir = lspconfig.util.root_pattern("tailwind.config.js", "tailwind.config.ts", "tailwind.config.lua", "tailwind.config.json"),
        })
      end,
      ["gopls"] = function()
        lspconfig["gopls"].setup({})
      end,
      ["emmet_ls"] = function()
        lspconfig["emmet_ls"].setup({
          extra_filetype = html_like
        })
      end,
      ["cssls"] = function ()
        lspconfig["cssls"].setup({})
      end,
      ["zls"] = function ()
        lspconfig["zls"].setup({})
      end,
      ["ruby_ls"] = function ()
        lspconfig["ruby_ls"].setup({})
      end,
      ["vuels"] = function ()
        lspconfig["vuels"].setup({})
      end,
      ["svelte"] = function ()
        lspconfig["svelte"].setup({})
      end,
      ["eslint"] = function ()
        lspconfig["eslint"].setup({})
      end,
      ["volar"] = function ()
        lspconfig["volar"].setup({})
      end,
      ["rust_analyzer"] = function()
        lspconfig["rust_analyzer"].setup({
        -- → $generated-end                                                       
        -- → $generated-start                                                     
        -- → rust-analyzer.assist.emitMustUse                                      default: false
        -- → rust-analyzer.assist.expressionFillDefault                            default: "todo"
        -- → rust-analyzer.cachePriming.enable                                     default: true
        -- → rust-analyzer.cachePriming.numThreads                                 default: 0
        -- → rust-analyzer.cargo.autoreload                                        default: true
        -- → rust-analyzer.cargo.buildScripts.enable                               default: true
        -- → rust-analyzer.cargo.buildScripts.invocationLocation                   default: "workspace"
        -- → rust-analyzer.cargo.buildScripts.invocationStrategy                   default: "per_workspace"
        -- → rust-analyzer.cargo.buildScripts.overrideCommand                     
        -- → rust-analyzer.cargo.buildScripts.useRustcWrapper                      default: true
        -- → rust-analyzer.cargo.cfgs                                              default: {}
        -- → rust-analyzer.cargo.extraArgs                                         default: []
        -- → rust-analyzer.cargo.extraEnv                                          default: {}
        -- → rust-analyzer.cargo.features                                          default: []
        -- → rust-analyzer.cargo.noDefaultFeatures                                 default: false
        -- → rust-analyzer.cargo.sysroot                                           default: "discover"
        -- → rust-analyzer.cargo.sysrootSrc                                       
        -- → rust-analyzer.cargo.target                                           
        -- → rust-analyzer.cargo.unsetTest                                         default: ["core"]
        -- → rust-analyzer.cargoRunner                                            
        -- → rust-analyzer.check.allTargets                                        default: true
        -- → rust-analyzer.check.command                                           default: "check"
        -- → rust-analyzer.check.extraArgs                                         default: []
        -- → rust-analyzer.check.extraEnv                                          default: {}
        -- → rust-analyzer.check.features                                         
        -- → rust-analyzer.check.invocationLocation                                default: "workspace"
        -- → rust-analyzer.check.invocationStrategy                                default: "per_workspace"
        -- → rust-analyzer.check.noDefaultFeatures                                
        -- → rust-analyzer.check.overrideCommand                                  
        -- → rust-analyzer.check.targets                                          
        -- → rust-analyzer.checkOnSave                                             default: true
        -- → rust-analyzer.completion.autoimport.enable                            default: true
        -- → rust-analyzer.completion.autoself.enable                              default: true
        -- → rust-analyzer.completion.callable.snippets                            default: "fill_arguments"
        -- → rust-analyzer.completion.limit                                       
        -- → rust-analyzer.completion.postfix.enable                               default: true
        -- → rust-analyzer.completion.privateEditable.enable                       default: false
        -- → rust-analyzer.completion.snippets.custom                              default: {"Err":{"body":"Err(${receiver})","description":"Wrap the expression in a `Result::Err`","scope":"expr","postfix":"err"},"Some":{"body":"Some(${receiver})","description":"Wrap the expression in an `Option::Some`","scope":"expr","postfix":"some"},"Ok":{"body":"Ok(${receiver})","description":"Wrap the expression in a `Result::Ok`","scope":"expr","postfix":"ok"},"Box::pin":{"requires":"std::boxed::Box","body":"Box::pin(${receiver})","description":"Put the expression into a pinned `Box`","scope":"expr","postfix":"pinbox"},"Arc::new":{"requires":"std::sync::Arc","body":"Arc::new(${receiver})","description":"Put the expression into an `Arc`","scope":"expr","postfix":"arc"},"Rc::new":{"requires":"std::rc::Rc","body":"Rc::new(${receiver})","description":"Put the expression into an `Rc`","scope":"expr","postfix":"rc"}}
        -- → rust-analyzer.debug.engine                                            default: "auto"
        -- → rust-analyzer.debug.engineSettings                                    default: {}
        -- → rust-analyzer.debug.openDebugPane                                     default: false
        -- → rust-analyzer.debug.sourceFileMap                                     default: {"\/rustc\/<id>":"${env:USERPROFILE}\/.rustup\/toolchains\/<toolchain-id>\/lib\/rustlib\/src\/rust"}
        -- → rust-analyzer.diagnostics.disabled                                    default: []
        -- → rust-analyzer.diagnostics.enable                                      default: true
        -- → rust-analyzer.diagnostics.experimental.enable                         default: false
        -- → rust-analyzer.diagnostics.previewRustcOutput                          default: false
        -- → rust-analyzer.diagnostics.remapPrefix                                 default: {}
        -- → rust-analyzer.diagnostics.useRustcErrorCode                           default: false
        -- → rust-analyzer.diagnostics.warningsAsHint                              default: []
        -- → rust-analyzer.diagnostics.warningsAsInfo                              default: []
        -- → rust-analyzer.discoverProjectCommand                                 
        -- → rust-analyzer.files.excludeDirs                                       default: []
        -- → rust-analyzer.files.watcher                                           default: "client"
        -- → rust-analyzer.highlightRelated.breakPoints.enable                     default: true
        -- → rust-analyzer.highlightRelated.closureCaptures.enable                 default: true
        -- → rust-analyzer.highlightRelated.exitPoints.enable                      default: true
        -- → rust-analyzer.highlightRelated.references.enable                      default: true
        -- → rust-analyzer.highlightRelated.yieldPoints.enable                     default: true
        -- → rust-analyzer.hover.actions.debug.enable                              default: true
        -- → rust-analyzer.hover.actions.enable                                    default: true
        -- → rust-analyzer.hover.actions.gotoTypeDef.enable                        default: true
        -- → rust-analyzer.hover.actions.implementations.enable                    default: true
        -- → rust-analyzer.hover.actions.references.enable                         default: false
        -- → rust-analyzer.hover.actions.run.enable                                default: true
        -- → rust-analyzer.hover.documentation.enable                              default: true
        -- → rust-analyzer.hover.documentation.keywords.enable                     default: true
        -- → rust-analyzer.hover.links.enable                                      default: true
        -- → rust-analyzer.hover.memoryLayout.alignment                            default: "hexadecimal"
        -- → rust-analyzer.hover.memoryLayout.enable                               default: true
        -- → rust-analyzer.hover.memoryLayout.niches                               default: false
        -- → rust-analyzer.hover.memoryLayout.offset                               default: "hexadecimal"
        -- → rust-analyzer.hover.memoryLayout.size                                 default: "both"
        -- → rust-analyzer.imports.granularity.enforce                             default: false
        -- → rust-analyzer.imports.granularity.group                               default: "crate"
        -- → rust-analyzer.imports.group.enable                                    default: true
        -- → rust-analyzer.imports.merge.glob                                      default: true
        -- → rust-analyzer.imports.prefer.no.std                                   default: false
        -- → rust-analyzer.imports.prefix                                          default: "plain"
        -- → rust-analyzer.inlayHints.bindingModeHints.enable                      default: false
        -- → rust-analyzer.inlayHints.chainingHints.enable                         default: true
        -- → rust-analyzer.inlayHints.closingBraceHints.enable                     default: true
        -- → rust-analyzer.inlayHints.closingBraceHints.minLines                   default: 25
        -- → rust-analyzer.inlayHints.closureCaptureHints.enable                   default: false
        -- → rust-analyzer.inlayHints.closureReturnTypeHints.enable                default: "never"
        -- → rust-analyzer.inlayHints.closureStyle                                 default: "impl_fn"
        -- → rust-analyzer.inlayHints.discriminantHints.enable                     default: "never"
        -- → rust-analyzer.inlayHints.expressionAdjustmentHints.enable             default: "never"
        -- → rust-analyzer.inlayHints.expressionAdjustmentHints.hideOutsideUnsafe  default: false
        -- → rust-analyzer.inlayHints.expressionAdjustmentHints.mode               default: "prefix"
        -- → rust-analyzer.inlayHints.lifetimeElisionHints.enable                  default: "never"
        -- → rust-analyzer.inlayHints.lifetimeElisionHints.useParameterNames       default: false
        -- → rust-analyzer.inlayHints.maxLength                                    default: 25
        -- → rust-analyzer.inlayHints.parameterHints.enable                        default: true
        -- → rust-analyzer.inlayHints.reborrowHints.enable                         default: "never"
        -- → rust-analyzer.inlayHints.renderColons                                 default: true
        -- → rust-analyzer.inlayHints.typeHints.enable                             default: true
        -- → rust-analyzer.inlayHints.typeHints.hideClosureInitialization          default: false
        -- → rust-analyzer.inlayHints.typeHints.hideNamedConstructor               default: false
        -- → rust-analyzer.interpret.tests                                         default: false
        -- → rust-analyzer.joinLines.joinAssignments                               default: true
        -- → rust-analyzer.joinLines.joinElseIf                                    default: true
        -- → rust-analyzer.joinLines.removeTrailingComma                           default: true
        -- → rust-analyzer.joinLines.unwrapTrivialBlock                            default: true
        -- → rust-analyzer.lens.debug.enable                                       default: true
        -- → rust-analyzer.lens.enable                                             default: true
        -- → rust-analyzer.lens.forceCustomCommands                                default: true
        -- → rust-analyzer.lens.implementations.enable                             default: true
        -- → rust-analyzer.lens.location                                           default: "above_name"
        -- → rust-analyzer.lens.references.adt.enable                              default: false
        -- → rust-analyzer.lens.references.enumVariant.enable                      default: false
        -- → rust-analyzer.lens.references.method.enable                           default: false
        -- → rust-analyzer.lens.references.trait.enable                            default: false
        -- → rust-analyzer.lens.run.enable                                         default: true
        -- → rust-analyzer.linkedProjects                                          default: []
        -- → rust-analyzer.lru.capacity                                           
        -- → rust-analyzer.lru.query.capacities                                    default: {}
        -- → rust-analyzer.notifications.cargoTomlNotFound                         default: true
        -- → rust-analyzer.numThreads                                             
        -- → rust-analyzer.procMacro.attributes.enable                             default: true
        -- → rust-analyzer.procMacro.enable                                        default: true
        -- → rust-analyzer.procMacro.ignored                                       default: {}
        -- → rust-analyzer.procMacro.server                                       
        -- → rust-analyzer.references.excludeImports                               default: false
        -- → rust-analyzer.restartServerOnConfigChange                             default: false
        -- → rust-analyzer.runnables.command                                      
        -- → rust-analyzer.runnables.extraArgs                                     default: []
        -- → rust-analyzer.runnables.extraEnv                                     
        -- → rust-analyzer.runnables.problemMatcher                                default: ["$rustc"]
        -- → rust-analyzer.rustc.source                                           
        -- → rust-analyzer.rustfmt.extraArgs                                       default: []
        -- → rust-analyzer.rustfmt.overrideCommand                                
        -- → rust-analyzer.rustfmt.rangeFormatting.enable                          default: false
        -- → rust-analyzer.semanticHighlighting.doc.comment.inject.enable          default: true
        -- → rust-analyzer.semanticHighlighting.nonStandardTokens                  default: true
        -- → rust-analyzer.semanticHighlighting.operator.enable                    default: true
        -- → rust-analyzer.semanticHighlighting.operator.specialization.enable     default: false
        -- → rust-analyzer.semanticHighlighting.punctuation.enable                 default: false
        -- → rust-analyzer.semanticHighlighting.punctuation.separate.macro.bang    default: false
        -- → rust-analyzer.semanticHighlighting.punctuation.specialization.enable  default: false
        -- → rust-analyzer.semanticHighlighting.strings.enable                     default: true
        -- → rust-analyzer.server.extraEnv                                        
        -- → rust-analyzer.server.path                                            
        -- → rust-analyzer.showDependenciesExplorer                                default: true
        -- → rust-analyzer.showUnlinkedFileNotification                            default: true
        -- → rust-analyzer.signatureInfo.detail                                    default: "full"
        -- → rust-analyzer.signatureInfo.documentation.enable                      default: true
        -- → rust-analyzer.trace.extension                                         default: false
        -- → rust-analyzer.trace.server                                            default: "off"
        -- → rust-analyzer.typing.autoClosingAngleBrackets.enable                  default: false
        -- → rust-analyzer.typing.continueCommentsOnNewline                        default: true
        -- → rust-analyzer.workspace.symbol.search.kind                            default: "only_types"
        -- → rust-analyzer.workspace.symbol.search.limit                           default: 128
        -- → rust-analyzer.workspace.symbol.search.scope                           default: "workspace"
        })
      end,
    })
  end
}
