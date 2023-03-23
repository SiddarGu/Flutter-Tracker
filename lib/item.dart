class Item {
  int id;
  String description;
  String trackingId;
  String carrier;

  Item({
    required this.id,
    required this.description,
    required this.trackingId,
    required this.carrier
  });

  factory Item.fromDatabase(Map<String, dynamic> json) => Item(
        id: json["id"],
        description: json["description"],
        trackingId: json["trackingId"],
        carrier: json["carrier"]
      );

  Map<String, dynamic> toDatabase() => {
        "id": id,
        "description": description,
        "trackingId": trackingId,
        "carrier": carrier
      };
}
