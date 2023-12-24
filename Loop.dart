List<int> winningNumbers = [12, 6, 34, 22, 41, 9];

void main() {
  List<int> ticket1 = [45, 2, 9, 18, 12, 33];
  List<int> ticket2 = [41, 17, 26, 32, 7, 35];

  checkNumbers(ticket2);
  //checkNumbers(ticket2);
}

int matches = 0;
void checkNumbers(List myNumbers) {
  for (int number in myNumbers) {
    for (int winningNum in winningNumbers) {
      if (number == winningNum) {
        matches++;
      }
    }
  }
  print('You have ${matches} matching numbers');
}
