import { Application } from "https://deno.land/x/oak/mod.ts";
import { superoak } from "https://deno.land/x/superoak/mod.ts";
// import { userRouter } from "../routers/user_router.ts";
import { testCheck } from "./test_utils.ts";

// sudo deno test --allow-all ./tests/favorite_test.ts
const app = new Application();
// app.use(userRouter.routes(), userRouter.allowedMethods());

Deno.test("POST /favorite", async () => {
    const request = await superoak(app);
    await request.post("/favorite")
      .set("Content-Type", "application/json")
      .send({ "barcode_id": 1111, "user_id": 1111 })
      .expect(testCheck);
  });
  
  Deno.test("DELETE /favorite?user_id=&barcode_id=", async () => {
    const request = await superoak(app);
    await request.delete(`/favorite?user_id=${1111}&barcode_id=${1111}`)
      .expect(testCheck);
  });