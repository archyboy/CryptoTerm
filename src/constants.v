module constants

import os

pub const home_dir_name = os.home_dir() + '/' + '.crypto_term'
pub const db_dir_name = 'db'
pub const db_dir_path = home_dir_name + '/' + db_dir_name
pub const db_file_name = 'user.json'
pub const db_file_path = db_dir_path + '/' + db_file_name
