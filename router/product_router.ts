import { Router } from "https://deno.land/x/oak/mod.ts";
import {
  getProduct,
} from "../controller/product_controller.ts";

const productRouter = new Router();

productRouter
  // 캠프 관련
  .get("/product", getProduct)

export { productRouter };