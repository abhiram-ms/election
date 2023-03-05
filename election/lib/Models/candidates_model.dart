class Candidates {
  final String name;
  final int votes;

  Candidates({required this.name, required this.votes});

  @override
  bool operator ==(covariant Candidates other) {
    if (identical(this, other)) return true;
    return
      other.name == name &&
          other.votes == votes ;
  }

  @override
  int get hashCode {
    return name.hashCode ^
    votes.hashCode;
  }

}