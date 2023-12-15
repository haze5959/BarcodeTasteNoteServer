import { Context, helpers } from "https://deno.land/x/oak/mod.ts";
import { ErrorMessage } from "../utils/error_msg.ts";

export async function getUserInfo(ctx: Context) {
    const params = helpers.getQuery(ctx);
    console.log(params);
    const userId = Number(params.user_id);

    try {
        ctx.response.body = {
            result: true,
            msg: "",
            data: [{
                "id": 111,
                "nick_name": 111,
                "profile_image_id": 111,
            }]
        };
    } catch (error) {
        console.error(error);
        ctx.response.body = { result: false, msg: ErrorMessage.SERVER_ERROR };
    }
}