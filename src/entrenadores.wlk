import wollok.game.*
import wollokmones.*

object jugador {

	//Su wollokmon
	var property wollokmon = pepita
	var property position = game.center()
	
	//De carga del jugador
	method image() {
		return "jugador.png"
	}
	
	//De movimiento del jugador
	method irASiSeMantieneEnLaPantalla(nuevaPosicion) {
		if (self.estaDentroDeLaPantalla(nuevaPosicion)) {
			self.irA(nuevaPosicion)
		}
	}
	
	method irA(nuevaPosicion){
		position = nuevaPosicion
	}
	
	method estaDentroDeLaPantalla(nuevaPosicion) {
		return 	nuevaPosicion.x().between(0, game.width() - 1)
		and		nuevaPosicion.y().between(0, game.height() - 1)
	}
}

object helloMan {
	
	//Su wollokmon
	var property wollokmon = helloWorldMon
	
	method position() {
		return game.at(3,5)
	}

	method image() {
		return "jugador.png"
	}
}