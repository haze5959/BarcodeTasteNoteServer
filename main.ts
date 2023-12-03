import { Application } from "https://deno.land/x/oak/mod.ts";
import { oakCors } from "https://deno.land/x/cors/mod.ts";
import { productRouter } from "./router/product_router.ts";

const app = new Application();
app.use(oakCors({ origin: "*" }));
app.use(productRouter.routes(), productRouter.allowedMethods());

await app.listen({ port: 8000 });