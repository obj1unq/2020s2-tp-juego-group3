import wollok.game.*
import entrenadores.*

object config {
	
	method configurarTeclasBatalla(){
		/* Podría la misma imagen de poderes q pongamos referenciar las teclas.
		 * tipo una imagen q diga:
		 * "Tecla A. Ataque.
		 * Tecla D. Defender.
		 * Tecla S. Especial."
		 * 
		 * Luego sería cosa de cambiar de configuración de pantalla a pantalla, creo que
		 * se puede hacer pero hay que verlo.
		 */
	}
	
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
		
	}
	
	method configurarColisiones() {
		game.onCollideDo(jugador, { rival => rival.iniciarPelea(jugador) })
	}
}

object pantallaPrincipal {
	
	method iniciar(){
		game.boardGround("fondo.png")
		//Agrega lo visual de la pantalla principal
		game.addVisual(jugador)
		game.addVisual(rival)
		
		//Configura el movimiento del jugador
		config.configurarTeclasNormal()
		config.configurarColisiones()
	}
}

object pantallaDeBatalla {
	
	method iniciar(rival){
		
		game.clear()
		game.boardGround("forest.png")
		//Agrega lo visual de la pantalla de batalla
		game.addVisual(jugador.wollokmon())
		game.addVisual(rival.wollokmon())
		
		//Configura los comandos para pelear
		config.configurarTeclasBatalla()
		config.configurarTeclaAccion()
	}
}