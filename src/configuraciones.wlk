import wollok.game.*
import entrenadores.*
import wollokmones.*
import ataques.*

class Pantalla {
	
	// Se carga a si misma y su contenido
	method iniciar() { 
		game.clear()
		// self.configurarTeclas()
		game.addVisual(self)
		self.configTeclas()
		rocola.cambiarTrack(self.pista())
	}
	
	// Siempre es la misma posicion de fondo
	method position(){return game.origin()}
	
	// Todas tienen que declarar su imagen
	method image()
	
	// La configuración de sus teclas
	method configTeclas()
	
	method pista() // <-- es el número de pista de la rocola
}

object menuInicial inherits Pantalla {
	
	override method image(){ return "menuInicial.png"}
	
	override method configTeclas() {
		keyboard.num1().onPressDo({ pantallaPrincipal.iniciar() })
		keyboard.num2().onPressDo({ pantallaTutorial.iniciar() })
		keyboard.num3().onPressDo({ pantallaCreditos.iniciar() })
	}
	
	override method pista() {return musicaMenu}
}

object pantallaTutorial inherits Pantalla {
	
	override method image() { return "pantallaTutorial.png"}
	
	override method configTeclas() {
		keyboard.any().onPressDo({ menuInicial.iniciar() })
	}
	
	override method pista() {return musicaMenu}
}

object pantallaCreditos inherits Pantalla { // Se puede reutilizar al finalizar el juego
	
	override method image() { return "pantallaCreditos.png"}
	
	override method configTeclas() {
		keyboard.any().onPressDo({ menuInicial.iniciar() })
	}
	
	override method pista() {return musicaMenu}
}

class PantallaDeExploracion inherits Pantalla {
	
	override method pista() {return musicaAventura}
	
	override method iniciar(){
		
		super()
		
		
		//Agrega lo visual de la pantalla principal
		game.addVisual(jugador)
		
		game.addVisual(seleccion)
		
		// Agrega solo a los entrenadores que faltan vencer
		self.entrenadoresAVencer().forEach({entrenador => game.addVisual(entrenador)})
		
		// Configura el movimiento del jugador
		self.configurarColisiones()
		
		// Comprueba si quedan rivales a vencer o si ya se ganó el juego
		self.comprobarVictoria()
		
		self.actualizarPantalla(self)
	}
	
	method esEntrenadorAVencer(entrenador){
		return self.entrenadoresAVencer().contains(entrenador)
	}
	
	method entrenadorVencido(entrenador){
		// Quita a un entrenador que fue vencido
		if(self.esEntrenadorAVencer(entrenador)){
			self.entrenadoresAVencer().remove(entrenador)
		}
	}
	
	method configurarColisiones() {
		game.onCollideDo(jugador, { rival => 
	        rival.iniciarPelea()
		})
		game.onCollideDo(jugador, { rival =>
			    pantallaInteriorCasa.iniciar()
		})
	}
	
	// para definir la pantalla a la cual volver luego de una batalla y para las posiciones prohibidas del jugador segun la pantalla actual
	method actualizarPantalla(_pantalla){
		jugador.pantallaActual(_pantalla)
		pantallaDeBatalla.pantallaAVolver(_pantalla)
	}
	
	method esPosicionProhibida(posicion){
		return self.posicionesProhibidas().contains(posicion)
	}
	
	override method configTeclas(){
		// Mover al jugador
		keyboard.left().onPressDo({ jugador.irASiSeMantieneEnLaPantalla(jugador.position().left(1)) })
		keyboard.right().onPressDo({ jugador.irASiSeMantieneEnLaPantalla(jugador.position().right(1)) })
		keyboard.up().onPressDo({ jugador.irASiSeMantieneEnLaPantalla(jugador.position().up(1)) })
		keyboard.down().onPressDo({ jugador.irASiSeMantieneEnLaPantalla(jugador.position().down(1)) })
		// Mostrar la pantala de seleccion de wollokmones
		keyboard.enter().onPressDo({ pantallaWollokmones.iniciar() })
	}
	
	method comprobarVictoria()
	method entrenadoresAVencer()
	method reset()
	method posicionesProhibidas()

}

object pantallaPrincipal inherits PantallaDeExploracion{
	var property image = "pantallaPrincipal.png"
	
	var property entrenadoresAVencer = #{fercho, ivi, juan}
	
	method posicionesProhibidas(){
		return   #{game.at(7,6), game.at(7,7), game.at(7,8), game.at(7,9), game.at(8,6),
		           game.at(8,9), game.at(9,6), game.at(9,8), game.at(9,9), game.at(9,10),
		           game.at(10,8), game.at(10,9), game.at(10,10), game.at(11,7), 
		           game.at(4,9), game.at(4,10), game.at(4,11), game.at(3,8), game.at(2,8),
		           game.at(1,8), game.at(0,8),
		           game.at(0,0), game.at(0,1), game.at(1,0), game.at(1,1), game.at(6,0),
		           game.at(6,1), game.at(7,0), game.at(7,1), game.at(8,0), game.at(8,1),
		           game.at(9,0), game.at(9,1), game.at(10,0), game.at(10,1), game.at(11,0),
		           game.at(11,1) }
    } 
    
	
	override method comprobarVictoria(){
		if(entrenadoresAVencer.isEmpty()){
		    game.addVisual(mensajeCasa)
		    game.addVisual(puerta)
		    self.desbloquearPuerta()
		}
	}
	
	method desbloquearPuerta(){
		self.image("pantallaPrincipalFinal.png")
	}
	
	
	
	override method reset(){
		entrenadoresAVencer.addAll(#{fercho, ivi, juan})
		self.image("pantallaPrincipal.png")
	}
}

object pantallaInteriorCasa inherits PantallaDeExploracion{
	var property entrenadoresAVencer = #{nahue}
	
	method posicionesProhibidas(){
		return #{ game.at(1,8), game.at(2,8), game.at(3,8), game.at(4,8), game.at(5,8),
			      game.at(6,8), game.at(7,8), game.at(8,8), game.at(9,8), game.at(9,8),
			      game.at(0,0), game.at(0,1), game.at(0,2), game.at(0,3), game.at(0,4),
			      game.at(0,5), game.at(0,6), game.at(0,5), game.at(0,6), game.at(0,7),
			      game.at(0,8), game.at(1,0), game.at(2,0), game.at(3,0), game.at(4,0),
			      game.at(5,0), game.at(6,0), game.at(7,0), game.at(8,0), game.at(9,0),
			      game.at(10,0), game.at(11,0),game.at(10,8), game.at(11,1), game.at(11,2),
			      game.at(11,3), game.at(11,4), game.at(11,5), game.at(11,6), game.at(11,7),
			      game.at(11,8)
		}
	}
	
	override method image(){
		return "pantallaCasa.png"
	}
	
	override method comprobarVictoria(){
		if(entrenadoresAVencer.isEmpty()){
			// TODO: acomodar el mensaje
			jugador.ganar()
			game.schedule(2000,{ pantallaDeVictoria.iniciar() })
		}
	}
	
	override method reset(){
		entrenadoresAVencer.addAll(#{nahue})
	}
}

object pantallaDeBatalla inherits Pantalla {
	
	var property pantallaAVolver
	var property wollokmonAliado
	var property wollokmonEnemigo
	var property rivalActual
	var property vidaAliado
	var property vidaEnemigo
	var property manaAliado
	var property manaEnemigo
	var turno = true
	
	override method pista() {return musicaBatalla}
	
	override method iniciar(){ 
		
		super()
		
		// Setea los wollokmones en batalla
		wollokmonAliado = jugador.wollokmon()
		jugador.wollokmon().image(jugador.wollokmon().nombre() + "Jugable.png") // Setea la visual del wollokmon que corresponde de espaldas
		wollokmonEnemigo = rivalActual.wollokmon()
		rivalActual.wollokmon().image(rivalActual.wollokmon().nombre() + ".png")
		
		// Describe la vida
		vidaEnemigo = new Vida(wollokmon = wollokmonEnemigo)
		vidaAliado = new Vida(wollokmon = wollokmonAliado)
		
		// Describe el mana, la cantidad de usos posibles de ataque especial
		manaEnemigo = new Mana(wollokmon = wollokmonEnemigo)
		manaAliado = new Mana(wollokmon = wollokmonAliado)
		
		// Resetea el mana del wollokmon en el caso de que no sea la primera batalla
		wollokmonAliado.resetearMana()
		wollokmonEnemigo.resetearMana()
		
		// Agrega lo visual de la pantalla de batalla
		game.addVisual(wollokmonAliado)
		game.addVisual(wollokmonEnemigo)
		game.addVisual(vidaEnemigo)
		game.addVisual(vidaAliado)
		game.addVisual(manaEnemigo)
		game.addVisual(manaAliado)
		game.addVisual(tutorialTeclas)
	}
	
	method posicionDeWollokmon(wollokmon){
		return if (wollokmon == wollokmonEnemigo) {game.at(8,8)} else {game.at(1,5)}
	}
	
	method turno(numero){
		
		//Impide apretar teclas
		turno = false
		
		// Actua el wollokmonaliado y 5 segundos despues el enemigo
		var movimiento = wollokmonAliado.movimientoNumero(numero)
		self.realizarAtaqueSegunMana(movimiento, wollokmonAliado, wollokmonEnemigo)
		movimiento = wollokmonEnemigo.movimientoAlAzar()
		game.schedule(2000,{self.realizarAtaqueSegunMana(movimiento, wollokmonEnemigo, wollokmonAliado)})
		
		// Baja la ronda de la lista de efectos en 1 y si esta llega a 0, el efecto se revierte
		// luego destraba teclas para que pueda seguir jugando el jugador
		game.schedule(4000,{
			wollokmonEnemigo.cumplirRonda()
			wollokmonAliado.cumplirRonda()
			turno = true
		})
	}
	
	// Si se intenta hacer ataque especial y no hay mana se realiza un ataque base
	method realizarAtaqueSegunMana(movimiento, ejecutor, rival) {
		// Hacer polimorfismo, no tengo que consultar si es especial, hay que ejecutar el moviemiento como movimiento.ejecutar(ejecutor, rival)
		if (movimiento.esEspecial() and ejecutor.manaActual() == 0) {
			game.say(ejecutor, "No tengo mana para especial, uso ataque basico")
			ataqueBase.ejecutar(ejecutor, rival)
		} else {
			movimiento.ejecutar(ejecutor, rival)
		}
	}
	
	method terminar(wollokmon){
		if (wollokmon == wollokmonAliado) {
			// Perdio el jugador
			game.say(wollokmon, "Me vencieron")
			game.schedule(2000, {
				self.curarWollokmones()
				pantallaDeDerrota.iniciar()
			})
		} else {
			turno = true
			wollokmonAliado.terminarEfectos() // Deshace los efectos hacia el wollokmon aliado cuanto termina la batalla
			pantallaAVolver.entrenadorVencido(rivalActual)
			self.ganarWollokmon(rivalActual)
			self.curarWollokmones()
			pantallaAVolver.iniciar()
		}
	}
	
	override method image(){
		return "forest.png"
	}
	
	method ganarWollokmon(entrenador){
		jugador.ganarWollokmon(entrenador.wollokmon())
	}
	
	method curarWollokmones(){
		wollokmonAliado.curarse(100)
		wollokmonEnemigo.curarse(100)
	}
	
	override method configTeclas() {
		
		// TODO: Eliminar en entrega final
		keyboard.k().onPressDo({ 
			game.say(jugador.wollokmon(), "Hago trampa")
			self.wollokmonEnemigo().recibirDanio(50)
		})
		
		
		keyboard.a().onPressDo({ // Ataque basico
			if(turno){
				self.turno(0)
			}
		})
		keyboard.s().onPressDo({ // Ataque especial
			if(turno){
				self.turno(1)
			}
		})
		keyboard.d().onPressDo({ // Defensa
			if(turno){
				self.turno(2)
			}
		})
		
	}
}

object pantallaWollokmones inherits Pantalla {
	
	override method image(){ return "seleccionWollokmones.png"}
	
	override method pista(){ return musicaAventura }
	
	override method configTeclas(){
		keyboard.num1().onPressDo({ self.cambiarWollokmonA(pepita) })
		keyboard.num2().onPressDo({ self.cambiarWollokmonA(pikawu) })
		keyboard.num3().onPressDo({ self.cambiarWollokmonA(swirtle) })
		keyboard.num4().onPressDo({ self.cambiarWollokmonA(warmander) })
		keyboard.space().onPressDo({ pantallaPrincipal.iniciar() })
	}
	
	method cambiarWollokmonA(_wollokmon){
		pantallaPrincipal.iniciar()
		if (jugador.tieneElWollokmon(_wollokmon)){
			jugador.wollokmon(_wollokmon)
		}
		else {
		    game.say(jugador, "Aún no has ganado ese Wollokmon"  )
		}
    }
}

class PantallaFinal inherits Pantalla {
	
	method finalizarJuego() {
		// Esto ejecuta el bloque de código una vez en 2 segundos
		// game.schedule(5000, { game.stop() })
		game.schedule(5000, { pantallaCreditos.iniciar() })
		//reset
		pantallaPrincipal.reset()
		pantallaInteriorCasa.reset()
		jugador.reset()
	}
	
	override method iniciar(){
		super()
		self.finalizarJuego()
	}
	
	override method configTeclas(){}
	
	override method pista(){return musicaMenu}
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
		return game.at(1,10)
	}
}

object seleccion {
	method image() {
		return "seleccion.png"
	}
	method position() {
		return game.at(0,0)
	}
}

object mensajeCasa {
	method image() {
		return "mensajeCasa.png"
	}
	method position() {
		return game.at(1,1)
	}
}

object puerta {
	method image(){
		return "puertaAbierta.png"
	}
	
	method position(){
        return game.at(10,7)
    }
    
    method iniciarPelea(rival){}
}

object rocola {
	
	var track = musicaMenu.sonido()
	
	method iniciar(){
		track.shouldLoop(true)
		track.volume(1)
		game.schedule(100,{track.play()})
	}
	
	method cambiarTrack(musica){
		if(self.hayTrackSonando()){
			if(self.hayCambioDeTrack(musica)){
				track.pause()
				track = musica.sonido()
				track.shouldLoop(true)
				self.reproducirTrack()
			}
		}else{
			self.iniciar()
		}
	}
	
	method hayCambioDeTrack(musica) {
		return track != musica.sonido()
	}
	
	method hayTrackSonando(){
		return track.played() and not track.paused()
	}
	
	method trackEstaPausada(){	
		return track.played() and track.paused()	
	}	

	method reproducirTrack() {	
		if(self.trackEstaPausada()){	
			track.resume()	
		}else{	
			track.play()	
		}	
	}
}

object musicaMenu {
	
	const property sonido = game.sound("pSound_menu1.wav")
}

object musicaBatalla {
	
	const property sonido = game.sound("pSound_fight.wav")
}

object musicaAventura {
	
	const property sonido = game.sound("pSound_principal.mp3")
}