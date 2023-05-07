class TypingPrompt {
  String sentence;
  String typed;
  int index;

  TypingPrompt(String s) {
    sentence = s;
    typed = "";
    index = 0;
  }

  void display(float x, float y) {
    text(sentence, x, y - 40);
    text(typed + "_", x, y + 40);
  }

  boolean type(char c) {
    if (c == sentence.charAt(index)) {
      typed += c;
      index++;
      if (index >= sentence.length()) {
        return true;
      }
    }
    return false;
  }

  int getWordCount() {
    return sentence.split(" ").length;
  }
}

void drawBorder(color c, int thickness) {
  noFill();
  stroke(c);
  strokeWeight(thickness);
  rect(thickness / 2, thickness / 2, width - thickness, height - thickness);
}
