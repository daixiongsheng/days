import 'dart:math';

int getRandom({int start = 0, int end = 100}) {
  return start +
      Random(DateTime.now().microsecondsSinceEpoch).nextInt(end - start);
}
