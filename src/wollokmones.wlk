import wollok.game.*
import configuraciones.*
import entrenadores.*

class Wollokmon {

	var property vida = 100
	var property vidaActual = 100
	const imagen
	const property ataque
	const property defensa    
	const property especial
	const movimientos = [atacar, atacar, atacar, atacar]
	
	//---------------PARA EL OBJECT GAME
	method position(){
		return pantallaDeBatalla.posicionDeWollokmon(self)
	}
	
	method image(){
		return imagen
	}
	
	// LO IMPLEMENTE EN PANTALLAS:
	// TODO: mejorar la victoria total para que se de cuando le gana a mas de un rival
	//method resultadoBatalla() {
	//	if (esAliado) jugador.perder() else jugador.ganar() 
	//}
	
	//------COMBATE Y OTROS
	
	method recibirDanio(nivelDanio){
		vidaActual = (vidaActual - nivelDanio).max(0)
		if (vidaActual <= 0) {
			// TODO: Implementar una logica que verifique la condicion de victoria/derrota
			//self.resultadoBatalla()
			pantallaDeBatalla.terminar(self)
		}
	}
	
	method curarse(nivelCura){
		vidaActual = (vidaActual + nivelCura).min(vida)
	}
	
	method movimientoAlAzar(){
		return movimientos.anyOne()
	}
	
	method movimientoNumero(n){
		return movimientos.get(n)
	}

}

class Vida{
	const wollokmon

	method position(){
		return wollokmon.position().down(1)
	}
	
	method image(){
		return "vida_" + wollokmon.vidaActual().toString() + ".png" 
	}
	
} 	


// TODO: ESTO SE TIENE Q TRANSFORMAR EN CLASE E IRSE A OTRO LADO PARA MAS ORDEN
object atacar {
	
	const nombre = "ataque"
	
	method ejecutar(ejecutor, rival){
		game.say(ejecutor, "uso " + nombre)
		game.schedule(500, ({ 
			mensaje.mostrarAtaque(ejecutor, rival)
			game.addVisual(mensaje)
		}))
		game.schedule(2000,({rival.recibirDanio(self.danioEjercido(ejecutor, rival))}))
		game.schedule(2000, ({game.removeVisual(mensaje)}))
	
	}
	
	method danioEjercido(ejecutor, rival){
		return 10 + ejecutor.ataque() - rival.defensa()
	}
	
}

object mensaje {
	var property imagen = ""
	method mostrarAtaque(ejecutor, rival) {
		imagen = ("ataque_pepita_pikawu.png")
		// TODO: hacer funcionar la logica para tomar la imagen que corresponde para el mensaje
		// imagen = ("ataque_" + ejecutor.toString() + "_" + rival.toString() + ".png")
	}
	method image() {
		return imagen
	}
	method position() {
		return game.at(1,1)
	}
}

const pepita = new Wollokmon(imagen = "pepita.png", ataque = 15, defensa = 10, especial = 30)
const pikawu = new Wollokmon(imagen = "pikawu.png", ataque = 12, defensa = 12, especial = 25)
const calabazo = new Wollokmon(imagen = "calabazoF.png", ataque = 10, defensa = 20, especial = 20)
