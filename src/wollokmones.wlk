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
	var property esAliado //<- Booleano para saber si es del jugador
	
	//---------------PARA EL OBJECT GAME
	method position(){
		if (esAliado){
			//Si el wollokmon es del jugador va acá
			return game.at(1,5)
		}else{
			//Si no es rival, y va a acá
			return game.at(9,9)
		}
	}
	
	method image(){
		return imagen
	}
	
	//---------------ANTIGUO, aún sirve para ganar fácil con la letra "k"
	method atacar(){
	   self.wollokmonRival().recibirDanio(ataque)
	   //¿Que hace esto? -> game.onTick(3000, "atacando", {=> self.up(4) })	
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
	
	method wollokmonRival(){
		return if(esAliado){pantallaDeBatalla.wollokmonEnemigo()}
			   else{pantallaDeBatalla.wollokmonAliado()}
	}
	
	method movimientoAlAzar(){
		return movimientos.anyOne()
	}
	
	method movimientoNumero(n){
		return movimientos.get(n)
	}
	
	method ejecutarMovimiento(movimiento){
		movimiento.ejecutar(self, self.wollokmonRival())
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

const pepita = new Wollokmon(esAliado = true, imagen = "pepita.png", ataque = 15, defensa = 10, especial = 30)
const pikawu = new Wollokmon(esAliado = false, imagen = "pikawu.png", ataque = 12, defensa = 12, especial = 25)
const calabazo = new Wollokmon(esAliado = false, imagen = "calabazoF.png", ataque = 10, defensa = 20, especial = 20)
