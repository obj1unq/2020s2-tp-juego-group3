import wollok.game.*
import configuraciones.*
import entrenadores.*

class Wollokmon{
	var property vida = 100
	var property vidaActual = 100
	const imagen
	const property ataque
	const property defensa    
	const property especial
	const movimientos = [atacar, atacar, atacar, atacar]
	var property esAliado //<- Booleano para saber si es del jugador
	
	method position(){
		if (esAliado){
			//Si el wollokmon es del jugador va acá
			return game.at(1,1)
		}else{
			//Si no es rival, y va a acá
			return game.at(9,9)
		}
	}
	
	method image(){
		return imagen
	}
	
	method atacar(){
	   self.wollokmonRival().recibirDanio(ataque)
	   //¿Que hace esto? -> game.onTick(3000, "atacando", {=> self.up(4) })	
	}
	
	method recibirDanio(nivelDanio){
		vidaActual -= nivelDanio
		if(vidaActual > 0){
		    game.say(self, "Mi vida actual es " + vidaActual)
		}else{
			pantallaDeBatalla.terminar(self)
		}
	}
	
	method curarse(nivelCura){
		vidaActual = (vidaActual + nivelCura).min(vida)
	}
	
	method wollokmonRival(){
		return if(esAliado){pantallaDeBatalla.wollokmonEnemigo()}
			   else{pantallaDeBatalla.wollokmonAliado()}
	}
	
	method movimientoAlAzar(){
		return movimientos.anyOne()
	}
	
	method movimientoNumero(n){
		return movimientos.get(n)
	}
	
	method ejecutarMovimiento(movimiento){
		movimiento.ejecutar(self, self.wollokmonRival())
	}
}

class Vida{
	const wollokmon
	
	method position(){
		return if (wollokmon.esAliado()){
			 wollokmon.position().right(1)
        }
        else wollokmon.position().down(1)
	}
	
	method image(){
		return "vida_" + wollokmon.vidaActual().toString() + ".png"
	} 	
}

//ESTO SE TIENE Q TRANSFORMAR EN CLASE E IRSE A OTRO LADO PARA MAS ORDEN
object atacar {
	
	const nombre = "ataque"
	
	method ejecutar(ejecutor, rival){
		game.say(ejecutor, "uso " + nombre)
		game.schedule(2000,({rival.recibirDanio(self.danioEjercido(ejecutor, rival))}))
	}
	
	method danioEjercido(ejecutor, rival){
		return 10 + ejecutor.ataque() - rival.defensa()
	}
	
}

const pepita = new Wollokmon(esAliado = true, imagen = "pepita.png", ataque = 15, defensa = 10, especial = 30)
const aracne = new Wollokmon(esAliado = false, imagen = "aracneF.png", ataque = 12, defensa = 12, especial = 25)
const calabazo = new Wollokmon(esAliado = false, imagen = "calabazoF.png", ataque = 10, defensa = 20, especial = 20)
