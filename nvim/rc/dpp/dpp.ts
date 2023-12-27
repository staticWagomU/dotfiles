import { ensure, is } from "https://deno.land/x/unknownutil@v3.10.0/mod.ts";
import {
  BaseConfig,
  ConfigReturn,
  ContextBuilder,
  Dpp,
  Plugin,
} from "https://deno.land/x/dpp_vim@v0.0.5/types.ts";
import { Denops, fn } from "https://deno.land/x/dpp_vim@v0.0.5/deps.ts";

type Toml = {
  hooks_file?: string;
  ftplugins?: Record<string, string>;
  plugins?: Plugin[];
};

type LazyMakeStateResult = {
  plugins: Plugin[];
  stateLines: string[];
};

const isStringArray = is.ArrayOf(is.String);
// https://github.com/kuuote/dotvim/blob/version5/conf/dpp.ts?plain=1#L27-L32
async function glob(denops: Denops, path: string): Promise<string[]> {
  return ensure(
    await denops.call("glob", path, 1, 1),
    isStringArray,
  );
}

export class Config extends BaseConfig {
  override async config(args: {
    denops: Denops;
    contextBuilder: ContextBuilder;
    basePath: string;
    dpp: Dpp;
  }): Promise<ConfigReturn> {
    const dotfilesDir = "~/dotfiles/config/nvim/rc";
    const tomlPaths = await glob(args.denops, `${dotfilesDir}/*.toml`);
    const hasWindows = await fn.has(args.denops, "win32");

    args.contextBuilder.setGlobal({
      extParams: {
        installer: {
          checkDiff: true,
          logFilePath: "~/.cache/dpp/installer-log.txt",
        },
      },
      protocols: ["git"],
    });

    const [context, options] = await args.contextBuilder.get(args.denops);

    const tomls: Toml[] = [];
    for (const tomlPath of tomlPaths) {
      tomls.push(
        await args.dpp.extAction(
          args.denops,
          context,
          options,
          "toml",
          "load",
          {
            path: tomlPath,
            options: {
              lazy: false,
            },
          },
        ) as Toml,
      );
    }
    if (hasWindows) {
      tomls.push(
        await args.dpp.extAction(
          args.denops,
          context,
          options,
          "toml",
          "load",
          {
            path: "~/dotfiles/config/nvim/rc/windows/windows.toml",
            options: {
              lazy: false,
            },
          },
        ) as Toml,
      );
    }

    const recordPlugins: Record<string, Plugin> = {};
    const ftplugins: Record<string, string> = {};
    const hooksFiles: string[] = [];

    tomls.forEach((toml) => {
      for (const plugin of toml.plugins!) {
        recordPlugins[plugin.name] = plugin;
      }

      if (toml.ftplugins) {
        for (const filetype of Object.keys(toml.ftplugins)) {
          if (ftplugins[filetype]) {
            ftplugins[filetype] += `\n${toml.ftplugins[filetype]}`;
          } else {
            ftplugins[filetype] = toml.ftplugins[filetype];
          }
        }
      }

      if (toml.hooks_file) {
        hooksFiles.push(toml.hooks_file);
      }
    });

    const localPlugins = await args.dpp.extAction(
      args.denops,
      context,
      options,
      "local",
      "local",
      {
        directory: "~/dotfiles/config/nvim/plug",
        options: {
          frozen: true,
          merged: false,
        },
        includes: [
          "ddu-source-keymaps",
          "denops-statusline",
        ],
      },
    ) as Plugin[] | undefined;

    if (localPlugins) {
      for (const plugin of localPlugins) {
        if (plugin.name in recordPlugins) {
          recordPlugins[plugin.name] = Object.assign(
            recordPlugins[plugin.name],
            plugin,
          );
        } else {
          recordPlugins[plugin.name] = plugin;
        }
      }
    }

    const lazyResult = await args.dpp.extAction(
      args.denops,
      context,
      options,
      "lazy",
      "makeState",
      {
        plugins: Object.values(recordPlugins),
      },
    ) as LazyMakeStateResult;

    return {
      ftplugins,
      hooksFiles,
      plugins: lazyResult.plugins ?? [],
      stateLines: lazyResult.stateLines,
    };
  }
}
