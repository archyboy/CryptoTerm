module filestuff

import os


pub fn write_to_disk(bc_json string) !string {

	mut filename := os.create('blockchain.json') or {
    	return error('Oooops..Could not write to file')
	}

	println('Saving data.....')
	filename.write(bc_json.bytes()) or {
		println(err)
	}

	filename.close() // always close file descriptor

	return 'Complete!'
}

pub fn read_from_disk(bc_json string) !byte {

	mut filename := os.open('blockchain.json') or {
    	return error('Oooops..Could not read file')
	}

	println('Reading data.....')
	mut data_json := filename.read(mut filename) or {
		println(err)
	}
	
	filename.close() // always close file descriptor

	return data_json
}