import 'dart:io';
import 'dart:math';

class TicTacToeGame {
  late List<List<String>> board;
  late int size;
  String currentPlayer = 'X';
  bool isAgainstBot = false;
  Random random = Random();

  // Инициализация игрового поля
  void initializeBoard(int boardSize) {
    size = boardSize;
    board = List.generate(size, (_) => List.generate(size, (_) => '.'));
  }

  // Отображение игрового поля
  void displayBoard() {
    print('  ${List.generate(size, (i) => (i + 1).toString()).join(' ')}');
    for (int i = 0; i < size; i++) {
      stdout.write('${i + 1} ');
      for (int j = 0; j < size; j++) {
        stdout.write('${board[i][j]} ');
      }
      print('');
    }
  }

  // Проверка валидности хода
  bool isValidMove(int row, int col) {
    return row >= 0 && row < size && col >= 0 && col < size && board[row][col] == '.';
  }

  // Выполнение хода
  bool makeMove(int row, int col, String player) {
    if (isValidMove(row, col)) {
      board[row][col] = player;
      return true;
    }
    return false;
  }

  // Проверка победы
  bool checkWin(String player) {
    // Проверка строк
    for (int i = 0; i < size; i++) {
      bool rowWin = true;
      for (int j = 0; j < size; j++) {
        if (board[i][j] != player) {
          rowWin = false;
          break;
        }
      }
      if (rowWin) return true;
    }

    // Проверка столбцов
    for (int j = 0; j < size; j++) {
      bool colWin = true;
      for (int i = 0; i < size; i++) {
        if (board[i][j] != player) {
          colWin = false;
          break;
        }
      }
      if (colWin) return true;
    }

    // Проверка главной диагонали
    bool mainDiagWin = true;
    for (int i = 0; i < size; i++) {
      if (board[i][i] != player) {
        mainDiagWin = false;
        break;
      }
    }
    if (mainDiagWin) return true;

    // Проверка побочной диагонали
    bool antiDiagWin = true;
    for (int i = 0; i < size; i++) {
      if (board[i][size - 1 - i] != player) {
        antiDiagWin = false;
        break;
      }
    }
    if (antiDiagWin) return true;

    return false;
  }

  // Проверка на ничью
  bool isBoardFull() {
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        if (board[i][j] == '.') {
          return false;
        }
      }
    }
    return true;
  }

  // Ход бота (простая стратегия)
  void makeBotMove() {
    // Сначала проверяем, может ли бот выиграть
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        if (isValidMove(i, j)) {
          board[i][j] = 'O';
          if (checkWin('O')) {
            return;
          }
          board[i][j] = '.'; // Откатываем ход
        }
      }
    }

    // Затем проверяем, нужно ли заблокировать игрока
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        if (isValidMove(i, j)) {
          board[i][j] = 'X';
          if (checkWin('X')) {
            board[i][j] = 'O';
            return;
          }
          board[i][j] = '.'; // Откатываем ход
        }
      }
    }

    // Иначе делаем случайный ход
    List<List<int>> availableMoves = [];
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        if (isValidMove(i, j)) {
          availableMoves.add([i, j]);
        }
      }
    }

    if (availableMoves.isNotEmpty) {
      var move = availableMoves[random.nextInt(availableMoves.length)];
      board[move[0]][move[1]] = 'O';
    }
  }

  // Получение хода от игрока
  List<int>? getPlayerMove() {
    while (true) {
      stdout.write("${currentPlayer}'s turn. Enter row and column (e.g. 1 2): ");
      String? input = stdin.readLineSync();
      if (input == null) continue;

      List<String> parts = input.trim().split(' ');
      if (parts.length != 2) {
        print("Invalid input format. Please enter row and column separated by space.");
        continue;
      }

      try {
        int row = int.parse(parts[0]) - 1;
        int col = int.parse(parts[1]) - 1;
        
        if (isValidMove(row, col)) {
          return [row, col];
        } else {
          print("Invalid move. Please try again.");
        }
      } catch (e) {
        print("Invalid input. Please enter numbers only.");
      }
    }
  }

  // Выбор случайного начального игрока
  void chooseRandomStartingPlayer() {
    currentPlayer = random.nextBool() ? 'X' : 'O';
    print("${currentPlayer} will start the game!");
  }

  // Основной игровой цикл
  void playGame() {
    while (true) {
      displayBoard();
      
      if (currentPlayer == 'X' || !isAgainstBot) {
        var move = getPlayerMove();
        makeMove(move![0], move[1], currentPlayer);
      } else {
        print("Bot's turn...");
        makeBotMove();
      }

      if (checkWin(currentPlayer)) {
        displayBoard();
        if (currentPlayer == 'O' && isAgainstBot) {
          print("Bot wins!");
        } else {
          print("${currentPlayer} wins!");
        }
        break;
      }

      if (isBoardFull()) {
        displayBoard();
        print("It's a draw!");
        break;
      }

      currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
    }
  }

  // Запуск новой игры
  void startNewGame() {
    // Получение размера поля
    while (true) {
      stdout.write("Enter the size of the board (3-9): ");
      String? input = stdin.readLineSync();
      if (input == null) continue;

      try {
        int boardSize = int.parse(input.trim());
        if (boardSize >= 3 && boardSize <= 9) {
          initializeBoard(boardSize);
          break;
        } else {
          print("Invalid size, please enter again");
        }
      } catch (e) {
        print("Invalid size, please enter again");
      }
    }

    // Выбор режима игры
    while (true) {
      print("\nSelect game mode:");
      print("1. Player vs Player");
      print("2. Player vs Bot");
      stdout.write("Enter your choice (1 or 2): ");
      String? input = stdin.readLineSync();
      
      if (input == "1") {
        isAgainstBot = false;
        break;
      } else if (input == "2") {
        isAgainstBot = true;
        break;
      } else {
        print("Invalid choice. Please enter 1 or 2.");
      }
    }

    // Выбор случайного начального игрока
    chooseRandomStartingPlayer();
    
    // Запуск игры
    playGame();
  }
}

void runTicTacToe() {
  TicTacToeGame game = TicTacToeGame();
  
  while (true) {
    game.startNewGame();
    
    // Спросить, хочет ли игрок сыграть еще раз
    while (true) {
      stdout.write("Do you want to play again? (y/n): ");
      String? input = stdin.readLineSync();
      if (input == null) continue;
      
      String choice = input.trim().toLowerCase();
      if (choice == 'y' || choice == 'yes') {
        break;
      } else if (choice == 'n' || choice == 'no') {
        print("Thanks for playing!");
        return;
      } else {
        print("Please enter 'y' for yes or 'n' for no.");
      }
    }
  }
}
