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
		keyboard.k().onPressDo({ 
			game.say(jugador.wollokmon(), "Atacando")
			jugador.wollokmon().atacar()
		})
		keyboard.j().onPressDo({
			if(turno){
				pantallaDeBatalla.turno(0)
			}
		})
		
	}
	
	method configurarColisiones() {
		game.onCollideDo(jugador, { rival => 
			if (not pantallaPrincipal.entrenadorFueVencido(rival)){
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
	
	method entrenadorFueVencido(entrenador){
		return entrenadorVencido.contains(entrenador)
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
		game.say(self, "ATACAR CON K")
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