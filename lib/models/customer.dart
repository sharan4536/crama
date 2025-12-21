class Customer {
  final String id;
  String name;
  String phone;
  String? photoPath;
  double? chest;
  double? waist;
  double? hip;
  double? shoulder;
  double? sleeveLength;
  double? neck;
  double? blouseLength;
  String? notes;
  List<String> styles;

  Customer({
    required this.id,
    required this.name,
    required this.phone,
    this.photoPath,
    this.chest,
    this.waist,
    this.hip,
    this.shoulder,
    this.sleeveLength,
    this.neck,
    this.blouseLength,
    this.notes,
    this.styles = const [],
  });
}

