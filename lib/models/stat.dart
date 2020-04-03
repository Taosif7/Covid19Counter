class model_stat {
  final String country,
      new_cases,
      active_cases,
      critical_cases,
      recovered_cases,
      total_cases,
      new_deaths,
      total_deaths,
      stat_day,
      stat_time;

  model_stat(
    this.country,
    this.new_cases,
    this.active_cases,
    this.critical_cases,
    this.recovered_cases,
    this.total_cases,
    this.new_deaths,
    this.total_deaths,
    this.stat_day,
    this.stat_time,
  );

  factory model_stat.fromJson(dynamic data) {
    return new model_stat(
      data["country"].toString(),
      data["cases"]["new"].toString(),
      data["cases"]["active"].toString(),
      data["cases"]["critical"].toString(),
      data["cases"]["recovered"].toString(),
      data["cases"]["total"].toString(),
      data["deaths"]["new"].toString(),
      data["deaths"]["total"].toString(),
      data["day"].toString(),
      data["time"].toString(),
    );
  }
}
