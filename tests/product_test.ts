import { Application } from "https://deno.land/x/oak/mod.ts";
import { superoak } from "https://deno.land/x/superoak/mod.ts";
import { productRouter } from "../router/product_router.ts";
import { testCheck } from "./test_utils.ts";

// sudo deno test --allow-all ./tests/product_test.ts
const app = new Application();
app.use(productRouter.routes(), productRouter.allowedMethods());

Deno.test("GET /product", async () => {
  const request = await superoak(app);
  await request.get("/product")
    .expect(testCheck);
});