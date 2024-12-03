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
}

pub fn run() {
	mut m := map[string]string{}
	m = {
		'one':   'One Love'
		'two':   'Two Stars'
		'three': 'Three is all good'
	}

	sb := SandBox{}
	sb.function_optional_return()
}

pub fn (sb SandBox) function_optional_return() ?map[string]string {
	println('To have a function with optional return type (Ex "none") add a ? at the end of function ("fn function()? type {}")')

	return none
}

pub fn x_json() ? {
	// x := json2.raw_decode('{"xyz": ["a", "b", "c"]}')!.as_map()['xyz']!.arr()[0]!
	// dump(x)
	// 	return none
}
