module main

import os

struct Credentials {
mut:
	username string
	password string
	email    string
	logins   int
	attempts int
}

fn help_me(msg string) {
	println(msg)
}

fn thank_you() {
	help_me('Thanks you so much VLang :)')
}

fn login() {
	println('Please login ')
	username := os.input('Username: ')
	password := os.input('Password: ')
	if check_login(username, password) {
		println('Wrong username or password!')
		login()
	}
}

fn check_login(username string, password string) bool {
	mut user := user_exists(username) or { eprintln(err) }

	if username == user.username && password == user.password {
		user.logins++
		return true
	} else {
		println('User not excists')
		return false
	}
}

fn register_user() {
	println('Please register')
	username := os.input('Username: ')
	password := os.input('Password: ')
}

fn user_exists(username string) !Credentials {
	mut dummy_users := []Credentials{}
	dummy_users << Credentials{
		username: 'archy'
		password: 'xzxz'
		email:    ''
		logins:   0
		attempts: 0
	}
	dummy_users << Credentials{
		username: 'dummy'
		password: 'pass'
		email:    ''
		logins:   0
		attempts: 0
	}

	// println(user)
	for u in dummy_users {
		if username == u.username {
			return u
		}
	}
	return error('User not exists!')
}
