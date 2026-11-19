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


