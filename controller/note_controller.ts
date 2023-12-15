import { Context, helpers } from "https://deno.land/x/oak/mod.ts";
import { ErrorMessage } from "../utils/error_msg.ts";

export async function getNoteList(ctx: Context) {
    const params = helpers.getQuery(ctx);
    console.log(params);
    const barcodeId = Number(params.barcode_id);

    try {
        ctx.response.body = {
            result: true,
            msg: "",
            data: [{
                "id": 111,
                "user_id": 111,
                "barcode_id": 111,
                "body": "111",
                "registered": "111",
                "nick_name": "111",
                "profile_image_id": "111"
            }]
        };
    } catch (error) {
        console.error(error);
        ctx.response.body = { result: false, msg: ErrorMessage.SERVER_ERROR };
    }
}

export async function postNote(ctx: Context) {
    if (ctx.request.hasBody) {
        try {
            const body = await ctx.request.body({ type: "json" }).value;
            const barcodeId = body["barcode_id"] as number;
            const userId = body["user_id"] as number;
            const noteBody = body["body"] as string;
            const registered = body["registered"] as string;

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

export async function deleteDelete(ctx: Context) {
    const params = helpers.getQuery(ctx, { mergeParams: true });
    const noteId = Number(params.id);

    if (noteId != undefined) {
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
