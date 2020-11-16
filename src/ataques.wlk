import wollok.game.*
import wollokmones.*


class Movimiento {
	
	method ejecutar(ejecutor, rival){
		game.say(ejecutor, "uso " + self.nombre())
		game.schedule(500, ({ 
			mensaje.mostrarAtaque(ejecutor, rival)
			game.addVisual(mensaje)
		}))
		game.schedule(1000,({rival.recibirDanio(self.danioEjercido(ejecutor, rival))
			                
		}))
		game.schedule(1500, ({game.removeVisual(mensaje)}))
	    
	}
	
	method danioEjercido(ejecutor, rival)
    method nombre()
    method efecto(ejecutor, rival){}
    method actualizarMana(ejecutor)
    method esEspecial()

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
		if(ejecutor.manaActual() < 3) {
			ejecutor.manaActual(ejecutor.manaActual() + 1)
		}
	}
	
	override method esEspecial() { return false }
  
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
		if(ejecutor.manaActual() > 0) {
			ejecutor.manaActual(ejecutor.manaActual() - 1)
		}
	}
	
	override method esEspecial() { return true }

}

object rayo inherits Especiales {
	
	override method efecto() { 
		return new EfectoRayo(turnosRestantes = 4)
	}
	 
	override method nombre(){
		return "rayo"
	} 
	
	// el ataque especial produce daño como un ataque base pero con el valor del especial
	    
}

object fuego  inherits Especiales {
	
	override method efecto() { 
		return new EfectoFuego(turnosRestantes = 4)
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
		return "brisa curativa"
	}
	
	override method efecto(ejecutor, rival){
		ejecutor.recibirEfecto(self.efecto())
	}
}

class Efectos {
	var turnosRestantes
   // son los turnos restantes en los que sigue vigente el efecto (se inicializa en la instacia de cada especial)
	
	method restarRonda(){
    	turnosRestantes -= 1
    }
    
    method finalizoEfecto(){
    	return turnosRestantes == 0
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
	// el efecto de fuego quita 7 puntos de vida al oponente al finalizar cada ronda
	
	override method efectoASufrir(wollokmonAfectado){
		
	}
	
	override method efectoASufrirPorTurno(wollokmonAfectado){
		wollokmonAfectado.recibirDanio(7)
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


