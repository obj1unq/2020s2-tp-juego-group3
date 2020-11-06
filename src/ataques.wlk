import wollok.game.*
import wollokmones.*


class Atacar {
	
	method ejecutar(ejecutor, rival){
		game.say(ejecutor, "uso " + self.nombre())
		game.schedule(500, ({ 
			mensaje.mostrarAtaque(ejecutor, rival)
			game.addVisual(mensaje)
			//self.actualizarMana(ejecutor, rival)
		}))
		game.schedule(2000,({rival.recibirDanio(self.danioEjercido(ejecutor, rival))
			                
		}))
		game.schedule(2000, ({game.removeVisual(mensaje)}))
	    
	}
	
	method danioEjercido(ejecutor, rival)
    method nombre()
    method efecto(rival)
    method actualizarMana(ejecutor)
    method esEspecial()
}


object ataqueBase inherits Atacar{
	
	override method nombre(){
		return "ataque"
	}
	
	override method danioEjercido(ejecutor, rival){
		return (10 + ejecutor.ataqueActual()) - rival.defensaActual()
	}
	
	override method efecto(rival){}
	
	override method actualizarMana(ejecutor) {
		if(ejecutor.manaActual() < 3) {
			ejecutor.manaActual(ejecutor.manaActual() + 1)
		}
	}
	
	override method esEspecial() { return false }
}

class Especiales inherits Atacar{
	
	override method danioEjercido(ejecutor, rival){
		return (10 + ejecutor.especialActual()) - rival.defensaActual()
	}
	
	override method actualizarMana(ejecutor) {
		if(ejecutor.manaActual() > 0) {
			ejecutor.manaActual(ejecutor.manaActual() - 1)
		}
	}
	
	override method esEspecial() { return true }
}

object rayo inherits Especiales{
	 
	override method nombre(){
		return "rayo"
	} 
	
	// se instancia el efecto correspondiente al especial con sus turnos de duracion restantes
	override method efecto(rival){
		rival.recibirEfecto(new EfectoRayo(turnosRestantes = 4))
	}
	
	// el ataque especial produce daño como un ataque base pero con el valor del especial
	    
}

object fuego  inherits Especiales{
	
	override method nombre(){
		return "fuego"
	} 
	
	override method efecto(rival){
		rival.recibirEfecto(new EfectoFuego(turnosRestantes = 4))
	}
}

object agua inherits Especiales{
	
	override method nombre(){
		return "agua"
	}
	
	override method efecto(rival){
		rival.recibirEfecto(new EfectoAgua(turnosRestantes = 2))
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
}

class EfectoRayo inherits Efectos{
	// el efecto del rayo baja la defensa del oponente a la mitad haciendo q reciba mas daños
	// durante dos rondas de la batalla
	
	method efectoASufrir(wollokmonAfectado){
		wollokmonAfectado.defensaActual((wollokmonAfectado.defensa() / 2 ).roundUp())
	}
	
	override method deshacerEfecto(wollokmonAfectado){
		// como rayo baja la defensa a la mitad, para deshacerlo se multiplicaría la defensa
    	wollokmonAfectado.defensaActual(wollokmonAfectado.defensa())
    }
}

class EfectoFuego inherits Efectos{
	// el efecto de fuego quita 7 puntos de vida al oponente al finalizar cada ronda
	
	method efectoASufrir(wollokmonAfectado){
		wollokmonAfectado.vidaActual(wollokmonAfectado.vidaActual() - 5)
	}
	
	override method deshacerEfecto(wollokmonAfectado){}
	// como no altera los valores de ataque, defensa o especial y solo reduce la vida del oponente
	// no hay que deshacer ningun efecto
}

class EfectoAgua inherits Efectos{
	// el efecto de agual reduce el ataque del oponente a la mitad
	
	method efectoASufrir(wollokmonAfectado){
		wollokmonAfectado.ataqueActual((wollokmonAfectado.ataque() / 2).roundUp())
	}
	
	override method deshacerEfecto(wollokmonAfectado){
		wollokmonAfectado.ataqueActual(wollokmonAfectado.ataque())
	}
}




