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
	}
	
	method perder() {
		game.say(self, "¡GAME OVER!")
	}
	
}

class Entrenador {
	
	//Su wollokmon
	var property wollokmon
	const property position
	const property image
	
	method iniciarPelea() {
		pantallaDeBatalla.rivalActual(self)
		pantallaDeBatalla.iniciar()
	}
}

const fercho = new Entrenador(wollokmon = pikawu, position = game.at(4,5), image = "rival.png")
const juan = new Entrenador(wollokmon = calabazo, position = game.at(9,2), image = "rival.png")