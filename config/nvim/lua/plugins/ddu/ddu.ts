import { BaseConfig } from "https://deno.land/x/ddu_vim@v3.0.2/types.ts";
import { ConfigArguments } from "https://deno.land/x/ddu_vim@v3.0.2/base/config.ts";

export class Config extends BaseConfig {
  override config(args: ConfigArguments): Promise<void> {
    args.setAlias("source", "file_rg", "file_external");
    args.setAlias("action", "tabopen", "open");

    args.contextBuilder.patchGlobal({
      ui: "ff",
      kindOptions: {
        file: {
          defaultAction: "open",
        },
      },
      sourceOptions: {
        _: {
          ignoreCase: true,
          matchers: ["matcher_substring"],
        },
      },
    });

    return Promise.resolve();
  }
}
