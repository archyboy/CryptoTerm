module menus

import os
import userstuff
import config

// The main menu
pub fn main_menu(user userstuff.User) string {
	// println(exchange.description)
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
	menu['SC'] = '(S)ystem (C)rash'
	menu['LO'] = '(L)og (O)ut'
	menu['Q'] = '(Q)uit'

	mut choice := ''
	// Looping out the menu
	for menu_key, _ in menu {
		if choice == '' && choice != menu_key { // Looping as long as choice not in map
			// os.system('clear')
			for _, text in menu {
				println(text)
			}
		} else {
			break
		}

		mut autologin_msg := ''
		if user.autologin.autologin {
			autologin_msg = '(autologin)'
		}
		choice = os.input('Choose action ${user.username[0].ascii_str().to_upper()}${user.username[1..user.username.len]} ${autologin_msg}: ') // Waiting for user input
	}
	return choice.to_upper()
}
