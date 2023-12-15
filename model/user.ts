export class User {
    id: number;
    profileImageId: number;
    nickName: string;

    constructor(json: Record<string, string>) {
        this.id = Number(json["id"]);
        this.profileImageId = Number(json["profile_image_id"]);
        this.nickName = json["nick_name"];
    }
}