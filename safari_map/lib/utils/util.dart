class Util {
  static String stringFormat(String text, List<Object> args) {

    String newText = "";
    String str = text;
    for (int index = 0; index < args.length && newText != str; index++) {
      str = text;
      newText = str.replaceAll('{'+index.toString()+'}', args[index].toString());
      text = newText;
    }

    return text;
  }
}