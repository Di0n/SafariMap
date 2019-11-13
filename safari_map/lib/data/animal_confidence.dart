class AnimalConfidence {
  String animal;
  int confidence;

  AnimalConfidence({this.animal, this.confidence});

  @override
  String toString() {
    return "$animal: ${confidence.toString()}";
  }
}