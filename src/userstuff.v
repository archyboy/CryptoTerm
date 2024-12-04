module userstuff

import constants
import os
import json
import compression
import config
import time

pub struct User {
pub mut:
	username  string
	password  string
	email     string
	attempts  int
	logins    []Logins
	autologin AutoLogin
}

pub struct Logins {
	autologin bool
	date      string
	time      string
	unixtime  int
}

pub struct Users {
pub mut:
	users []User
}

pub struct AutoLogin {
pub mut:
	autologin        bool
	username_default string = 'archy'
	password_default string = 'xzxz'
}

pub fn (mut user User) login(error_msg string) !User {
	// println(error_msg)
	// println('\nPlease login!')

	mut username := ''
	mut password := ''

	// println(user.autologin.autologin)
	if !user.autologin.autologin {
		username = os.input('Username: ')
		password = os.input_password('Password: ')!
	} else {
		username = user.autologin.username_default
		password = user.autologin.password_default
	}

	user = user.user_exists(username) or { return err }
	if user.password != password {
		if user.attempts > 0 {
			user.attempts--
			user.save_user(user)!
		} else {
			user.save_dummy_user(user.get_dummy_users())
			user.login('Sorry.. You have typed wrong password too many times. Resetting database file')!
		}
		return user.login('Wrong password. ${user.attempts} attempts left')
	} else {
		return user
	}
	return user
}

pub fn (mut user User) user_exists(username string) !User {
	// user_file_data := user.load_user_database_json()!

	users := user.get_users()!
	users_array := users.users

	for u in users_array {
		if username == u.username {
			return u
		}
	}
	return user.login('User not exists!')
}

pub fn (mut user User) get_users() !Users {
	users := json.decode(Users, user.load_user_database_json()!)!
	return users
}

pub fn (mut user User) load_user_database_json() !string {
	if os.is_file(constants.db_file_path) {
		mut userdata_json := os.read_file(constants.db_file_path) or {
			return user.login('Could not read database file because: ${err}')!.str()
		}

		mut userdata_array := []u8{}
		userdata_array << userdata_json.u8()

		// println(userdata_array)
		// if !compression.validate(userdata_array) {
		//	println('Its not a string but: ${typeof(userdata_json.u8).name}')
		// println(userdata_array)
		//}

		// uncompressed_json := compression.uncompress(userdata_array)!

		// if typeof(userdata_json).name != 'string'  {

		// 	println('Its not a string but: ${typeof(userdata_json).name}')
		// }

		return if userdata_json != '' {
			userdata_json
		} else {
			user.login('The database file is empty')!.str()
		}
	}
	user.save_dummy_user(user.get_dummy_users())
	return user.login('First time user? No db file exists')!.str()
}

pub fn (mut user User) save_user(user_to_save User) ! {
	println('Saving user....${user_to_save.username}')
	mut users := user.get_users()!

	users.users[0] = user_to_save
	all_users_json := json.encode_pretty(users)

	// println(user_to_save)
	// println(users)
	// println('All users json:')
	// println(all_users_json)
	// println(os.is_file(constants.db_file_path))

	if os.is_file(constants.db_file_path) {
		mut db_file := os.create(constants.db_file_path) or {
			println('Could not open file')
			return
		}
		// println('Writing file....')
		db_file.flush()

		// compressed_all_users_json := compression.compress(all_users_json)!
		// println(all_users_json)
		db_file.write(all_users_json.bytes()) or {
			println('Could not write the file: ${db_file}(${err})')
			return
		}
		db_file.close()
	} else {
		user.save_dummy_user(user.get_dummy_users())
		user.login('Database file not exist. Writing new database file.....')!
	}
}

pub fn (mut user User) save_dummy_user(users Users) {
	if !os.is_dir(constants.db_dir_path) {
		println('You dont have a "${constants.db_file_name}" file yet in "${constants.db_dir_path}"')
		println('Trying to make path: ${constants.db_dir_path}${os.path_separator}${constants.db_file_name}')
		os.mkdir_all(constants.db_dir_path) or {
			println('Could not make home directory: ${constants.db_dir_path} because: ${err}')
			err.str()
		}
	}

	mut file_create := os.create(constants.db_file_path) or {
		println('Could not create the file because: ${err}')
		return
	}
	print('Writing file.....')
	time.sleep(time.second * 2)

	all_users_json := json.encode_pretty(users)
	file_create.write(all_users_json.bytes()) or {
		println('Could not write the file because: ${err}')
	}
	file_create.close()

	println('Success')
}

pub fn (mut user User) get_dummy_users() Users {
	mut dummy_users := Users{}

	mut dummy_logins := []Logins{}

	dummy_logins << Logins{
		autologin: false
		date:      '4.34.1999'
		time:      '22:22:22'
		unixtime:  3746264
	}
	dummy_logins << Logins{
		autologin: false
		date:      '4.34.1999'
		time:      '22:22:22'
		unixtime:  3746264
	}

	dummy_users.users << User{
		username: 'archy'
		password: 'xzxz'
		email:    ''
		logins:   dummy_logins
		attempts: 3
	}

	dummy_users.users << User{
		username: 'dummy'
		password: 'pass'
		email:    ''
		logins:   dummy_logins
		attempts: 3
	}
	return dummy_users
}
