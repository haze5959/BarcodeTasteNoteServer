export class Favorite {
    barcodeId: number;
    userId: number;

    constructor(json: Record<string, string>) {
        this.barcodeId = Number(json["barcode_id"]);
        this.userId = Number(json["user_id"]);
    }
}