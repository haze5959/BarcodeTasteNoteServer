import { Context, helpers } from "https://deno.land/x/oak/mod.ts";
import { ErrorMessage } from "../utils/error_msg.ts";

export async function postFavorite(ctx: Context) {
  if (ctx.request.hasBody) {
    try {
      const body = await ctx.request.body({ type: "json" }).value;
      const barcodeId = body["barcode_id"] as number;
      const userId = body["user_id"] as number;

      // const result = await postsRepo.createPosts(
      //   type,
      //   title,
      //   bodyVal,
      //   nick,
      // );

      if (true) {  // if (result.affectedRows != null)
        ctx.response.body = { result: true, msg: "" };
      } else {
        ctx.response.body = { result: false, msg: ErrorMessage.NOT_EXCUTE };
      }
    } catch (error) {
      console.error(error);
      ctx.response.body = { result: false, msg: ErrorMessage.SERVER_ERROR };
    }
  } else {
    ctx.response.body = { result: false, msg: ErrorMessage.PARAM_FAIL };
  }
}

export async function deleteFavorite(ctx: Context) {
  const params = helpers.getQuery(ctx, { mergeParams: true });
  const barcodeId =  Number(params.barcode_id);
  const userId = Number(params.user_id);

  if (barcodeId != undefined && userId != undefined) {
    try {
      // const result = await postsRepo.deleteGood(id);
      const result = true
      if (result != undefined) {
        ctx.response.body = { result: true, msg: "" };
      } else {
        ctx.response.body = { result: false, msg: ErrorMessage.NOT_EXIST };
      }
    } catch (error) {
      console.error(error);
      ctx.response.body = { result: false, msg: ErrorMessage.SERVER_ERROR };
    }
  } else {
    ctx.response.body = { result: false, msg: ErrorMessage.PARAM_FAIL };
  }
}
