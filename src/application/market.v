module application

import themes

pub fn new_coins() {
	coinlist()
}

pub fn hot_coins() {
	coinlist()
}

pub fn wrecked_coins() {
	coinlist()
}

pub fn list_coins() {
	coinlist()
}

pub fn coinlist() []string {
	mut coins := []string{}
	coins << 'BTC'
	coins << 'ETH'
	coins << 'DOGE'
	coins << 'XRP'
	coins << 'SOL'
	coins << 'AVAX'
	coins << 'SAND'
	coins << 'SHIB'
	coins << 'MAJOR'
	coins << 'VIRTUAL'
	coins << 'CHILLGUY'

	for text in coins {
		new_text := themes.Standard.warning.colorize(text)
		println(new_text)
	}
	return coins
}
