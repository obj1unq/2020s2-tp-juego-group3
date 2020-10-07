import wollok.game.*

class WollockmonEnemigo{
	var property vida = 100
	const imagen
	
	
	method position(){
		return game.at(9,9)
	}
	
	method image(){
		return imagen
	}
}

class WollockmonAmigo{
	var property vida = 100
	const imagen
	
	
	method position(){
		return game.at(1,1)
	}
	
	method image(){
		return imagen
	}
}

const pepita = new WollockmonAmigo(imagen = "pepita.png")
const aracne = new WollockmonEnemigo(imagen = "aracneF.png")
const calabazo = new WollockmonEnemigo(imagen = "calabazoF.png")
