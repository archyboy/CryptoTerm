module mainmenu

import os

// The main menu
pub fn run() string {
	mut menu := map[string]string{}
	menu['W'] = '(W)allet'
	menu['O'] = '(O)wned coins'
	menu['M'] = '(M)arket'
	menu['N'] = '(N)ew coins'
	menu['B'] = '(B)uy'
	menu['S'] = '(S)ell'
	menu['A'] = '(A)dvises'
	menu['R'] = '(R)obot AI'
	menu['C'] = '(C)onfig'
	menu['SW'] = '(SW)itch mode'
	menu['Q'] = '(Q)uit'

	mut choice := ''
	// Looping out the menu
	for menu_key, menu_value in menu {
		if choice == '' && choice != menu_key { // Looping as long as choice not in map
			os.system('clear')
			for key, text in menu {
				println(text)
			}
		} else {
			break
		}
		choice = os.input('Choose action: ').to_upper() // Waiting for user input
	}
	return choice
}
