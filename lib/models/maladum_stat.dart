class MaladumStat {
  int starting;
  int current;
  int potential;

  MaladumStat({required this.starting, required this.potential})
      : current = starting;

  MaladumStat._restore({
    required this.starting,
    required this.current,
    required this.potential,
  });

  Map<String, dynamic> toJson() => {
        'starting': starting,
        'current': current,
        'potential': potential,
      };

  factory MaladumStat.fromJson(Map<String, dynamic> json) =>
      MaladumStat._restore(
        starting: json['starting'] as int,
        current: json['current'] as int,
        // Accept both 'potential' (new) and 'max' (legacy saves).
        potential: (json['potential'] ?? json['max']) as int,
      );
}
