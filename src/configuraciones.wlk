import wollok.game.*
import entrenadores.*

object config {
	
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
		keyboard.k().onPressDo({ 
			game.say(jugador.wollokmon(), "Atacando")
			jugador.wollokmon().atacar()
		})
		
	}
	
	method configurarColisiones() {
		game.onCollideDo(jugador, { rival => 
			if (not pantallaPrincipal.entrenadorVencido().contains(rival)){
				rival.iniciarPelea(jugador)
			}
		})
	}
}

object pantallaPrincipal {
	
	const property entrenadorVencido = #{}
	
	method iniciar(){
		
		game.clear()
		
		//Agrega lo visual de la pantalla principal
		game.addVisual(jugador)
		game.addVisual(fercho)
		game.addVisual(juan)
		
		//Configura el movimiento del jugador
		config.configurarTeclasNormal()
		config.configurarColisiones()
	}
}

object pantallaDeBatalla {
	
	var property wollokmonAliado
	var property wollokmonEnemigo
	var property rivalActual
	
	method iniciar(_rival){
		
		game.clear()
		
		//settea los wollokmones en batalla
		wollokmonAliado = jugador.wollokmon()
		wollokmonEnemigo = _rival.wollokmon()
		rivalActual = _rival
		
		//cambia fondo
		game.addVisual(self)
		
		//Agrega lo visual de la pantalla de batalla
		game.addVisual(wollokmonAliado)
		game.addVisual(wollokmonEnemigo)
		
		//Configura los comandos para pelear
		config.configurarTeclaAccion()
		game.say(self, "ATACAR CON K")
	}
	
	method terminar(wollokmon){
		if(wollokmon == wollokmonAliado){
			game.say(wollokmonAliado, "Me vencieron.")
			game.schedule(5000, {=> game.stop()})
		}else{
			pantallaPrincipal.entrenadorVencido().add(rivalActual)
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