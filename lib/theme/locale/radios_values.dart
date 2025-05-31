class RadiosValues{
  static String restaurant="restaurant";
  static String pos="POS";
  static String cost="cost";
  static String group="group";
  static String piece="piece";
  static const String logo="logo";
  static const String text="text";

  static List<String> priceGroup ()=> [cost, group, piece];
  static List<String> posScreenGroup ()=> [restaurant, pos];

}