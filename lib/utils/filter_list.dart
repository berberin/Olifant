dynamic getNewElement(List<dynamic> oldList, List<dynamic> newList) {
  for (int i = newList.length - 1; i >= 0; i--) {
    if (!oldList.contains(newList[i])) {
      return newList[i];
    }
  }
}
