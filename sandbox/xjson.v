module sandbox

//
// import x.json2
//
// pub fn x_json()! {
//
// 	x := json2.raw_decode('{"xyz": ["a", "2", "c"]}')!.as_map()['xyz']!.arr()[0].str()
// 	y := json2.raw_decode('{"xyz": ["a", "2", "c"]}')!.as_map()['xyz']!.arr()[1].u64()
// 	z := json2.raw_decode('{"xyz": ["a", "2", "myarray"]}')!.as_map()['xyz']!.arr()[2].arr()
// 	println(x)
// 	println(y)
// 	println(z)
// 	println('')
//
// 	println(typeof(x).name)
// 	println(typeof(y).name)
// 	println(typeof(z.map(it.str)).name)
//
// 	cool_array := ['Cool array']
// 	println(typeof(cool_array.map(it.str)).name)
//
// 	ninja := json2.raw_decode('{"xyz": ["a", "2", "{myarray}"]}')!.as_map()['xyz']!.arr().map(it.str())
// 	println(typeof(ninja).name)
// 	dump(ninja)
// 	return none
// }
