import wollok.game.*
import wollokmones.*
import configuraciones.*

object jugador {

	//Su wollokmon
	var property wollokmon = pepita
	var property wollokmonesGanados = #{pepita}
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
		if (not self.esPosicionProhibida(nuevaPosicion))
		position = nuevaPosicion
	}
	
	method esPosicionProhibida(nuevaPosicion){
		return posicionesProhibidas.esProhibida(nuevaPosicion)
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
	
	method ganarWollokmon(_wollokmon){
		wollokmonesGanados.add(_wollokmon)
	}
	
	method ganar() {
		game.say(self, "¡GANASTE!")
	}
	
	method perder() {
		game.say(self, "¡GAME OVER!")
	}
	
	method tieneElWollokmon(_wollokmon){
		return wollokmonesGanados.contains(_wollokmon)
	}
	
}

object posicionesProhibidas{
	
	const property posicionesProhibidas = #{game.at(7,6), game.at(7,7), game.at(7,8), game.at(7,9), game.at(8,6),
		                                    game.at(8,9), game.at(9,6), game.at(9,8), game.at(9,9), game.at(9,10),
		                                    game.at(10,8), game.at(10,9), game.at(10,10), game.at(11,7), 
		                                    game.at(4,9), game.at(4,10), game.at(4,11), game.at(3,8), game.at(2,8),
		                                    game.at(1,8), game.at(0,8),
		                                    game.at(0,0), game.at(0,1), game.at(1,0), game.at(1,1), game.at(6,0),
		                                    game.at(6,1), game.at(7,0), game.at(7,1), game.at(8,0), game.at(8,1),
		                                    game.at(9,0), game.at(9,1), game.at(10,0), game.at(10,1), game.at(11,0),
		                                    game.at(11,1) } 
	
	
	method esProhibida(posicion){
		return posicionesProhibidas.contains(posicion)
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
const juan = new Entrenador(wollokmon = warmander, position = game.at(9,2), image = "rival.png")
const walt = new Entrenador(wollokmon = swirtle, position = game.at(6,8), image = "rival.png")