import 'package:xo_app/xo_app.dart';
import 'package:test/test.dart';

void main() {
  group('TicTacToe Game Tests', () {
    late TicTacToeGame game;

    setUp(() {
      game = TicTacToeGame();
      game.initializeBoard(3);
    });

    test('Board initialization', () {
      expect(game.size, equals(3));
      expect(game.board.length, equals(3));
      expect(game.board[0].length, equals(3));
      expect(game.board[0][0], equals('.'));
    });

    test('Valid move check', () {
      expect(game.isValidMove(0, 0), isTrue);
      expect(game.isValidMove(-1, 0), isFalse);
      expect(game.isValidMove(0, 3), isFalse);
    });

    test('Make move', () {
      expect(game.makeMove(0, 0, 'X'), isTrue);
      expect(game.board[0][0], equals('X'));
      expect(game.makeMove(0, 0, 'O'), isFalse); // Already occupied
    });

    test('Check win - row', () {
      game.makeMove(0, 0, 'X');
      game.makeMove(0, 1, 'X');
      game.makeMove(0, 2, 'X');
      expect(game.checkWin('X'), isTrue);
    });

    test('Check win - column', () {
      game.makeMove(0, 0, 'X');
      game.makeMove(1, 0, 'X');
      game.makeMove(2, 0, 'X');
      expect(game.checkWin('X'), isTrue);
    });

    test('Check win - main diagonal', () {
      game.makeMove(0, 0, 'X');
      game.makeMove(1, 1, 'X');
      game.makeMove(2, 2, 'X');
      expect(game.checkWin('X'), isTrue);
    });

    test('Check win - anti diagonal', () {
      game.makeMove(0, 2, 'X');
      game.makeMove(1, 1, 'X');
      game.makeMove(2, 0, 'X');
      expect(game.checkWin('X'), isTrue);
    });

    test('Check draw', () {
      // Fill board without winner
      game.board = [
        ['X', 'O', 'X'],
        ['O', 'O', 'X'],
        ['O', 'X', 'O']
      ];
      expect(game.isBoardFull(), isTrue);
      expect(game.checkWin('X'), isFalse);
      expect(game.checkWin('O'), isFalse);
    });
  });
}
