class DemoModel {
  String id;
  String channelname;
  String title;
  String highThumbnail;
  String lowThumbnail;
  String mediumThumbnail;
  bool isChecked = false;

  //List<Null> tags;

  DemoModel(
      {this.id,
      this.channelname,
      this.title,
      this.highThumbnail,
      this.lowThumbnail,
      this.mediumThumbnail /*,
        this.tags*/
      });

  DemoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    channelname = json['channelname'];
    title = json['title'];
    highThumbnail = json['high thumbnail'];
    lowThumbnail = json['low thumbnail'];
    mediumThumbnail = json['medium thumbnail'];
    /* if (json['tags'] != null) {
      tags = new List<Null>();
      json['tags'].forEach((v) {
        tags.add(new Null.fromJson(v));
      });
    }*/
  }

  DemoModel.fromJson1(Map<String, dynamic> json) {
    id = json['id'];
    channelname = json['channelname'];
    title = json['title'];
    highThumbnail = json['high_thumbnail'];
    lowThumbnail = json['low_thumbnail'];
    mediumThumbnail = json['medium_thumbnail'];
    /* if (json['tags'] != null) {
      tags = new List<Null>();
      json['tags'].forEach((v) {
        tags.add(new Null.fromJson(v));
      });
    }*/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['channelname'] = this.channelname;
    data['title'] = this.title;
    data['high_thumbnail'] = this.highThumbnail;
    data['low_thumbnail'] = this.lowThumbnail;
    data['medium_thumbnail'] = this.mediumThumbnail;
    /*if (this.tags != null) {
      data['tags'] = this.tags.map((v) => v.toJson()).toList();
    }*/
    return data;
  }
}
