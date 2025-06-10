class YeeguideResponse {
  String? output;
  // List<Null>? callbackEvents;
  Metadata? metadata;
  bool? isOver;

  YeeguideResponse({this.output,
    // this.callbackEvents,
    this.isOver,
    this.metadata});

  YeeguideResponse.fromJson(Map<String, dynamic> json) {
    output =  json['output'];
    // output =  utf8.decode(json['output']);
    // if (json['callback_events'] != null) {
    //   // callbackEvents = <Null>[];
    //   json['callback_events'].forEach((v) {
    //     callbackEvents!.add(new Null.fromJson(v));
    //   });
    // }
    metadata = json['metadata'] != null
        ? new Metadata.fromJson(json['metadata'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['output'] = this.output;
    // if (this.callbackEvents != null) {
    //   data['callback_events'] =
    //       this.callbackEvents!.map((v) => v.toJson()).toList();
    // }
    if (this.metadata != null) {
      data['metadata'] = this.metadata!.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'YeeguideResponse{output: $output, metadata: $metadata}';
  }
}

class Metadata {
  String? runId;

  Metadata({this.runId});

  Metadata.fromJson(Map<String, dynamic> json) {
    runId = json['run_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['run_id'] = this.runId;
    return data;
  }
}
