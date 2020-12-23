// DON'T TOUCH THIS CODE
if (typeof window === 'undefined'){
  var Piece = require("./piece");
}
// DON'T TOUCH THIS CODE

Array.create2DArray = function (arrayLength, subArrayLength) {
	const array = new Array(arrayLength);

	for (let i = 0; i < arrayLength; i++) {
		array[i] = new Array(subArrayLength);
	}

	return array;
}

/**
 * Returns a 2D array (8 by 8) with two black pieces at [3, 4] and [4, 3]
 * and two white pieces at [3, 3] and [4, 4]
 */

function _makeGrid () {
	grid = Array.create2DArray(8, 8);
	grid[3][4] = new Piece("black");
	grid[4][3] = new Piece("black");
	grid[3][3] = new Piece("white");
	grid[4][4] = new Piece("white");
	return grid;
}	

/**
 * Constructs a Board with a starting grid set up.
 */
function Board () {
  this.grid = _makeGrid();
}

Board.DIRS = [
  [ 0,  1], [ 1,  1], [ 1,  0],
  [ 1, -1], [ 0, -1], [-1, -1],
  [-1,  0], [-1,  1]
];

/**
 * Checks if a given position is on the Board.
 */
Board.prototype.isValidPos = function (pos) {
	if (pos[0] < 0 || pos[1] < 0) {
		return false;
	} else if (pos[0] > 7 || pos[1] > 7) {
		return false;
	} else {
		return true;
	}
};

/**
 * Returns the piece at a given [x, y] position,
 * throwing an Error if the position is invalid.
 */
Board.prototype.getPiece = function (pos) {
	if (this.isValidPos(pos)) {
		return this.grid[pos[0]][pos[1]];
	} else {
		throw Error("Not valid pos!");
	}
};

/**
 * Checks if the piece at a given position
 * matches a given color.
 */
Board.prototype.isMine = function (pos, color) {
	const piece = this.getPiece(pos);
	if (piece === undefined) return false;
	return (piece.color === color);
};

/**
 * Checks if a given position has a piece on it.
 */
Board.prototype.isOccupied = function (pos) {
	return (this.getPiece(pos) instanceof Piece);
};

/**
 * Recursively follows a direction away from a starting position, adding each
 * piece of the opposite color until hitting another piece of the current color.
 * It then returns an array of all pieces between the starting position and
 * ending position.
 *
 * Returns an empty array if it reaches the end of the board before finding another piece
 * of the same color.
 *
 * Returns empty array if it hits an empty position.
 *
 * Returns empty array if no pieces of the opposite color are found.
 */
Board.prototype._positionsToFlip = function(pos, color, dir){
	if (!this.isValidPos(pos)) return [];

	const nextPos = [pos[0] + dir[0], pos[1] + dir[1]];
	
	if (!this.isValidPos(nextPos)) return [];	
	
	const nextPiece = this.grid[nextPos[0]][nextPos[1]];
	
	if (nextPiece === undefined || nextPiece.color === color) return [];
	
	return [nextPos].concat(this._positionsToFlip(nextPos, color, dir))
};

/**
 * Checks that a position is not already occupied and that the color
 * taking the position will result in some pieces of the opposite
 * color being flipped.
 */
Board.prototype.validMove = function (pos, color) {
	if (this.isOccupied(pos)) return false;
	
	for (let i = 0; i < Board.DIRS.length; i++) {
		let dir = Board.DIRS[i];
		let positionsToFlip = this._positionsToFlip(pos, color, dir);

		// let nextPieceInCurrentDirection;
		if (positionsToFlip.length !== 0) {
			let nextPieceInCurrentDirectionPos = 
			[positionsToFlip[positionsToFlip.length - 1][0] + dir[0],
			positionsToFlip[positionsToFlip.length - 1][1] + dir[1]];
			
			let nextPieceInCurrentDirection = this.getPiece(nextPieceInCurrentDirectionPos);

			if (nextPieceInCurrentDirection) {
				if (nextPieceInCurrentDirection.color === color) return true;
			}
		}
	}
	return false;
}

/**
 * Adds a new piece of the given color to the given position, flipping the
 * color of any pieces that are eligible for flipping.
 *
 * Throws an error if the position represents an invalid move.
 */
Board.prototype.placePiece = function (pos, color) {
	if (!this.validMove(pos, color)) throw Error("Invalid move!");
	this.grid[pos[0]][pos[1]] = new Piece(color);

	Board.DIRS.forEach(dir => {
		let positionsToFlip = this._positionsToFlip(pos, color, dir);

		if (positionsToFlip.length !== 0) {
			let nextPieceInCurrentDirectionPos = 
			[positionsToFlip[positionsToFlip.length - 1][0] + dir[0],
			positionsToFlip[positionsToFlip.length - 1][1] + dir[1]];
			let nextPieceInCurrentDirection = this.getPiece(nextPieceInCurrentDirectionPos);

			if (nextPieceInCurrentDirection.color === color) {
				positionsToFlip.forEach(pos => {
					let piece = this.getPiece(pos);
					piece.flip();
				});
			}	
		}
	})
};

/**
 * Produces an array of all valid positions on
 * the Board for a given color.
 */
Board.prototype.validMoves = function (color) {
	let validMoves = [];
	for (let i = 0; i < this.grid.length; i++)	 {
		for (let j = 0; j < this.grid[i].length; j++) {
			let pos = [i, j];
			if (this.validMove(pos, color)) validMoves.push(pos);
		}
	}
	return validMoves;
};

/**
 * Checks if there are any valid moves for the given color.
 */
Board.prototype.hasMove = function (color) {
	return this.validMoves(color).length !== 0;
};



/**
 * Checks if both the white player and
 * the black player are out of moves.
 */
Board.prototype.isOver = function () {
	return (this.validMoves('black').length === 0
		&& this.validMoves('white').length === 0)
};




/**
 * Prints a string representation of the Board to the console.
 */
Board.prototype.print = function () {
};


// DON'T TOUCH THIS CODE
if (typeof window === 'undefined'){
  module.exports = Board;
}
// DON'T TOUCH THIS CODE