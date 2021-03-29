const Game = require("./game");

function GameView(ctx) {
	this.ctx = ctx;
	this.game = new Game();
	this.lastTime = 0;
}

GameView.prototype.start = function() {
	this.bindKeyHandlers();
	requestAnimationFrame(this.animate.bind(this));
};

GameView.prototype.animate = function(time) {
	const delta = time - this.lastTime;
	this.game.step(delta);
	this.game.draw(this.ctx);
	this.lastTime = time;
	requestAnimationFrame(this.animate.bind(this));
}

GameView.prototype.bindKeyHandlers = function() {
	key('w', () => { this.game.ship.power([0, -1]) });
	key('a', () => { this.game.ship.power([-1, 0]) });
	key('d', () => { this.game.ship.power([1, 0]) });
	key('s', () => { this.game.ship.power([0, 1]) });
	key('space', () => { this.game.ship.fireBullet() });
}

module.exports = GameView;