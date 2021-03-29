const MovingObject = require("./moving_object");
const Util = require("./util");

const DEFAULTS = {
	RADIUS: 2,
	COLOR: "red",
	SPEED: 10
}

function Bullet(options) {
	options.vel = [
		Math.sign(options.vel[0]) * DEFAULTS.SPEED, 
		Math.sign(options.vel[1]) * DEFAULTS.SPEED
	];
	options.radius = DEFAULTS.RADIUS;
	options.color = DEFAULTS.COLOR;
	MovingObject.call(this, options);
}

Util.inherits(Bullet, MovingObject);

Bullet.prototype.isWrappable = false;

module.exports = Bullet;