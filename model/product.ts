export class Product {
  uid: string;
  email: string | undefined;
  name: string | undefined;
  photoUrl: string | undefined;
  validSince: string | undefined;
  lastLoginAt: string | undefined;
  createdAt: string | undefined;
  lastRefreshAt: string | undefined;

  constructor(json: Record<string, string>) {
    this.uid = json["localId"];
    this.email = json["email"];
    this.name = json["displayName"];
    this.photoUrl = json["photoUrl"];
    this.validSince = json["validSince"];
    this.lastLoginAt = json["lastLoginAt"];
    this.createdAt = json["createdAt"];
    this.lastRefreshAt = json["lastRefreshAt"];
  }
}