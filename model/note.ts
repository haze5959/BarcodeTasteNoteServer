export class Note {
    id: number;
    userId: number;
    barcodeId: number;
    body: string;
    registered: string;

    constructor(json: Record<string, string>) {
        this.id = Number(json["id"]);
        this.userId = Number(json["user_id"]);
        this.barcodeId = Number(json["barcode_id"]);
        this.body = json["body"];
        this.registered = json["registered"];
    }
}