/*
 * Game.h
 *
 *  Created on: 2023年8月20日
 *      Author: jin
 */

#ifndef GAME_H_
#define GAME_H_

#include "TicTacToe.h"
#include <iostream>
#include <ctime>
using namespace std;

class Game{
public:
	void play();
	void getXMove(char player, int&, int&);
	void getOMove(char player, int&, int&);
private:
	Game(TicTacToe board);
	TicTacToe board;
	int noOfMoves;
};
Game::Game(TicTacToe board){
	board.board;
	noOfMoves = 0;
}
void Game::getOMove(char player, int& x, int& y){
//	if (noOfMoves >= 9)

		srand(time(nullptr));
		int row, col;
		do {
			row = rand() % 3;
			col = rand() % 3;
			cout << endl;
		} while (!board.isValidMove(row, col));
		x = row;
		y = col;

}

void Game::getXMove(char player, int& x, int& y){
//	if (noOfMoves >= 9)

		int row, col;
		do {
			cin >> row >> col;
			cout << endl;
		} while (!board.isValidMove(row - 1, col - 1));
		x = row - 1;
		y = col - 1;

}

void Game::play() {//What is the counterpart of this function in the original code
	// gameStatus() method is the counter part of play()

	int player = 1;

	board.displayBoard();
	int done = 0;
	while (done == 0) {
		char playerSymbol = (player == 1) ? 'X' : 'O';
		cout << "Player " << playerSymbol << " enter move: " << endl;
		int x, y;

		if(player == 1){
			getXMove(playerSymbol, x, y);
		}else{
			getOMove(playerSymbol, x, y);
		}

		board.addMove(x, y, player);
		noOfMoves++;
		board.displayBoard();

		done = board.gameStatus();
		if (done == 1) {
			cout << "Player X wins!" << endl;
		} else if (done == -1) {
			cout << "Player O wins!" << endl;
		} else if (done == 2) {
			cout << "Draw game!" << endl;
		}

		if (player == 1)
			player = -1;
		else
			player = 1;
	}
}

#endif /* GAME_H_ */
