ArrayList<TypingPrompt> prompts;
int currentPrompt = 0;
boolean finished = false;
long startTime;
long[] endTimes;
float totalTime = 0;
int totalWords = 0;
boolean showWPM = false;
float promptWPM = 0;
color borderColor;

void setup() {
  fullScreen();
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(24);
  initGame();
  borderColor = color(random(255), random(255), random(255));
}

void initGame() {
  String[] sentences = {
    "You're gonna need a bigger boat.",
    "Frankly, my dear, I don't give a damn.",
    "Hasta la vista, baby.",
    "Mama always said life was like a box of chocolates. You never know what you're gonna get.",
    "You don't understand! I coulda had class. I coulda been a contender. I could've been somebody, instead of a bum, which is what I am.",
    "Wait a minute, wait a minute. You ain't heard nothin' yet!",
    "May the Force be with you.",
    "A million dollars isn't cool. You know what's cool? A billion dollars",
    "I love the smell of napalm in the morning.",
    "I'm as mad as hell, and I'm not going to take this anymore!"
  };

  prompts = new ArrayList<TypingPrompt>();
  endTimes = new long[sentences.length];
  for (String sentence : sentences) {
    prompts.add(new TypingPrompt(sentence));
    totalWords += sentence.split(" ").length;
  }
  startTime = System.currentTimeMillis();
}

void draw() {
  background(255);
  drawBorder(borderColor, 10);
  if (!finished) {
    TypingPrompt prompt = prompts.get(currentPrompt);
    prompt.display(width / 2, height / 2);
    if (showWPM) {
      text("Prompt " + currentPrompt + " WPM: " + nf(promptWPM, 0, 2), width / 2, height / 2 + 100);
    }
    text("Remaining prompts: " + (prompts.size() - currentPrompt - 1), width - 150, 30);
  } else {
    float wpm = (totalWords / (totalTime / 60000));
    text("Your average typing speed: " + nf(wpm, 0, 2) + " WPM", width / 2, height / 2);
    text("Click to restart", width / 2, height / 2 + 100);
  }
}

void keyTyped() {
  if (!finished) {
    TypingPrompt prompt = prompts.get(currentPrompt);
    if (prompt.type(key)) {
      endTimes[currentPrompt] = System.currentTimeMillis();
      updateWPM();
      currentPrompt++;
      if (currentPrompt >= prompts.size()) {
        finished = true;
        totalTime = endTimes[prompts.size() - 1] - startTime;
      } else {
        borderColor = color(random(255), random(255), random(255));
        showWPM = true;
      }
    }
  }
}

void updateWPM() {
  long promptTime = endTimes[currentPrompt] - (currentPrompt == 0 ? startTime : endTimes[currentPrompt - 1]);
  promptWPM = (prompts.get(currentPrompt).getWordCount() / (promptTime / 60000.0));
}

void mousePressed() {
  if (finished) {
    currentPrompt = 0;
    finished = false;
    showWPM = false;
    totalTime = 0;
    totalWords = 0;
    promptWPM = 0;
    initGame();
  }
}

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
