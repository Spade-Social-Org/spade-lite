void main() {
  final list = <dynamic>[
    1,
    [4],
    [1, 2],
    3,
    5
  ];
  list.firstWhere((element) => element is List).add(12);
}
