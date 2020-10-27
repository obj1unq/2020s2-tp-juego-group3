import wollok.game.*
import wollokmones.*


class Atacar {
	
	method ejecutar(ejecutor, rival){
		game.say(ejecutor, "uso " + self.nombre())
		game.schedule(500, ({ 
			mensaje.mostrarAtaque(ejecutor, rival)
			game.addVisual(mensaje)
		}))
		game.schedule(2000,({rival.recibirDanio(self.danioEjercido(ejecutor, rival))
			                 self.efecto()
		}))
		game.schedule(2000, ({game.removeVisual(mensaje)}))
	    
	}
	
	method danioEjercido(ejecutor, rival)
    method nombre()
    method efecto()
}

object ataqueBase inherits Atacar{
	
	override method nombre(){
		return "ataque"
	}
	
	override method danioEjercido(ejecutor, rival){
		return 10 + ejecutor.ataque() - rival.defensa()
	}
	
	override method efecto(){}
}

object rayo inherits Atacar{
	// el efecto del rayo baja la defensa del oponente a la mitad haciendo q reciba mas daños
	// durante dos rondas de la batalla
	var property wollokmonAfectado
	var property rondasRestantes = 2
	
	 
	override method nombre(){
		return "rayo"
	} 
	
	// además del efecto produce daño como un ataque base pero con el valor del especial
	override method danioEjercido(ejecutor, rival){
		return 10 + ejecutor.especial() - rival.defensa()
	}
	
    // baja la defensa del wollokmonAfectado a la mitad
	override method efecto(){
		wollokmonAfectado.defensa((wollokmonAfectado.defensa() / 2 ).roundUp())
	}
	
	// si las rondas restantes del efecto son igual a 0, deshace el efecto causado
    method cumplirEfecto(){
    	if (self.finalizoEfecto()){
    	    self.deshacerEfecto()
    	}
    }
    
    method restarRonda(){
    	rondasRestantes -= 1
    }
    
    method finalizoEfecto(){
    	return rondasRestantes == 0
    }
    
    // como rayo baja la defensa a la mitad, para deshacerlo se multiplicaría la defensa
    method deshacerEfecto(){
    	wollokmonAfectado.defensa(wollokmonAfectado.defensa() * 2)
    }
}
