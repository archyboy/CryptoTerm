module sandbox

pub struct SandBox {
	toys []Toys
}

struct Toys {
	name       string = 'Im the SuperToy!'
	age        int
	damage     f64
	fun_factor u8 @[len: 10]
	cool       bool
}

fn init() {
	// run()
}

pub fn run() {
	mut m := map[string]string{}
	m = {
		'one':   'One Love'
		'two':   'Two Starts'
		'three': 'Three is all good'
	}

	sb := SandBox{}
	sb.function_optional_return()
}

pub fn (sb SandBox) function_optional_return() ?map[string]string {
	println('To have a function with optional return type (Ex "none") add a ? at the end of function ("fn function()? type {}")')

	return none
}
