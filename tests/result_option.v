module main

struct Car {
	mut:
	name string
	engine string
	speed int
	fuel int
}


pub fn (c Car) startup()! {

	if c.fuel > 0 {
		println('starting up the ${c.name} ${c.engine} engine')
	} else {
		return error('Maybe you should fill on some gasoline first')
	}
}


fn main() {
	mut car := Car{}
	car.name = 'Powerfull'
	car.engine = 'V12'
	car.fuel = 0

	car.startup() or {
		println(err)
	}
}