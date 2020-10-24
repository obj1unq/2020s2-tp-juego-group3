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
			                 }))
		game.schedule(2000, ({game.removeVisual(mensaje)}))
	    
	}
	
	method danioEjercido(ejecutor, rival)
    method nombre()
}

object ataqueBase inherits Atacar{
	
	override method nombre(){
		return "ataque"
	}
	
	override method danioEjercido(ejecutor, rival){
		return 10 + ejecutor.ataque() - rival.defensa()
	}

}
	
