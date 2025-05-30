class RadiosValues{
  static String restaurant="restaurant";
  static String pos="POS";
  static String cost="cost";
  static String group="group";
  static String piece="piece";
  static List<String> priceGroup ()=> [cost, group, piece];
  static List<String> posScreenGroup ()=> [restaurant, pos];

}