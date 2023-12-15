import { Context, helpers } from "https://deno.land/x/oak/mod.ts";
import { ErrorMessage } from "../utils/error_msg.ts";

// PRODUCT + PRODUCT_IMAGE(대표)
export async function getProductList(ctx: Context) {
  const params = helpers.getQuery(ctx);
  console.log(params);

  try {
    ctx.response.body = {
      result: true,
      msg: "",
      data: [{
        "barcode_id": 111,
        "name": "111",
        "image_id": 111,
        "favorite_count": 111
      }]
    };
  } catch (error) {
    console.error(error);
    ctx.response.body = { result: false, msg: ErrorMessage.SERVER_ERROR };
  }
}

// PRODUCT + PRODUCT_IMAGE(대표) + NOTE(최근)||--|USER
export async function getProductDetail(ctx: Context) {
  const params = helpers.getQuery(ctx);
  console.log(params);

  try {
    ctx.response.body = {
      result: true,
      msg: "",
      data: {
        "barcode_id": 111,
        "name": "111",
        "image_id": 111,
        "favorite_count": 111,
        "note_body": "111",
        "nick_name": "111",
        "profile_image_id": "111",
        "registered": "111",
      }
    };
  } catch (error) {
    console.error(error);
    ctx.response.body = { result: false, msg: ErrorMessage.SERVER_ERROR };
  }
}

export async function postProduct(ctx: Context) {
  if (ctx.request.hasBody) {
    try {
      const body = await ctx.request.body({ type: "json" }).value;
      const barcodeId = body["barcode_id"] as number;
      const name = body["name"] as string;
      // const data = body["image"] as Data || undefined;

      // 이미지 없이도 등록 가능
      // 이미지 클라우드 스토리지에 저장 후 아이디 가져오기

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