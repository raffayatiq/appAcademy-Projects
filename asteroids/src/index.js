const MovingObject = require ("./moving_object");
const Asteroid = require ("./asteroid");
const Game = require ("./game");
const GameView = require ("./game_view");

window.MovingObject = MovingObject;
window.Asteroid = Asteroid;
window.Game = Game;
window.GameView = GameView;

document.addEventListener("DOMContentLoaded", () => {
	const canvas = document.getElementById("game-canvas");
	const ctx = canvas.getContext("2d");
	const gameview = new GameView(ctx);
	gameview.start();
})