import { Application } from "https://deno.land/x/oak/mod.ts";
import { superoak } from "https://deno.land/x/superoak/mod.ts";
// import { postsRouter } from "../routers/posts_router.ts";
import { testCheck } from "./test_utils.ts";

// sudo deno test --allow-all ./tests/note_test.ts
const app = new Application();
// app.use(postsRouter.routes(), postsRouter.allowedMethods());
