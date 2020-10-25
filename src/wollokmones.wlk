import wollok.game.*
import configuraciones.*
import entrenadores.*
import ataques.*

class Wollokmon {
    var property ataque
    var property defensa
    var property especial
	var property vida = 100
	var property vidaActual = 100
	
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
		return self.movimientos().anyOne()
	}
	
	method movimientoNumero(n){
		return self.movimientos().get(n)
	}
	
	// Métodos Abstractos
	method image()
	method movimientos()

}

class Pepita inherits Wollokmon{
	
	const property nombre = "pepita"
	
	override method image(){
		return "pepita.png"
	}
	
	override method movimientos(){
		return [ataqueBase,rayo]
	}
	
}

class Warmander inherits Wollokmon{
	
	const property nombre = "warmander"	
	
	override method image(){
		return "warmander.png"
	}
	
	override method movimientos(){
		return [ataqueBase]
	}

}

class Pikawu inherits Wollokmon{
	
	const property nombre = "pikawu"
	
	override method image(){
		return "pikawu.png"
	}
	
	override method movimientos(){
		return [ataqueBase]
	}
}

class Swirtle inherits Wollokmon{
	
	const property nombre = "swirtle"
	
	override method image(){
		return "swirtle.png"
	}
	
	override method movimientos(){
		return [ataqueBase]
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

const pikawu = new Pikawu(ataque =10, defensa = 11, especial = 12)
const pepita = new Pepita(ataque =15, defensa = 10, especial = 10)
const warmander = new Warmander(ataque = 10, defensa = 15, especial = 14)
const swirtle = new Swirtle(ataque = 13, defensa = 12, especial = 10)