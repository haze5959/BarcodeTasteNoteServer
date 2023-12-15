import { Application } from "https://deno.land/x/oak/mod.ts";
import { superoak } from "https://deno.land/x/superoak/mod.ts";
// import { userRouter } from "../routers/user_router.ts";
import { testCheck } from "./test_utils.ts";

// s udodeno test --allow-all ./tests/user_test.ts
const app = new Application();
// app.use(userRouter.routes(), userRouter.allowedMethods());
