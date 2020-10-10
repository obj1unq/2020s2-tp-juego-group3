import wollok.game.*
import configuraciones.*
import entrenadores.*

class WollokmonEnemigo{
	var property vida = 100
	const imagen
	const ataque
	const defensa    
	const especial
	
	method position(){
		return game.at(9,9)
	}
	
	method image(){
		return imagen
	}
	
	method atacar(){
	   self.wollokmonDelJugador().recibirDanio(ataque)	
	}
	
	method wollokmonDelJugador(){
		return jugador.wollokmon()
	}
	
	method recibirDanio(nivelDanio){
		vida -= nivelDanio
	}
}

class WollokmonAmigo{
	var property vida = 100
	const imagen
	const ataque
	const defensa    
	const especial

	
	method position(){
		return game.at(1,1)
	}
	
	method image(){
		return imagen
	}
	
	method atacar(){
	   self.wollokmonDelEnemigo().recibirDanio(ataque)
	   game.onTick(3000, "atacando", {=> self.up(4) })	
	}
	
	method wollokmonDelEnemigo(){
		return rival.wollokmon()
	}
	
	method recibirDanio(nivelDanio){
		vida -= nivelDanio
	}
}

const pepita = new WollokmonAmigo(imagen = "pepita.png", ataque = 15, defensa = 10, especial = 30)
const aracne = new WollokmonEnemigo(imagen = "aracneF.png", ataque = 12, defensa = 12, especial = 25)
const calabazo = new WollokmonEnemigo(imagen = "calabazoF.png", ataque = 10, defensa = 20, especial = 20)
