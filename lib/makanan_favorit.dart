class MakananFavorit {
  String? _idMeal, _strMeal, _strCategory, _strInstructions, _strMealThumb;

  MakananFavorit(this._idMeal, this._strMeal, this._strCategory,
      this._strInstructions, this._strMealThumb);

  String? get idMeal => _idMeal;

  MakananFavorit.map(dynamic obj){
    this._idMeal = obj["id"];
    this._strMeal = obj["meal"];
    this._strCategory = obj["category"];
    this._strInstructions = obj["instructions"];
    this._strMealThumb = obj["thumb"];
  }

  //petakan antara kolom pada tabel dan isi data
  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();

    map["id"] = _idMeal;
    map["meal"] = _strMeal;
    map["category"] = _strCategory;
    map["instructions"] = _strInstructions;
    map["thumb"] = _strMealThumb;

    return map;
  }

  get strMeal => _strMeal;

  get strCategory => _strCategory;

  get strInstructions => _strInstructions;

  get strMealThumb => _strMealThumb;
}