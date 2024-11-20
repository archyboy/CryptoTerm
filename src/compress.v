module compression

import compress.gzip

interface Any {}

pub fn compress(data string) ![]u8 {
	compressed := gzip.compress(data.bytes())!
	decompressed := gzip.decompress(compressed)!
	return compressed
}

pub fn uncompress(data []u8) !string {
	decompressed := gzip.decompress(data)!
	return decompressed.str()
}

pub fn validate(data []u8) bool {
	if valid := gzip.validate(data) {
		return true
	}
	return false
}
