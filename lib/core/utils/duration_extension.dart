extension DurationExtension on Duration {
  String format() {
    final hours = inHours;
    final minutes = inMinutes % 60;
    final seconds = inSeconds % 60;

    return '${hours.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}';
  }
  String formatHour() {
    final hours = inHours;
    return hours.toString().padLeft(2, "0");
  }
  String formatMin() {
    final minutes = inMinutes % 60;
    return minutes.toString().padLeft(2, "0");
  }
}
