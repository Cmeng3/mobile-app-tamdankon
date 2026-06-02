List<double> extractCoordinate(String? latLng) {
  // if latLng value is a null, let return [0, 0] value
  if(latLng == null ){
    return [0, 0];
  }
  // split the latlng string into array of lat, and lng
  List<String> coordinate = latLng.split(',');
  // convert it to double
  List<double> doubleLatLngValue = [double.tryParse(coordinate[0])!, double.tryParse(coordinate[1])!];

  return doubleLatLngValue;
}