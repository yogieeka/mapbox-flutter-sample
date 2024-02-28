class PurpleMap {
  PurpleMap({
    required this.geojson,
    required this.id,
    required this.user,
    required this.geoProject,
    required this.folder,
    required this.status,
  });
  late final Geojson geojson;
  late final String id;
  late final String user;
  late final String geoProject;
  late final String folder;
  late final String status;
  
  PurpleMap.fromJson(Map<String, dynamic> json){
    geojson = Geojson.fromJson(json['geojson']);
    id = json['_id'];
    user = json['user'];
    geoProject = json['geo_project'];
    folder = json['folder'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['geojson'] = geojson.toJson();
    _data['_id'] = id;
    _data['user'] = user;
    _data['geo_project'] = geoProject;
    _data['folder'] = folder;
    _data['status'] = status;
    return _data;
  }
}

class Geojson {
  Geojson({
    required this.type,
    required this.features,
  });
  late final String type;
  late final List<Features> features;
  
  Geojson.fromJson(Map<String, dynamic> json){
    type = json['type'];
    features = List.from(json['features']).map((e)=>Features.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['type'] = type;
    _data['features'] = features.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Features {
  Features({
    required this.geometry,
    required this.formStatus,
    required this.formProgress,
    required this.refFeature,
    required this.dataPembandingList,
    required this.user,
    required this.key,
    required this.type,
    required this.properties,
    required this.id,
    required this.childArray,
    required this.countingCustomArray,
  });
  late final Geometry geometry;
  late final FormStatus formStatus;
  late final FormProgress formProgress;
  late final RefFeature refFeature;
  late final List<dynamic> dataPembandingList;
  late final String user;
  late final String key;
  late final String type;
  late final Properties properties;
  late final String id;
  late final List<dynamic> childArray;
  late final List<dynamic> countingCustomArray;
  
  Features.fromJson(Map<String, dynamic> json){
    geometry = Geometry.fromJson(json['geometry']);
    formStatus = FormStatus.fromJson(json['formStatus']);
    formProgress = FormProgress.fromJson(json['formProgress']);
    refFeature = RefFeature.fromJson(json['ref_feature']);
    dataPembandingList = List.castFrom<dynamic, dynamic>(json['data_pembanding_list']);
    user = json['user'];
    key = json['key'];
    type = json['type'];
    properties = Properties.fromJson(json['properties']);
    id = json['_id'];
    childArray = List.castFrom<dynamic, dynamic>(json['child_array']);
    countingCustomArray = List.castFrom<dynamic, dynamic>(json['counting_custom_array']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['geometry'] = geometry.toJson();
    _data['formStatus'] = formStatus.toJson();
    _data['formProgress'] = formProgress.toJson();
    _data['ref_feature'] = refFeature.toJson();
    _data['data_pembanding_list'] = dataPembandingList;
    _data['user'] = user;
    _data['key'] = key;
    _data['type'] = type;
    _data['properties'] = properties.toJson();
    _data['_id'] = id;
    _data['child_array'] = childArray;
    _data['counting_custom_array'] = countingCustomArray;
    return _data;
  }
}

class Geometry {
  Geometry({
    required this.coordinates,
    required this.type,
  });
  late final List<double> coordinates;
  late final String type;
  
  Geometry.fromJson(Map<String, dynamic> json){
    coordinates = List.castFrom<dynamic, double>(json['coordinates']);
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['coordinates'] = coordinates;
    _data['type'] = type;
    return _data;
  }
}

class FormStatus {
  FormStatus({
    required this.status,
    required this.message,
    required this.revisionList,
  });
  late final String status;
  late final String message;
  late final List<dynamic> revisionList;
  
  FormStatus.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    revisionList = List.castFrom<dynamic, dynamic>(json['revision_list']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['revision_list'] = revisionList;
    return _data;
  }
}

class FormProgress {
  FormProgress({
    required this.message,
    required this.status,
  });
  late final String message;
  late final String status;
  
  FormProgress.fromJson(Map<String, dynamic> json){
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['status'] = status;
    return _data;
  }
}

class RefFeature {
  RefFeature({
    required this.status,
  });
  late final bool status;
  
  RefFeature.fromJson(Map<String, dynamic> json){
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    return _data;
  }
}

class Properties {
  Properties({
    required this.iconImage,
    required this.textField,
    required this.fillColor,
    required this.circleRadius,
    required this.circleStrokeWidth,
    required this.circleStrokeColor,
    required this.Nama,
    required this.Status,
    required this.Angka,
  });
  late final String iconImage;
  late final String textField;
  late final String fillColor;
  late final int circleRadius;
  late final int circleStrokeWidth;
  late final String circleStrokeColor;
  late final String Nama;
  late final String Status;
  late final String Angka;
  
  Properties.fromJson(Map<String, dynamic> json){
    iconImage = json['icon_image'];
    textField = json['text_field'];
    fillColor = json['fill_color'];
    circleRadius = json['circle_radius'];
    circleStrokeWidth = json['circle_stroke_width'];
    circleStrokeColor = json['circle_stroke_color'];
    Nama = json['Nama'];
    Status = json['Status'];
    Angka = json['Angka'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['icon_image'] = iconImage;
    _data['text_field'] = textField;
    _data['fill_color'] = fillColor;
    _data['circle_radius'] = circleRadius;
    _data['circle_stroke_width'] = circleStrokeWidth;
    _data['circle_stroke_color'] = circleStrokeColor;
    _data['Nama'] = Nama;
    _data['Status'] = Status;
    _data['Angka'] = Angka;
    return _data;
  }
}