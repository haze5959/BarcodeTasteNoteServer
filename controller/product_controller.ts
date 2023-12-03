import { Context, helpers } from "https://deno.land/x/oak/mod.ts";
import { ErrorMessage } from "../utils/error_msg.ts";

export async function getProduct(ctx: Context) {
  const params = helpers.getQuery(ctx);
  console.log(params);

  try {
    ctx.response.body = {
      result: true,
      msg: "",
      data: {
        "test": "test"
      },
    };
  } catch (error) {
    console.error(error);
    ctx.response.body = { result: false, msg: ErrorMessage.SERVER_ERROR };
  }
}