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
	var property efectosRecibidos = []
	var property ataqueActual
    var property defensaActual 
    var property especialActual
	var property vidaActual = 100
	var property manaActual = 3
	
	
	//---------------PARA EL OBJECT GAME
	method position(){
		return pantallaDeBatalla.posicionDeWollokmon(self)
	}
	
	//------COMBATE Y OTROS
	
	method recibirDanio(nivelDanio){
		vidaActual = (vidaActual - (nivelDanio.max(0))).max(0)
		if (vidaActual <= 0) {
			pantallaDeBatalla.terminar(self)
		}
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
	
	// si se ejecuta un movimiento especial añade su efecto a la lista de efectos recibido y sufre el mismo.
	method recibirEfecto(_efecto){
		efectosRecibidos.add(_efecto)  //añade efecto a la lista
		efectosRecibidos.last().efectoASufrir(self)  //sufre el efecto 
	}
    
    method cumplirRonda(){
		self.restarRondaDeEfectos()   // hace que cada efecto de la lista tenga una ronda menos
		self.cumplirEfectos()         // si las rondas llegan a 0 ejecuta el deshacer efecto
		self.sacarEfectosTerminados() // saca los efectos en 0 para que no se sigan ejecutando
	}
	
	method restarRondaDeEfectos(){
		efectosRecibidos.forEach({ efecto => efecto.restarRonda() })
	}
	
	method cumplirEfectos(){
		efectosRecibidos.forEach({ efecto => efecto.efectoASufrirPorTurno(self) 
			efecto.deshacerEfectoFinalizado(self)
		})
	}
	
	method sacarEfectosTerminados(){
		efectosRecibidos.removeAllSuchThat({ efecto => efecto.finalizoEfecto() })
	}
	
	// termina todos los efectos recibidos (para cuando termina una batalla no siga teniendo efecto en la siguiente)
	method terminarEfectos(){
		efectosRecibidos.forEach({ efecto => efecto.deshacerEfecto(self) })
		efectosRecibidos.clear()
	}
	method resetearMana() {
		manaActual = 3
	}
	
	method alterarMana(n){
		manaActual = (manaActual+n).min(3).max(0)
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

class Mana {
	const wollokmon

	method position(){
		return wollokmon.position().down(1).right(2)
	}
	
	method image(){
		return "mana_" + wollokmon.manaActual().toString() + ".png" 
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

const pikawu = new Wollokmon(nombre = "pikawu", image = "pikawu.png", ataque = 10, defensa = 10, especial = 12, movimientos = [ataqueBase, rayo], ataqueActual = 10, defensaActual = 10, especialActual = 12)
const pepita = new Wollokmon(nombre = "pepita", image = "pepita.png", ataque =10, defensa = 12, especial = 10, movimientos = [ataqueBase, viento, defensa], ataqueActual = 10, defensaActual = 12, especialActual = 10)
const warmander = new Wollokmon(nombre = "warmander", image = "warmander.png", ataque = 10, defensa = 15, especial = 14, movimientos = [ataqueBase, fuego], ataqueActual = 10, defensaActual = 15, especialActual = 14)
const swirtle = new Wollokmon(nombre = "swirtle", image = "swirtle.png", ataque = 13, defensa = 12, especial = 10, movimientos = [ataqueBase, agua], ataqueActual = 13, defensaActual = 12, especialActual = 10)