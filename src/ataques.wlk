import wollok.game.*
import wollokmones.*


class Movimiento {
	
	method ejecutar(ejecutor, rival){
		game.say(ejecutor, "uso " + self.nombre())
		game.schedule(500, ({ 
			cartel.mostrarCartel(ejecutor, rival, self)
			game.addVisual(cartel)
		}))
		game.schedule(1000,({rival.recibirDanio(self.danioEjercido(ejecutor, rival))
			                
		}))
		game.schedule(1500, ({game.removeVisual(cartel)}))
	    self.efecto(ejecutor,rival)
	    self.actualizarMana(ejecutor)
	}
	
	method danioEjercido(ejecutor, rival)
    method nombre()
    method efecto(ejecutor, rival){}
    method actualizarMana(ejecutor)
    method costo() { return 0 }
    method cartel(ejecutor, rival)

}


object ataqueBase inherits Movimiento {
	
	override method nombre(){
		return "ataque"
	}
	
	override method danioEjercido(ejecutor, rival){
		return (10 + ejecutor.ataqueActual()) - rival.defensaActual()
	}
	
 
	override method efecto(ejecutor, rival){}
	
	override method actualizarMana(ejecutor) {
		ejecutor.alterarMana(1)
	}
  	
  	override method cartel(ejecutor, rival) {
  		return ("ataque_" + ejecutor.nombre() + "_" + rival.nombre() + ".png")
  	}
}

class Especiales inherits Movimiento {
	
	method efecto()
	
	override method danioEjercido(ejecutor, rival){
		return (10 + ejecutor.especialActual()) - rival.defensaActual()
	}
	
  override method efecto(ejecutor, rival){
		rival.recibirEfecto(self.efecto())
	}
  
	override method actualizarMana(ejecutor) {
		ejecutor.alterarMana(-1)
	}
	
	override method costo() { return 1 }
	
	override method cartel(ejecutor, rival) {
    	return ("ataque_" + ejecutor.nombre() + "_" + self.nombre() + ".png")
    }

}

object rayo inherits Especiales {
	
	override method efecto() { 
		return new EfectoRayo(turnosRestantes = 3)
	}
	 
	override method nombre(){
		return "rayo"
	} 
	
	// el ataque especial produce daño como un ataque base pero con el valor del especial
	    
}

object fuego  inherits Especiales {
	
	override method efecto() { 
		return new EfectoFuego(turnosRestantes = 2)
	}
	
	override method nombre(){
		return "fuego"
	} 
}

object agua inherits Especiales {
	
	override method efecto() { 
		return new EfectoAgua(turnosRestantes = 2)
	}
	
	override method nombre(){
		return "agua"
	}
}

object viento inherits Especiales {
	
	override method efecto(){
		return new EfectoViento(turnosRestantes = 0)
	}
	
	override method danioEjercido(ejecutor, rival){
		return 0
	}
	
	override method nombre(){
		return "brisaCurativa"
	}
	
	override method efecto(ejecutor, rival){
		ejecutor.recibirEfecto(self.efecto())
	}
	
}

class Efectos {
	var property turnosRestantes
   // son los turnos restantes en los que sigue vigente el efecto (se inicializa en la instacia de cada especial)
	
	method restarRonda(){
    	turnosRestantes -= 1
    }
    
    method finalizoEfecto(){
    	return turnosRestantes <= 0
    }
    
    // si las rondas restantes del efecto son igual a 0, deshace el efecto causado
	method deshacerEfectoFinalizado(wollokmonAfectado){
    	if (self.finalizoEfecto()){
    	    self.deshacerEfecto(wollokmonAfectado)
    	}
    }
    
    method deshacerEfecto(wollokmonAfectado)
    
    method efectoASufrir(wollokmonAfectado)
    
    method efectoASufrirPorTurno(wollokmonAfectado) {
    	self.efectoASufrir(wollokmonAfectado)
    }
    
}

class EfectoRayo inherits Efectos{
	// el efecto del rayo baja la defensa del oponente a la mitad haciendo q reciba mas daños
	// durante dos rondas de la batalla
	
	override method efectoASufrir(wollokmonAfectado){
		wollokmonAfectado.defensaActual((wollokmonAfectado.defensa() / 2 ).roundUp())
	}
	
	override method deshacerEfecto(wollokmonAfectado){
		// como rayo baja la defensa a la mitad, para deshacerlo se multiplicaría la defensa
    	wollokmonAfectado.defensaActual(wollokmonAfectado.defensa())
    }
}

class EfectoFuego inherits Efectos{
	// el efecto de fuego quita 5 puntos de vida al oponente al finalizar cada ronda
	
	override method efectoASufrir(wollokmonAfectado){
		
	}
	
	override method efectoASufrirPorTurno(wollokmonAfectado){
		wollokmonAfectado.recibirDanio(5)
	}
	
	override method deshacerEfecto(wollokmonAfectado){}
	// como no altera los valores de ataque, defensa o especial y solo reduce la vida del oponente
	// no hay que deshacer ningun efecto
}

class EfectoAgua inherits Efectos{
	// el efecto de agual reduce el ataque del oponente a la mitad
	
	override method efectoASufrir(wollokmonAfectado){
		wollokmonAfectado.ataqueActual((wollokmonAfectado.ataque() / 2).roundUp())
	}
	
	override method deshacerEfecto(wollokmonAfectado){
		wollokmonAfectado.ataqueActual(wollokmonAfectado.ataque())
	}
}

class EfectoViento inherits Efectos{
	
	override method efectoASufrir(wollokmonAfectado){
		wollokmonAfectado.curarse(20)
	}
	
	override method efectoASufrirPorTurno(wollokmonAfectado){}
	
	override method deshacerEfecto(wollokmonAfectado){}
	
}

object defensa inherits Movimiento {
	override method danioEjercido(ejecutor, rival){
		return 0
	}
    override method nombre(){
    	return "defensa"
    }
    override method efecto(ejecutor, rival){
    	ejecutor.recibirEfecto(self.efecto())
    }
    override method actualizarMana(ejecutor) {
    	ejecutor.alterarMana(1)
    }
    
    method efecto(){
    	return new DefensaTemporal(turnosRestantes = 2)
    }
    override method cartel(ejecutor, rival) {
    	return ("ataque_" + ejecutor.nombre() + "_" + self.nombre() + ".png")
    }
}

class DefensaTemporal inherits Efectos {
	
    override method deshacerEfecto(wollokmonAfectado){
    	wollokmonAfectado.defensaActual(wollokmonAfectado.defensa())
    }
    
    override method efectoASufrir(wollokmonAfectado){
    	wollokmonAfectado.defensaActual(wollokmonAfectado.defensaActual() * 2)
    }
}

object cartel {
	var property imagen = ""
	method image() {
		return imagen
	}
	method position() {
		return game.at(1,1)
	}
	method mostrarCartel(ejecutor, rival, movimiento) {	
			imagen = movimiento.cartel(ejecutor, rival)
	
	}
}

