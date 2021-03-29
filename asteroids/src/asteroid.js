const Util = require("./util");
const MovingObject = require("./moving_object");
const Ship = require("./ship");

const DEFAULTS = {
	COLOR: "grey",
	RADIUS: 20,
	SPEED: 2
};

function Asteroid(options) {
	options.vel = options.vel || Util.randomVec(DEFAULTS.SPEED);
	options.radius = options.radius || DEFAULTS.RADIUS;
	options.color = options.color || DEFAULTS.COLOR;
	MovingObject.call(this, options);
}

Util.inherits(Asteroid, MovingObject);

Asteroid.prototype.collideWith = function(otherObject) {
	if (otherObject instanceof Ship) {
		otherObject.relocate();
		otherObject.vel = [0, 0];
	} else {
		this.game.remove(otherObject);
		this.game.remove(this);
	}
}

module.exports = Asteroid;