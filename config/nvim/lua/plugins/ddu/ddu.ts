import { BaseConfig } from "https://deno.land/x/ddu_vim@v3.2.7/types.ts";
import { ConfigArguments } from "https://deno.land/x/ddu_vim@v3.2.7/base/config.ts";

export class Config extends BaseConfig {
  override config(args: ConfigArguments): Promise<void> {
    args.contextBuilder.setLocal("find_files", {
      ui: "ff",
      sources: [
        {
          name: "file_rec",
          params: {},
        },
      ],
      sourceOptions: {
        _: {
          ignoreCase: true,
          matchers: ["matcher_substring"],
        },
      },
      kindOptions: {
        file: {
          defaultAction: "open",
        },
      },
    });

    return Promise.resolve();
  }
}
