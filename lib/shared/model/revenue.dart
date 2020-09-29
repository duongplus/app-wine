class Revenue{
  dynamic phone;
  dynamic total;
  dynamic percentDiscount;
  dynamic discount;
  dynamic netTotal;
  dynamic date;
  dynamic status;

  Revenue({this.phone, this.total, this.percentDiscount, this.discount,
    this.netTotal, this.date, this.status});

  factory Revenue.fromJson(Map<String, dynamic> map){
    return Revenue(
      phone: map['phone'],
      total: map['total'],
      percentDiscount: map['percentDiscount'],
      discount: map['discount'],
      netTotal: map['netTotal'],
      date: map['date'],
      status: map['status'],
    );
  }

  static List<Revenue> parseRevenueList(map) {
    var list = map['data']['order'] as List;
    return list.map((product) => Revenue.fromJson(product)).toList();
  }
}