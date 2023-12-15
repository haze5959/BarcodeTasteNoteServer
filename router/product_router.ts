import { Router } from "https://deno.land/x/oak/mod.ts";
import {
  getProductList,
  getProductDetail,
} from "../controller/product_controller.ts";

const productRouter = new Router();

productRouter
  .get("/product", getProductList)

export { productRouter };