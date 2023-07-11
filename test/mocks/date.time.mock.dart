import 'dart:math';

mixin DateTimeMock {
  static String getNextDay() {
    DateTime now = DateTime.now();
    DateTime nextDay = now.add(const Duration(days: 1));

    // Gerando uma hora aleatória entre 0 e 23
    int randomHour = Random().nextInt(24);
    // Gerando um minuto aleatório entre 0 e 59
    int randomMinute = Random().nextInt(60);

    // Construindo a data e hora final
    DateTime nextDayWithRandomTime = DateTime(
      nextDay.year,
      nextDay.month,
      nextDay.day,
      randomHour,
      randomMinute,
    );

    // Formatando a data no formato desejado
    String formattedDate = "${nextDayWithRandomTime.day.toString().padLeft(2, '0')}/"
        "${nextDayWithRandomTime.month.toString().padLeft(2, '0')}/"
        "${nextDayWithRandomTime.year.toString()} "
        "${nextDayWithRandomTime.hour.toString().padLeft(2, '0')}:"
        "${nextDayWithRandomTime.minute.toString().padLeft(2, '0')}";

    return formattedDate;
  }

  static bool isValid(String formattedDate) {
    DateTime now = DateTime.now();
    DateTime tomorrow = now.add(const Duration(days: 1));

    List<String> dateParts = formattedDate.split(' ');
    String date = dateParts[0];
    String time = dateParts[1];

    List<String> datePartsFormatted = date.split('/');
    int day = int.parse(datePartsFormatted[0]);
    int month = int.parse(datePartsFormatted[1]);
    int year = int.parse(datePartsFormatted[2]);

    List<String> timeParts = time.split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    DateTime dateTime = DateTime(year, month, day, hour, minute);

    if (dateTime.day == tomorrow.day &&
        dateTime.month == tomorrow.month &&
        dateTime.year == tomorrow.year) {
      if (dateTime.hour >= 0 &&
          dateTime.hour <= 23 &&
          dateTime.minute >= 0 &&
          dateTime.minute <= 59) {
        return true;
      }
    }

    return false;
  }
}
