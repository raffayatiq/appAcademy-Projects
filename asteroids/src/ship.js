const MovingObject = require("./moving_object");
const Util = require("./util");
const Bullet = require("./bullet");
"use strict"
const DEFAULTS = {
	RADIUS: 10,
	COLOR: "goldenrod"
};

function Ship(options) {
	options.vel = [0, 0];
	options.radius = options.radius || DEFAULTS.RADIUS;
	options.color = options.color || DEFAULTS.COLOR;
	MovingObject.call(this, options);
}

Util.inherits(Ship, MovingObject);

Ship.prototype.relocate = function() {
	this.pos = this.game.randomPosition();
}

Ship.prototype.power = function(impulse) {
	this.vel[0] += impulse[0];
	this.vel[1] += impulse[1];
}

Ship.prototype.fireBullet = function() {
	if (this.vel[0] !== 0 || this.vel[1] !== 0) {
		const bulletPos = this.pos.slice();
		const bulletVel = this.vel.slice();
		const bullet = new Bullet({ pos: bulletPos, vel: bulletVel, game: this.game });
		this.game.add(bullet);
	}
}

module.exports = Ship;