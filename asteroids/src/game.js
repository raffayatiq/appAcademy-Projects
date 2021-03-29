const Asteroid = require("./asteroid");
const Ship = require("./ship");
const Bullet = require("./bullet");

Array.prototype.remove = function(element) {
	const index = this.indexOf(element);
	if (index !== -1) {
		this.splice(index, 1);
	}
};

function Game() {
	this.DIM_X = 1000;
	this.DIM_Y = 650;
	this.NUM_ASTEROIDS = 20;
	this.asteroids = [];
	this.bullets = [];
	this.addAsteroids();
	this.ship = new Ship({ pos: this.randomPosition(), game: this })
}

Game.prototype.addAsteroids = function() {
	for (let i = 0; i < this.NUM_ASTEROIDS; i++) {
		const pos = this.randomPosition();
		const asteroid = new Asteroid({ pos: pos, game: this });
		this.asteroids.push(asteroid);
	}
};

Game.prototype.randomPosition = function() {
	const pos_0 = Math.floor(Math.random() * this.DIM_X) + 0;
	const pos_1 = Math.floor(Math.random() * this.DIM_Y) + 0;
	return [pos_0, pos_1];
};

Game.prototype.draw = function(ctx) {
	ctx.clearRect(0, 0, this.DIM_X, this.DIM_Y);
	this.allObjects().forEach(object => object.draw(ctx));
};

Game.prototype.moveObjects = function(delta) {
	this.allObjects().forEach(object => object.move(delta));
};

Game.prototype.wrap = function(pos) {
	if (pos[0] < 0) {
		pos[0] += this.DIM_X;
	} else if (pos[0] > this.DIM_X) {
		pos[0] -= this.DIM_X;
	}

	if (pos[1] < 0) {
		pos[1] += this.DIM_Y;
	} else if (pos[1] > this.DIM_Y) {
		pos[1] -= this.DIM_Y;
	}
};

Game.prototype.checkCollisions = function() {
	for (let i = 0; i < this.allObjects().length; i++) {
		for (let j = 0; j < this.allObjects().length; j++) {
			if (this.allObjects()[i] === this.allObjects()[j]) continue;
			if (this.allObjects()[i].isCollideWith(this.allObjects()[j])) {
				this.allObjects()[i].collideWith(this.allObjects()[j]);
			}
		}
	}
}

Game.prototype.step = function(delta) {
	this.moveObjects(delta);
	this.checkCollisions();
}

Game.prototype.remove = function(obj) {
	if (obj instanceof Asteroid) {
		this.asteroids.remove(obj);
		this.NUM_ASTEROIDS--;
	} else if (obj instanceof Bullet) {
		this.bullets.remove(obj);
	}
}

Game.prototype.allObjects = function() {
	return [].concat(this.asteroids, this.ship, this.bullets);
}

Game.prototype.add = function (obj) {
	if (obj instanceof Asteroid) {
		this.asteroids.push(obj);
	} else if (obj instanceof Bullet) {
		this.bullets.push(obj);
	}
}

Game.prototype.isOutOfBounds = function(pos) {
	return ((pos[0] < 0 || pos[0] > this.DIM_X) ||
		(pos[1] < 0 || pos[1] > this.DIM_Y));
}

module.exports = Game;