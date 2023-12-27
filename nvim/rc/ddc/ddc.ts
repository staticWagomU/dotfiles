import { BaseConfig } from "https://deno.land/x/ddc_vim@v4.0.5/types.ts";
import { ConfigArguments } from "https://deno.land/x/ddc_vim@v4.0.5/base/config.ts";

export class Config extends BaseConfig {
  // deno-lint-ignore require-await
  override async config(args: ConfigArguments): Promise<void> {
    const commonSources = [
      "copilot",
      "around",
      "file",
    ];

    args.contextBuilder.patchGlobal({
      ui: "pum",
      autoCompleteEvents: [
        "InsertEnter",
        "TextChangedI",
        "TextChangedP",
        "CmdlineEnter",
        "CmdlineChanged",
        "TextChangedT",
      ],
      sources: commonSources,
      cmdlineSources: {
        ":": ["cmdline", "cmdline-history", "around"],
        "@": ["input", "cmdline-history", "file", "around"],
        ">": ["input", "cmdline-history", "file", "around"],
        "/": ["around", "line"],
        "?": ["around", "line"],
        "-": ["around", "line"],
        "=": ["input"],
      },
      sourceOptions: {
        _: {
          ignoreCase: true,
          matchers: ["matcher_head", "matcher_prefix", "matcher_length"],
          sorters: ["sorter_rank"],
          converters: ["converter_remove_overlap"],
          timeout: 1000,
        },
        around: {
          mark: "A",
        },
        buffer: {
          mark: "B",
        },
        cmdline: {
          mark: "cmdline",
          forceCompletionPattern: "\\S/\\S*|\\.\\w*",
        },
        copilot: {
          mark: "cop",
          matchers: [],
          minAutoCompleteLength: 0,
          isVolatile: false,
        },
        input: {
          mark: "input",
          forceCompletionPattern: "\\S/\\S*",
          isVolatile: true,
        },
        line: {
          mark: "line",
        },
        "lsp": {
          mark: "lsp",
          forceCompletionPattern: "\\.\\w*|::\\w*|->\\w*",
          dup: "force",
        },
        file: {
          mark: "F",
          isVolatile: true,
          minAutoCompleteLength: 1000,
          forceCompletionPattern: "\\S/\\S*",
        },
        "cmdline-history": {
          mark: "history",
          sorters: [],
        },
        rg: {
          mark: "rg",
          minAutoCompleteLength: 5,
          enabledIf: "finddir('.git', ';') != ''",
        },
        skkeleton: {
          mark: "skk",
          matchers: ["skkeleton"],
          sorters: [],
          minAutoCompleteLength: 2,
          isVolatile: true,
        },
      },
      sourceParams: {
        buffer: {
          requireSameFiletype: false,
          limitBytes: 50000,
          fromAltBuf: true,
          forceCollect: true,
        },
        file: {
          filenameChars: "[:keyword:].",
        },
        "shell-native": {
          shell: "fish",
        },
      },
      postFilters: ["sorter_head"],
    });

    for (
      const filetype of [
        "help",
        "vimdoc",
        "markdown",
        "markdown_inline",
        "gitcommit",
        "comment",
      ]
    ) {
      args.contextBuilder.patchFiletype(filetype, {
        sources: commonSources.concat(["line"]),
      });
    }

    for (const filetype of ["html", "css"]) {
      args.contextBuilder.patchFiletype(filetype, {
        sourceOptions: {
          _: {
            keywordPattern: "[0-9a-zA-Z_:#-]*",
          },
        },
      });
    }

    args.contextBuilder.patchFiletype("ddu-ff-filter", {
      sources: ["line", "buffer"],
      sourceOptions: {
        _: {
          keywordPattern: "[0-9a-zA-Z_:#-]*",
        },
      },
      specialBufferCompletion: true,
    });

    for (
      const filetype of [
        "css",
        "go",
        "html",
        "python",
        "ruby",
        "typescript",
        "typescriptreact",
        "tsx",
        "graphql",
      ]
    ) {
      args.contextBuilder.patchFiletype(filetype, {
        sources: ["lsp"].concat(commonSources),
      });
    }

    args.contextBuilder.patchFiletype("lua", {
      sources: [
        "lsp",
      ].concat(commonSources),
    });
  }
}
