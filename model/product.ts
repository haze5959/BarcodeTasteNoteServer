export class Product {
  barcodeId: number;
  name: string;
  imageId: number;

  constructor(json: Record<string, string>) {
    this.barcodeId = Number(json["barcode_id"]);
    this.name = json["name"];
    this.imageId = Number(json["image_id"]);
  }
}

export class ProductImage {
  id: number;
  barcodeId: number;
  noteId: number;

  constructor(json: Record<string, string>) {
    this.id = Number(json["id"]);
    this.barcodeId = Number(json["barcode_id"]);
    this.noteId = Number(json["note_id"]);
  }
}