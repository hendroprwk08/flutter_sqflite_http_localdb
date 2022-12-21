//detil makanan yang tersimpan
class Detil {
  String idMeal, strMeal, strCategory, strInstructions, strMealThumb;

  Detil(this.idMeal, this.strMeal, this.strCategory, this.strInstructions, this.strMealThumb);

  factory Detil.fromJson(Map<String, dynamic> json) {
    return Detil(
        json['idMeal'],
        json['strMeal'],
        json['strCategory'],
        json['strInstructions'],
        json['strMealThumb']
    );
  }
}