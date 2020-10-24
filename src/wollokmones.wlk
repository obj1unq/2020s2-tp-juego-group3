import wollok.game.*
import configuraciones.*
import entrenadores.*
import ataques.*

class Wollokmon {

	var property vida = 100
	var property vidaActual = 100
	const movimientos = [ataqueBase, ataqueBase, ataqueBase, ataqueBase]
	
	//---------------PARA EL OBJECT GAME
	method position(){
		return pantallaDeBatalla.posicionDeWollokmon(self)
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
	
	method sufrirAtaqueEspecial(efecto){
		
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
	
	// Métodos Abstractos
	method image()
	method ataque()
	method defensa()
	method especial()

}

class Pepita inherits Wollokmon{
	
	const property nombre = "pepita"
	
	override method image(){
		return "pepita.png"
	}
	
	override method ataque(){
		return 15
	}
	
	override method defensa(){
		return 10
	}
	
	override method especial(){
		return 10
	}
}

class Warmander inherits Wollokmon{
	
	const property nombre = "warmander"	
	
	override method image(){
		return "warmander.png"
	}
	
	override method ataque(){
		return 10
	}
	
	override method defensa(){
		return 18
	}
	
	override method especial(){
		return 14
	}
	
}

class Pikawu inherits Wollokmon{
	
	const property nombre = "pikawu"
	
	override method image(){
		return "pikawu.png"
	}
	
	override method ataque(){
		return 10
	}
	
	override method defensa(){
		return 12
	}
	
	override method especial(){
		return 12
	}
}

class Swirtle inherits Wollokmon{
	
	const property nombre = "swirtle"
	
	override method image(){
		return "swirtle.png"
	}
	
	override method ataque(){
		return 10
	}
	
	override method defensa(){
		return 12
	}
	
	override method especial(){
		return 10
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





object mensaje {
	var property imagen = ""
	method mostrarAtaque(ejecutor, rival) {
		imagen = ("ataque_" + ejecutor.nombre() + "_" + rival.nombre() + ".png")
	}
	method image() {
		return imagen
	}
	method position() {
		return game.at(1,1)
	}
}

const pikawu = new Pikawu()
const pepita = new Pepita()
const warmander = new Warmander()
const swirtle = new Swirtle()