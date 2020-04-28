class RechercheBean {

  String texte = null;

  bool deep0to20 = false;
  bool deep20to40 = false;
  bool deep40to60 = false;
  bool deep60to70 = false;
  bool deep70to120 = false;

  Set<String> places = new Set();
  Set<String> kinds = new Set();

  double distanceValue = 3000.0;
  double maximumDistanceValue = 3000.0;
  String distanceType = 'Kilometers';

  RechercheBean(){
    deep0to20 = true;
    deep20to40 = true;
    deep40to60 = true;
  }

  //place
  void addPlace(String place){
    places.add(place);
  }

  void removePlace(String place){
    places.remove(place);
  }

  //place
  void addKind(String kind){
    kinds.add(kind);
  }

  void removeKind(String kind){
    kinds.remove(kind);
  }

  void setDistanceValue(double value) {
    distanceValue = value;
  }
}