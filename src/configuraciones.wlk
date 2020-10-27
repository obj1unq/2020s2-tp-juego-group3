import wollok.game.*
import entrenadores.*
import wollokmones.*
import ataques.*

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
			game.say(jugador.wollokmon(), "Hago trampa")
			pantallaDeBatalla.wollokmonEnemigo().recibirDanio(50)
		})
		keyboard.j().onPressDo({
			if(turno){
				pantallaDeBatalla.turno(0)
			}
		})
		
		// especial
		keyboard.l().onPressDo({
			if(turno){
				pantallaDeBatalla.turno(1)
			}})
		
		//Atajo para perder de una
		keyboard.h().onPressDo({jugador.wollokmon().recibirDanio(100)})
		
	}
	
	method configurarColisiones() {
		game.onCollideDo(jugador, { rival => 
				rival.iniciarPelea()
		})
	}
}

class Pantalla {
	
	//Se carga a si misma y su contenido
	method iniciar() { 
		game.clear()
		// self.configurarTeclas()
		game.addVisual(self)
	}
	
	//Siempre es la misma posicion de fondo
	method position(){return game.origin()}
	
	//Todas tienen que declarar su imagen
	method image()
	
	//La configuración de sus teclas
	//method configurarTeclas()

}

object pantallaPrincipal inherits Pantalla {
	
	const property entrenadoresAVencer = #{fercho, juan, walt}
	
	override method image(){ return "pantallaPrincipal.png"}
	
	override method iniciar(){
		
		super()
		
		
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
			jugador.ganar()
			game.schedule(2000,{pantallaDeVictoria.iniciar()})
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

object pantallaDeBatalla inherits Pantalla {
	
	var property wollokmonAliado
	var property wollokmonEnemigo
	var property rivalActual
	var property vidaAliado
	var property vidaEnemigo
	
	override method iniciar(){ 
		
		super()
		
		//settea los wollokmones en batalla
		wollokmonAliado = jugador.wollokmon()
		wollokmonEnemigo = rivalActual.wollokmon()
		
		//describe la vida
		vidaEnemigo = new Vida(wollokmon = wollokmonEnemigo)
		vidaAliado = new Vida(wollokmon = wollokmonAliado)
		
		//Agrega lo visual de la pantalla de batalla
		game.addVisual(wollokmonAliado)
		game.addVisual(wollokmonEnemigo)
		game.addVisual(vidaEnemigo)
		game.addVisual(vidaAliado)
		
		//Configura los comandos para pelear
		config.configurarTeclaAccion()

		game.addVisual(tutorialTeclas)
	}
	
	method posicionDeWollokmon(wollokmon){
		return if (wollokmon == wollokmonEnemigo) {game.at(8,8)} else {game.at(1,5)}
	}
	
	method turno(numero){
		
		//Impide apretar teclas
		config.turno(false)
		
		//actua el wollokmonaliado y 5 segundos despues el enemigo
		var movimiento = wollokmonAliado.movimientoNumero(numero)
		movimiento.ejecutar(wollokmonAliado, wollokmonEnemigo)
		especialesEnBatalla.agregarEspecial(movimiento, wollokmonEnemigo)
		
		movimiento = wollokmonEnemigo.movimientoAlAzar()
		game.schedule(4000,{movimiento.ejecutar(wollokmonEnemigo, wollokmonAliado)})
		especialesEnBatalla.agregarEspecial(movimiento, wollokmonAliado)
		
		//baja la ronda de la lista de efectos en 1 y si esta llega a 0, el efecto se revierte
		especialesEnBatalla.cumplirRonda()
		
		//luego destraba teclas para que pueda seguir jugando el jugador
		game.schedule(6000,{config.turno(true)})
		
	}
	
	method terminar(wollokmon){
		if (wollokmon == wollokmonAliado) {
			//perdio el jugador
			game.say(wollokmon, "Me vencieron")
			game.schedule(2000, {pantallaDeDerrota.iniciar()})
		} else {
			config.turno(true)
			especialesEnBatalla.terminarBatalla() // debería cumplirse
			pantallaPrincipal.entrenadorVencido(rivalActual)
			pantallaPrincipal.iniciar()
		}
	}
	
	override method image(){
		return "forest.png"
	}
	
}

object especialesEnBatalla{
	var property ataquesEspeciales = []
	
	// si se ejecuta un movimiento especial lo agrega a la lista
	method agregarEspecial(movimiento, _wollokmonAfectado){
		if (self.esEspecial(movimiento)){
			movimiento.wollokmonAfectado(_wollokmonAfectado)
		    ataquesEspeciales.add(movimiento)
		}
	}
	
	method cumplirRonda(){
		self.sacarEspecialesTerminados()
		self.restarRondaDeEspeciales() 	// hace que cada especial de la lista tenga una ronda menos
		self.cumplirEfectoDeEspeciales() // si las rondas llegan a 0 ejecuta el deshacer efecto
		 // saca los especialescon rondas en 0 para q no se sigan ejecutando
	}
	
	method restarRondaDeEspeciales(){
		ataquesEspeciales.forEach({ especial => especial.restarRonda() })
	}
	
	method cumplirEfectoDeEspeciales(){
		ataquesEspeciales.forEach({ especial => especial.cumplirEfecto() })
	}
	
	method sacarEspecialesTerminados(){
		ataquesEspeciales.removeAllSuchThat({ especial => especial.finalizoEfecto() })
	}
	
	//indica si un movimiento es especial (por ahora solo está el rayo)
	method esEspecial(movimiento){
		const especiales = #{rayo}
		return especiales.contains(movimiento)
	}
	
	// deshace todos los efectos y limpia la lista de Especiales (para que se ejecute cuando termina la batalla) 
	method terminarBatalla(){
		ataquesEspeciales.forEach({ especial => especial.deshacerEfecto() })
		ataquesEspeciales.clear()
	}
}

class PantallaFinal inherits Pantalla {
	
	method finalizarJuego() {
		// Esto ejecuta el bloque de código una vez en 2 segundos
		game.schedule(5000, { game.stop() })
	}
	
	override method iniciar(){
		super()
		self.finalizarJuego()
	}
	
}

object pantallaDeVictoria inherits PantallaFinal {
	
	override method image(){ return "victoria.png"}
	
}

object pantallaDeDerrota inherits PantallaFinal {
	
	override method image(){ return "derrota.png"}
	
}

object tutorialTeclas {
	method image() {
		return "teclaAtaque.png"
	}
	method position() {
		return game.at(1,9)
	}
}