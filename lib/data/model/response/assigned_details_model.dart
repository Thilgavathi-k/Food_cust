class AssignedDetails {
  int id;
  int restaurant_id;
  int order_id;
  String delivery_date;
  String type;
  int day;
  String time;
  String status;
  String createdAt;
  String updatedAt;
  AssignedDetails(
      {
        this.id,
        this.restaurant_id,
        this.order_id,
        this.delivery_date,
        this.day,
        this.time,
        this.status,
        this.createdAt,
        this.updatedAt
      });

  AssignedDetails.fromJson(Map<String, dynamic> json)
  {
    id = json['id'];
    restaurant_id = json['restaurant_id'];
    order_id = json['order_id'];
    delivery_date = json['delivery_date'];
    day = json['day'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['restaurant_id'] = this.restaurant_id;
    data['delivery_date'] = this.delivery_date;
    data['day'] = this.day;
    data['time'] = this.time;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
