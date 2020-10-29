import wollok.game.*
import configuraciones.*
import entrenadores.*
import ataques.*

class Wollokmon {
	const property nombre
	const property image
    const property ataque
    const property defensa
    const property especial
	const property vida = 100
	const property movimientos = []
	var property ataqueActual = ataque
    var property defensaActual = defensa
    var property especialActual = especial
	var property vidaActual = 100
	
	//---------------PARA EL OBJECT GAME
	method position(){
		return pantallaDeBatalla.posicionDeWollokmon(self)
	}
	
	//------COMBATE Y OTROS
	
	method recibirDanio(nivelDanio){
		vidaActual = (vidaActual - nivelDanio).max(0)
		if (vidaActual <= 0) {
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

const pikawu = new Wollokmon(nombre = "pikawu", image = "pikawu.png", ataque = 10, defensa = 11, especial = 12, movimientos = [ataqueBase, rayo])
const pepita = new Wollokmon(nombre = "pepita", image = "pepita.png", ataque =15, defensa = 10, especial = 10, movimientos = [ataqueBase, rayo])
const warmander = new Wollokmon(nombre = "warmander", image = "warmander.png", ataque = 10, defensa = 15, especial = 14, movimientos = [ataqueBase])
const swirtle = new Wollokmon(nombre = "swirtle", image = "swirtle.png", ataque = 13, defensa = 12, especial = 10, movimientos = [ataqueBase])