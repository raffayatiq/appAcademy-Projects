/*
 * ATTENTION: The "eval" devtool has been used (maybe by default in mode: "development").
 * This devtool is not neither made for production nor for readable output files.
 * It uses "eval()" calls to create a separate source file in the browser devtools.
 * If you are trying to read the output file, select a different devtool (https://webpack.js.org/configuration/devtool/)
 * or disable the default devtool with "devtool: false".
 * If you are looking for production-ready output files, see mode: "production" (https://webpack.js.org/configuration/mode/).
 */
/******/ (() => { // webpackBootstrap
/******/ 	var __webpack_modules__ = ({

/***/ "./src/asteroid.js":
/*!*************************!*\
  !*** ./src/asteroid.js ***!
  \*************************/
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

eval("const Util = __webpack_require__(/*! ./util */ \"./src/util.js\");\nconst MovingObject = __webpack_require__(/*! ./moving_object */ \"./src/moving_object.js\");\nconst Ship = __webpack_require__(/*! ./ship */ \"./src/ship.js\");\n\nconst DEFAULTS = {\n\tCOLOR: \"grey\",\n\tRADIUS: 20,\n\tSPEED: 2\n};\n\nfunction Asteroid(options) {\n\toptions.vel = options.vel || Util.randomVec(DEFAULTS.SPEED);\n\toptions.radius = options.radius || DEFAULTS.RADIUS;\n\toptions.color = options.color || DEFAULTS.COLOR;\n\tMovingObject.call(this, options);\n}\n\nUtil.inherits(Asteroid, MovingObject);\n\nAsteroid.prototype.collideWith = function(otherObject) {\n\tif (otherObject instanceof Ship) {\n\t\totherObject.relocate();\n\t\totherObject.vel = [0, 0];\n\t} else {\n\t\tthis.game.remove(otherObject);\n\t\tthis.game.remove(this);\n\t}\n}\n\nmodule.exports = Asteroid;\n\n//# sourceURL=webpack:///./src/asteroid.js?");

/***/ }),

/***/ "./src/bullet.js":
/*!***********************!*\
  !*** ./src/bullet.js ***!
  \***********************/
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

eval("const MovingObject = __webpack_require__(/*! ./moving_object */ \"./src/moving_object.js\");\nconst Util = __webpack_require__(/*! ./util */ \"./src/util.js\");\n\nconst DEFAULTS = {\n\tRADIUS: 2,\n\tCOLOR: \"red\",\n\tSPEED: 10\n}\n\nfunction Bullet(options) {\n\toptions.vel = [\n\t\tMath.sign(options.vel[0]) * DEFAULTS.SPEED, \n\t\tMath.sign(options.vel[1]) * DEFAULTS.SPEED\n\t];\n\toptions.radius = DEFAULTS.RADIUS;\n\toptions.color = DEFAULTS.COLOR;\n\tMovingObject.call(this, options);\n}\n\nUtil.inherits(Bullet, MovingObject);\n\nBullet.prototype.isWrappable = false;\n\nmodule.exports = Bullet;\n\n//# sourceURL=webpack:///./src/bullet.js?");

/***/ }),

/***/ "./src/game.js":
/*!*********************!*\
  !*** ./src/game.js ***!
  \*********************/
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

eval("const Asteroid = __webpack_require__(/*! ./asteroid */ \"./src/asteroid.js\");\nconst Ship = __webpack_require__(/*! ./ship */ \"./src/ship.js\");\nconst Bullet = __webpack_require__(/*! ./bullet */ \"./src/bullet.js\");\n\nArray.prototype.remove = function(element) {\n\tconst index = this.indexOf(element);\n\tif (index !== -1) {\n\t\tthis.splice(index, 1);\n\t}\n};\n\nfunction Game() {\n\tthis.DIM_X = 1000;\n\tthis.DIM_Y = 650;\n\tthis.NUM_ASTEROIDS = 20;\n\tthis.asteroids = [];\n\tthis.bullets = [];\n\tthis.addAsteroids();\n\tthis.ship = new Ship({ pos: this.randomPosition(), game: this })\n}\n\nGame.prototype.addAsteroids = function() {\n\tfor (let i = 0; i < this.NUM_ASTEROIDS; i++) {\n\t\tconst pos = this.randomPosition();\n\t\tconst asteroid = new Asteroid({ pos: pos, game: this });\n\t\tthis.asteroids.push(asteroid);\n\t}\n};\n\nGame.prototype.randomPosition = function() {\n\tconst pos_0 = Math.floor(Math.random() * this.DIM_X) + 0;\n\tconst pos_1 = Math.floor(Math.random() * this.DIM_Y) + 0;\n\treturn [pos_0, pos_1];\n};\n\nGame.prototype.draw = function(ctx) {\n\tctx.clearRect(0, 0, this.DIM_X, this.DIM_Y);\n\tthis.allObjects().forEach(object => object.draw(ctx));\n};\n\nGame.prototype.moveObjects = function(delta) {\n\tthis.allObjects().forEach(object => object.move(delta));\n};\n\nGame.prototype.wrap = function(pos) {\n\tif (pos[0] < 0) {\n\t\tpos[0] += this.DIM_X;\n\t} else if (pos[0] > this.DIM_X) {\n\t\tpos[0] -= this.DIM_X;\n\t}\n\n\tif (pos[1] < 0) {\n\t\tpos[1] += this.DIM_Y;\n\t} else if (pos[1] > this.DIM_Y) {\n\t\tpos[1] -= this.DIM_Y;\n\t}\n};\n\nGame.prototype.checkCollisions = function() {\n\tfor (let i = 0; i < this.allObjects().length; i++) {\n\t\tfor (let j = 0; j < this.allObjects().length; j++) {\n\t\t\tif (this.allObjects()[i] === this.allObjects()[j]) continue;\n\t\t\tif (this.allObjects()[i].isCollideWith(this.allObjects()[j])) {\n\t\t\t\tthis.allObjects()[i].collideWith(this.allObjects()[j]);\n\t\t\t}\n\t\t}\n\t}\n}\n\nGame.prototype.step = function(delta) {\n\tthis.moveObjects(delta);\n\tthis.checkCollisions();\n}\n\nGame.prototype.remove = function(obj) {\n\tif (obj instanceof Asteroid) {\n\t\tthis.asteroids.remove(obj);\n\t\tthis.NUM_ASTEROIDS--;\n\t} else if (obj instanceof Bullet) {\n\t\tthis.bullets.remove(obj);\n\t}\n}\n\nGame.prototype.allObjects = function() {\n\treturn [].concat(this.asteroids, this.ship, this.bullets);\n}\n\nGame.prototype.add = function (obj) {\n\tif (obj instanceof Asteroid) {\n\t\tthis.asteroids.push(obj);\n\t} else if (obj instanceof Bullet) {\n\t\tthis.bullets.push(obj);\n\t}\n}\n\nGame.prototype.isOutOfBounds = function(pos) {\n\treturn ((pos[0] < 0 || pos[0] > this.DIM_X) ||\n\t\t(pos[1] < 0 || pos[1] > this.DIM_Y));\n}\n\nmodule.exports = Game;\n\n//# sourceURL=webpack:///./src/game.js?");

/***/ }),

/***/ "./src/game_view.js":
/*!**************************!*\
  !*** ./src/game_view.js ***!
  \**************************/
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

eval("const Game = __webpack_require__(/*! ./game */ \"./src/game.js\");\n\nfunction GameView(ctx) {\n\tthis.ctx = ctx;\n\tthis.game = new Game();\n\tthis.lastTime = 0;\n}\n\nGameView.prototype.start = function() {\n\tthis.bindKeyHandlers();\n\trequestAnimationFrame(this.animate.bind(this));\n};\n\nGameView.prototype.animate = function(time) {\n\tconst delta = time - this.lastTime;\n\tthis.game.step(delta);\n\tthis.game.draw(this.ctx);\n\tthis.lastTime = time;\n\trequestAnimationFrame(this.animate.bind(this));\n}\n\nGameView.prototype.bindKeyHandlers = function() {\n\tkey('w', () => { this.game.ship.power([0, -1]) });\n\tkey('a', () => { this.game.ship.power([-1, 0]) });\n\tkey('d', () => { this.game.ship.power([1, 0]) });\n\tkey('s', () => { this.game.ship.power([0, 1]) });\n\tkey('space', () => { this.game.ship.fireBullet() });\n}\n\nmodule.exports = GameView;\n\n//# sourceURL=webpack:///./src/game_view.js?");

/***/ }),

/***/ "./src/moving_object.js":
/*!******************************!*\
  !*** ./src/moving_object.js ***!
  \******************************/
/***/ ((module) => {

eval("function MovingObject(options) {\n\tthis.pos = options.pos;\n\tthis.vel = options.vel;\n\tthis.radius = options.radius;\n\tthis.color = options.color;\n\tthis.game = options.game;\n}\n\nMovingObject.prototype.draw = function(ctx) {\n\tctx.beginPath();\n\tctx.arc(\n\t\tthis.pos[0],\n\t\tthis.pos[1],\n\t\tthis.radius,\n\t\t0,\n\t\t2 * Math.PI\n\t);\n\tctx.fillStyle = this.color;\n\tctx.fill();\n};\n\nMovingObject.prototype.move = function(delta) {\n\tthis.pos[0] += ((this.vel[0] * delta) / 20);\n\tthis.pos[1] += ((this.vel[1] * delta) / 20);\n\tif (this.game.isOutOfBounds(this.pos)) {\n\t\tif (this.isWrappable) {\n\t\t\tthis.game.wrap(this.pos);\n\t\t} else {\n\t\t\tthis.game.remove(this);\n\t\t}\n\t}\n};\n\nMovingObject.prototype.isCollideWith = function(otherObject) {\n\tconst maxPossibleDistance = (this.radius) + (otherObject.radius);\n\tconst distanceBetweenCentrePoints = Math.sqrt(\n\t\t\t((this.pos[0] - otherObject.pos[0]) ** 2) +\n\t\t\t((this.pos[1] - otherObject.pos[1]) ** 2)\n\t\t);\n\treturn (distanceBetweenCentrePoints < maxPossibleDistance);\n};\n\nMovingObject.prototype.collideWith = function(otherObject) {\n}\n\nMovingObject.prototype.isWrappable = true;\n\nmodule.exports = MovingObject;\n\n//# sourceURL=webpack:///./src/moving_object.js?");

/***/ }),

/***/ "./src/ship.js":
/*!*********************!*\
  !*** ./src/ship.js ***!
  \*********************/
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

eval("const MovingObject = __webpack_require__(/*! ./moving_object */ \"./src/moving_object.js\");\nconst Util = __webpack_require__(/*! ./util */ \"./src/util.js\");\nconst Bullet = __webpack_require__(/*! ./bullet */ \"./src/bullet.js\");\n\"use strict\"\nconst DEFAULTS = {\n\tRADIUS: 10,\n\tCOLOR: \"goldenrod\"\n};\n\nfunction Ship(options) {\n\toptions.vel = [0, 0];\n\toptions.radius = options.radius || DEFAULTS.RADIUS;\n\toptions.color = options.color || DEFAULTS.COLOR;\n\tMovingObject.call(this, options);\n}\n\nUtil.inherits(Ship, MovingObject);\n\nShip.prototype.relocate = function() {\n\tthis.pos = this.game.randomPosition();\n}\n\nShip.prototype.power = function(impulse) {\n\tthis.vel[0] += impulse[0];\n\tthis.vel[1] += impulse[1];\n}\n\nShip.prototype.fireBullet = function() {\n\tif (this.vel[0] !== 0 || this.vel[1] !== 0) {\n\t\tconst bulletPos = this.pos.slice();\n\t\tconst bulletVel = this.vel.slice();\n\t\tconst bullet = new Bullet({ pos: bulletPos, vel: bulletVel, game: this.game });\n\t\tthis.game.add(bullet);\n\t}\n}\n\nmodule.exports = Ship;\n\n//# sourceURL=webpack:///./src/ship.js?");

/***/ }),

/***/ "./src/util.js":
/*!*********************!*\
  !*** ./src/util.js ***!
  \*********************/
/***/ ((module) => {

eval("const Util = {\n\tinherits: function inherits(childClass, parentClass) {\n\t\tchildClass.prototype = Object.create(parentClass.prototype);\n\t\tchildClass.prototype.constructor = childClass;\n\t},\n\n\trandomVec: function randomVec(length) {\n    \tconst deg = 2 * Math.PI * Math.random();\n    \treturn Util.scale([Math.sin(deg), Math.cos(deg)], length);\n  \t},\n  \t\n\t// Scale the length of a vector by the given amount.\n\tscale: function scale(vec, m) {\n\t    return [vec[0] * m, vec[1] * m];\n\t}\n}\n\nmodule.exports = Util;\n\n//# sourceURL=webpack:///./src/util.js?");

/***/ })

/******/ 	});
/************************************************************************/
/******/ 	// The module cache
/******/ 	var __webpack_module_cache__ = {};
/******/ 	
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/ 		// Check if module is in cache
/******/ 		if(__webpack_module_cache__[moduleId]) {
/******/ 			return __webpack_module_cache__[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = __webpack_module_cache__[moduleId] = {
/******/ 			// no module.id needed
/******/ 			// no module.loaded needed
/******/ 			exports: {}
/******/ 		};
/******/ 	
/******/ 		// Execute the module function
/******/ 		__webpack_modules__[moduleId](module, module.exports, __webpack_require__);
/******/ 	
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/ 	
/************************************************************************/
(() => {
/*!**********************!*\
  !*** ./src/index.js ***!
  \**********************/
eval("const MovingObject = __webpack_require__ (/*! ./moving_object */ \"./src/moving_object.js\");\nconst Asteroid = __webpack_require__ (/*! ./asteroid */ \"./src/asteroid.js\");\nconst Game = __webpack_require__ (/*! ./game */ \"./src/game.js\");\nconst GameView = __webpack_require__ (/*! ./game_view */ \"./src/game_view.js\");\n\nwindow.MovingObject = MovingObject;\nwindow.Asteroid = Asteroid;\nwindow.Game = Game;\nwindow.GameView = GameView;\n\ndocument.addEventListener(\"DOMContentLoaded\", () => {\n\tconst canvas = document.getElementById(\"game-canvas\");\n\tconst ctx = canvas.getContext(\"2d\");\n\tconst gameview = new GameView(ctx);\n\tgameview.start();\n})\n\n//# sourceURL=webpack:///./src/index.js?");
})();

/******/ })()
;