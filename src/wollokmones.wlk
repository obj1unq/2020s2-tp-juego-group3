import wollok.game.*

object pepita {
	
	method position() { 
		//EN UN FUTURO SE TIENE QUE ADAPTAR A SI ES AMIGO O ENEMIGO
		return game.at(0,0)
	}

	method image() {
		return "pepita.png"
	}
	
}

object helloWorldMon {
	
	method position() {
		//EN UN FUTURO SE TIENE QUE ADAPTAR A SI ES AMIGO O ENEMIGO
		//Posición temporal pa ver que funque
		return game.at(10,10)
	}

	method image() {
		return "pepita.png"
	}
}