class Makanan {
  String idMeal, strMeal, strMealThumb;

  Makanan(this.idMeal, this.strMeal, this.strMealThumb);

  factory Makanan.fromJson(Map<String, dynamic> json) {
    return Makanan(
        json['idMeal'],
        json['strMeal'],
        json['strMealThumb']
    );
  }
}