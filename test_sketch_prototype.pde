Table table;
ArrayList<Play> plays = new ArrayList<Play>();
StringList days = new StringList();
StringList genres = new StringList();

int boxSize = 18;
int margin = 60;

void setup() {
  size(1000, 600);
  colorMode(HSB, 360, 100, 100);
  table = loadTable("music_history_data.csv", "header");

  // first pass: collect the unique days and genres
  for (TableRow row : table.rows()) {
    String d = row.getString("date");
    String g = row.getString("genre");
    if (!days.hasValue(d)) days.append(d);
    if (!genres.hasValue(g)) genres.append(g);
  }

  // second pass: work out where each square goes
  int[] counts = new int[days.size()];
  float colW = (width - 2 * margin) / (float) days.size();
  for (TableRow row : table.rows()) {
    int di = days.index(row.getString("date"));
    float x = margin + di * colW;
    float y = height - margin - (counts[di] + 1) * boxSize;
    counts[di]++;
    plays.add(new Play(x, y, row.getString("title"), row.getString("genre")));
  }
  println(plays.size() + " plays loaded");
  println("Top genre: " + topGenre());
}

void draw() {
  background(0, 0, 10);
  Play hovered = null;
  for (Play p : plays) {
    p.display();
    if (p.isHovered()) hovered = p;
  }

  // day labels
  fill(0, 0, 80);
  textSize(10);
  textAlign(LEFT);
  float colW = (width - 2 * margin) / (float) days.size();
  for (int i = 0; i < days.size(); i++) {
    text(days.get(i), margin + i * colW, height - margin + 15);
  }

  // legend
  for (int i = 0; i < genres.size(); i++) {
    fill(i * 360 / genres.size(), 70, 95);
    rect(margin, 20 + i * 18, 12, 12);
    fill(0, 0, 90);
    text(genres.get(i), margin + 20, 30 + i * 18);
  }

  // hover info
  if (hovered != null) {
    fill(0, 0, 100);
    textSize(14);
    textAlign(CENTER);
    text(hovered.title + " (" + hovered.genre + ")", width / 2, height - 20);
  }
}

// Method that returns a value (use this for the check-in)
String topGenre() {
  int[] counts = new int[genres.size()];
  for (Play p : plays) counts[genres.index(p.genre)]++;
  int best = 0;
  for (int i = 1; i < counts.length; i++) {
    if (counts[i] > counts[best]) best = i;
  }
  return genres.get(best);
}

class Play {
  float x, y;
  String title, genre;

  Play(float x, float y, String title, String genre) {
    this.x = x; this.y = y; this.title = title; this.genre = genre;
  }

  void display() {
    noStroke();
    fill(genres.index(genre) * 360 / genres.size(), 70, 95);
    rect(x, y, boxSize - 2, boxSize - 2);
  }

  boolean isHovered() {
    return mouseX > x && mouseX < x + boxSize - 2 &&
           mouseY > y && mouseY < y + boxSize - 2;
  }
}
