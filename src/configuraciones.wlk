import wollok.game.*
import entrenadores.*
import wollokmones.*

object config {
	
	var property turno = true
	
	method configurarTeclasNormal(){
		// Mover al jugador
		keyboard.left().onPressDo({ jugador.irASiSeMantieneEnLaPantalla(jugador.position().left(1)) })
		keyboard.right().onPressDo({ jugador.irASiSeMantieneEnLaPantalla(jugador.position().right(1)) })
		keyboard.up().onPressDo({ jugador.irASiSeMantieneEnLaPantalla(jugador.position().up(1)) })
		keyboard.down().onPressDo({ jugador.irASiSeMantieneEnLaPantalla(jugador.position().down(1)) })
	}
	method configurarTeclaAccion() {
		// Flecha de batalla
		keyboard.enter().onPressDo({ jugador.seleccion(jugador.position()) })
		
		// TODO: Revisar funcionamiento
		keyboard.k().onPressDo({ 
			game.say(jugador.wollokmon(), "Atacando")
			jugador.wollokmon().atacar()
		})
		keyboard.j().onPressDo({
			if(turno){
				pantallaDeBatalla.turno(0)
			}
		})
		
		//Atajo para perder de una
		keyboard.h().onPressDo({jugador.wollokmon().recibirDanio(100)})
		
	}
	
	method configurarColisiones() {
		game.onCollideDo(jugador, { rival => 
				rival.iniciarPelea(jugador)
		})
	}
}

object pantallaPrincipal {
	
	const property entrenadoresAVencer = #{fercho, juan}
	
	method iniciar(){
		
		game.clear()
		
		//Agrega lo visual de la pantalla principal
		game.addVisual(jugador)
		entrenadoresAVencer.forEach({entrenador => game.addVisual(entrenador)})
		//^^^ agrega solo a los entrenadores que faltan vencer
		
		//Configura el movimiento del jugador
		config.configurarTeclasNormal()
		config.configurarColisiones()
		
		//Comprueba si quedan rivales a vencer o si ya se ganó el juego
		self.comprobarVictoria()
	}
	
	method comprobarVictoria(){
		//Si no hay rival a vencer, entonces ganar
		if(entrenadoresAVencer.isEmpty()){
			pantallaFinal.victoria()
		}
	}
	
	method esEntrenadorAVencer(entrenador){
		return entrenadoresAVencer.contains(entrenador)
	}
	
	method entrenadorVencido(entrenador){
		//Quita a un entrenador que fue vencido
		if(self.esEntrenadorAVencer(entrenador)){
			entrenadoresAVencer.remove(entrenador)
		}
	}
}

object pantallaDeBatalla {
	
	var property wollokmonAliado
	var property wollokmonEnemigo
	var property rivalActual
	var property vidaAliado
	var property vidaEnemigo
	
	method iniciar(_rival){
		
		game.clear()
		
		//settea los wollokmones en batalla
		wollokmonAliado = jugador.wollokmon()
		wollokmonEnemigo = _rival.wollokmon()
		rivalActual = _rival
		
		//describe la vida
		vidaEnemigo = new Vida(wollokmon = wollokmonEnemigo)
		vidaAliado = new Vida(wollokmon = wollokmonAliado)
		
		//cambia fondo
		game.addVisual(self)
		
		//Agrega lo visual de la pantalla de batalla
		game.addVisual(wollokmonAliado)
		game.addVisual(wollokmonEnemigo)
		game.addVisual(vidaEnemigo)
		game.addVisual(vidaAliado)
		
		//Configura los comandos para pelear
		config.configurarTeclaAccion()

		game.addVisual(tutorialTeclas)
	}
	
	method turno(numero){
		
		//Impide apretar teclas
		config.turno(false)
		
		//actua el wollokmonaliado y 5 segundos despues el enemigo
		wollokmonAliado.ejecutarMovimiento(wollokmonAliado.movimientoNumero(numero))
		game.schedule(4000,{wollokmonEnemigo.ejecutarMovimiento(wollokmonEnemigo.movimientoAlAzar())})
		
		//luego destraba teclas para que pueda seguir jugando el jugador
		game.schedule(6000,{config.turno(true)})
		
	}
	
	method terminar(wollokmon){
		if (wollokmon == wollokmonAliado) {
			//perdio el jugador
			game.say(wollokmon, "Me vencieron")
			pantallaFinal.derrota()
		} else {
			pantallaPrincipal.entrenadorVencido(rivalActual)
			pantallaPrincipal.iniciar()
		}
	}
	
	method image(){
		return "forest.png"
	}
	
	method position(){
		return game.origin()
	}
}

object pantallaFinal{
	
	var property imagen
	
	method position(){
		return game.origin()
	}
	
	method image(){
		return imagen
	}
	
	method victoria(){
		imagen = "victoria.png"
		jugador.ganar()
		game.schedule(2000,{game.addVisual(self)})
		self.finalizarJuego()
	}
	
	method derrota(){
		imagen = "derrota.png"
		game.schedule(2000,{game.addVisual(self)})
		self.finalizarJuego()
	}
	
	method finalizarJuego() {
		// Esto ejecuta el bloque de código una vez en 2 segundos
		game.schedule(5000, { game.stop() })
	}
}

object tutorialTeclas {
	method image() {
		return "teclaAtaque.png"
	}
	method position() {
		return game.at(1,9)
	}
}