class MaladumStat {
  final int starting;
  int current;
  int max;

  MaladumStat({required this.starting, required this.max})
      : current = starting;

  MaladumStat._restore({
    required this.starting,
    required this.current,
    required this.max,
  });

  Map<String, dynamic> toJson() => {
        'starting': starting,
        'current': current,
        'max': max,
      };

  factory MaladumStat.fromJson(Map<String, dynamic> json) =>
      MaladumStat._restore(
        starting: json['starting'] as int,
        current: json['current'] as int,
        max: json['max'] as int,
      );
}
