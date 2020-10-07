import wollok.game.*
import wollokmones.*
import configuraciones.*

object jugador {

	//Su wollokmon
	var property wollokmon = pepita
	var property position = game.center()
	
	//De carga del jugador
	method image() {
		return "prota.png"
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
	
	method seleccion(posicion) {
		// Deberia devolver el objecto ataque/defensa que esta en la posicion 
		// a la derecha de la flecha
		
		// posicion x , (posicion y )+1
	}
	
	method ganar() {
		game.say(self, "¡GANASTE!")
		self.finalizarJuego()
	}
	
	method perder() {
		game.say(self, "¡GAME OVER!")
		self.finalizarJuego()
	}
	
	method finalizarJuego() {
		// Esto ejecuta el bloque de código una vez en 2 segundos
		game.schedule(2000, { game.stop() })
	}
	
}

object rival {
	
	//Su wollokmon
	var property wollokmon = aracne
	
	method position() {
		return game.at(4,5)
	}

	method image() {
		return "rival.png"
	}
	
	method iniciarPelea(jugador) {
		pantallaDeBatalla.iniciar(self)
	}
}