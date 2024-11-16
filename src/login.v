module login

import os
import json
// import dummy

pub struct User {
pub mut:
	username string
	password string
	email    string
	logins   int
	attempts int
}

pub struct Users {
pub mut:
	users []User
}

pub fn login(error_msg string) !User {
	println(error_msg)
	println('\nPlease login!')
	username := os.input('Username: ')
	password := os.input('Password: ')

	mut users := Users{}
	if mut user := user_exists(username) {
		if user.password != password {
			user.attempts--
			// println(users)
			if user in users.users {
				println(user)
			}
			// save_dummy_user(user)
			return login('Wrong password. ${user.attempts} attempts left')
		} else {
			println('\nWelcome ${user.username[0].ascii_str().to_upper()}${user.username[1..user.username.len]}! Choose you want to do today.')
			return user
		}
	} else {
		return login(err.str())
	}
	return login('Could not login')
}

fn user_exists(username string) !User {
	db_file_path := 'src/db/user.json'
	user_file_data := load_users(db_file_path)!
	// println(user_file_data)
	users := json.decode(Users, user_file_data)!

	for u in users.users {
		if username == u.username {
			// println('user ${u.username} found')
			return u
		}
	}
	return error('User not exists!')
}

fn load_users(db_file_path string) !string {
	mut userdata := ''

	if os.is_file(db_file_path) {
		userdata = os.read_file(db_file_path)!
		if userdata != '' {
			return userdata
		} else {
			println('Could not load user file')
		}
	}
	return userdata
}

pub fn save_dummy_user(users Users) {
	db_file_path := 'src/db/user.json'

	all_users_json := json.encode_pretty(users)

	println(all_users_json)
	if !os.is_file(db_file_path) {
		mut file := os.create(db_file_path) or {
			println('Could not create the file because: ${err}')
			return
		}
		println('Writing file')
		file.write(all_users_json.bytes()) or {
			println('Could not write the file because: ${err}')
		}
		file.close()
	}
}

pub fn get_dummy_users() Users {
	mut dummy_users := Users{}

	dummy_users.users << User{
		username: 'archy'
		password: 'xzxz'
		email:    ''
		logins:   0
		attempts: 5
	}
	dummy_users.users << User{
		username: 'dummy'
		password: 'pass'
		email:    ''
		logins:   0
		attempts: 5
	}
	return dummy_users
}
