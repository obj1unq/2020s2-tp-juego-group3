import wollok.game.*
import wollokmones.*
import configuraciones.*

object jugador {

	// Su wollokmon
	var property wollokmon = pepita
	var property wollokmonesGanados = #{pepita}
	var property position = game.center()
	var property pantallaActual

	method reset(){
		position = game.center()
		wollokmon = pepita
		wollokmonesGanados.clear()
		wollokmonesGanados.add(wollokmon)
	}
	
	// De carga del jugador
	method image() {
		return "prota.png"
	}
	
	// De movimiento del jugador
	method irASiSeMantieneEnLaPantalla(nuevaPosicion) {
		if (self.estaDentroDeLaPantalla(nuevaPosicion) and not self.esPosicionProhibida(nuevaPosicion)) {
			self.irA(nuevaPosicion)
		}
	}
	
	method irA(nuevaPosicion){
		position = nuevaPosicion
	}
	
	method esPosicionProhibida(nuevaPosicion){
		return pantallaActual.esPosicionProhibida(nuevaPosicion)
	}
	
	method estaDentroDeLaPantalla(nuevaPosicion) {
		return 	nuevaPosicion.x().between(0, game.width() - 1)
		and		nuevaPosicion.y().between(0, game.height() - 1)
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

class Entrenador {
	
	// Su wollokmon
	var property wollokmon
	const property position
	const property image
	
	method iniciarPelea(){
		pantallaDeBatalla.rivalActual(self)
		pantallaDeBatalla.iniciar()
	}	
}

const fercho = new Entrenador(wollokmon = pikawu, position = game.at(4,5), image = "fercho.png")
const juan = new Entrenador(wollokmon = warmander, position = game.at(9,2), image = "juan.png")
const ivi = new Entrenador(wollokmon = swirtle, position = game.at(7,10), image = "ivi.png")
const nahue = new Entrenador(wollokmon = silvestre, position = game.at(4,4), image = "nahue.png")