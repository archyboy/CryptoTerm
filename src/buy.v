module main

fn init() {
	println('NOW buy your coin of the future!!')
	thank_you()
}

pub fn list_coins() {
	mut coins := []string{}
	coins << 'BTC'
	coins << 'ETH'
	coins << 'DOGE'

	for text in coins {
		println(text)
	}
}
