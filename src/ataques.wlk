import wollok.game.*
import wollokmones.*

class Animacion {
	
	var property image
	var indice = 0
	
	method animacion() //lista de 4 imagenes
	
	method ejecutarAnimacion(wollokmon){
		self.siguienteImagen()
		game.addVisualIn(self, wollokmon.position()) 
		game.schedule(400, ({self.siguienteImagen()}))
		game.schedule(800, ({self.siguienteImagen()}))
		game.schedule(1200, ({self.siguienteImagen()}))
		game.schedule(1500, ({
			game.removeVisual(self)
		}))
	}
	
	method siguienteImagen(){
		image = self.animacion().get(indice)
		indice = (indice + 1) % 4
	}
	
}

object animacionGolpe inherits Animacion {
	
	override method animacion() = ["basico1.png","basico2.png","basico3.png","basico4.png"]
	
}

object animacionFuego inherits Animacion {
	
	override method animacion() = ["fuego1.png","fuego2.png","fuego3.png","fuego4.png"]
	
}

object animacionQuemado inherits Animacion {
	
	override method animacion() = ["fuego1.png","fuego2.png","fuego3.png","fuego4.png"]
	
	override method ejecutarAnimacion(wollokmon){
		self.siguienteImagen()
		game.addVisualIn(self, wollokmon.position()) 
		game.schedule(20, ({self.siguienteImagen()}))
		game.schedule(40, ({self.siguienteImagen()}))
		game.schedule(60, ({self.siguienteImagen()}))
		game.schedule(80, ({game.removeVisual(self)}))
	}
}
object animacionAgua inherits Animacion {
	
	override method animacion() = ["agua1.png","agua2.png","agua3.png","agua4.png"]
	
}

object animacionViento inherits Animacion {
	
	override method animacion() = ["brisa1.png","brisa2.png","brisa3.png","brisa4.png"]
	
}

object animacionRayo inherits Animacion {
	
	override method animacion() = ["rayo1.png","rayo2.png","rayo3.png","rayo4.png"]
	
}

object animacionDefensa inherits Animacion {
	
	override method animacion() = ["defensa1.png","defensa2.png","defensa3.png","defensa1.png"]
	
}

class Movimiento {
	
	method ejecutar(ejecutor, rival){
		self.animacion(ejecutor, rival)
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
	
	method animacion(ejecutor, rival)
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
  	
  	override method animacion(ejecutor, rival){
  		animacionGolpe.ejecutarAnimacion(rival)
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
	
	override method animacion(ejecutor, rival){
		animacionRayo.ejecutarAnimacion(rival)
	}
	// el ataque especial produce daño como un ataque base pero con el valor del especial
	    
}

object fuego  inherits Especiales {
	
	override method efecto() { 
		return new EfectoFuego(turnosRestantes = 3)
	}
	
	override method nombre(){
		return "fuego"
	} 
	
	override method animacion(ejecutor, rival){
		animacionFuego.ejecutarAnimacion(rival)
	}
}

object agua inherits Especiales {
	
	override method efecto() { 
		return new EfectoAgua(turnosRestantes = 2)
	}
	
	override method nombre(){
		return "agua"
	}
	
	override method efecto(ejecutor, rival){
		ejecutor.recibirEfecto(self.efecto())
	}
	
	override method animacion(ejecutor, rival){
		animacionAgua.ejecutarAnimacion(rival)
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
	
	override method animacion(ejecutor, rival){
		animacionViento.ejecutarAnimacion(ejecutor)
	}
}

class Efectos {
	var property turnosRestantes
   // son los turnos restantes en los que sigue vigente el efecto (se inicializa en la instacia de cada especial)
	
	method nombre()
	
	method restarTurno(){
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
	
	override method nombre(){return "Rayo"}
	
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
	
	override method nombre(){return "Fuego"}
	
	override method efectoASufrir(wollokmonAfectado){
		
	}
	
	override method efectoASufrirPorTurno(wollokmonAfectado){
		wollokmonAfectado.recibirDanio(5)
		animacionQuemado.ejecutarAnimacion(wollokmonAfectado)
	}
	
	override method deshacerEfecto(wollokmonAfectado){}
	// como no altera los valores de ataque, defensa o especial y solo reduce la vida del oponente
	// no hay que deshacer ningun efecto
}

class EfectoAgua inherits Efectos{
	// el efecto de agua aumenta en 5 la defensa del wollokmon que lo ejecuta
	
	override method nombre(){return "Agua"}
	
	override method efectoASufrir(wollokmonAfectado){
		wollokmonAfectado.defensaActual((wollokmonAfectado.defensa() + 5).roundUp())
	}
	
	override method deshacerEfecto(wollokmonAfectado){
		wollokmonAfectado.defensaActual(wollokmonAfectado.defensa())
	}
}

class EfectoViento inherits Efectos{
	
	override method nombre(){return "Viento"}
	
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
    
    override method animacion(ejecutor, rival){
		animacionDefensa.ejecutarAnimacion(ejecutor)
	}
}

class DefensaTemporal inherits Efectos {
	
	override method nombre(){return "Defensa"}
	
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

