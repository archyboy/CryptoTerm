module application

import term
import json
import time
import sokol.f
import rand
import fancystuff

pub const const_language = 'en_US'

pub struct Announcement {
pub mut:
	announcements []AnnouncementData @[json: data]
}

pub struct AnnouncementData {
pub mut:
	id          string @[json: annId]
	title       string @[json: annTitle]
	description string @[json: annDesc]
	timestamp   string @[json: cTime]
	language    string @[json: language]
	url         string @[json: annUrl]
}

pub fn (mut app App) get_announcements() !Announcement {
	map_params := {
		'language': 'en_US'
	}
	json_params := json.encode(map_params)

	query_params := app.exchange.params_to_query_str(map_params)

	// println(json_params)
	resp := app.exchange.execute('GET', '/api/v2/public/annoucements', '${query_params}',
		'')!
	// println(resp.body)
	announcements := json.decode(Announcement, resp.body) or {
		return error('Could not decode announcements JSON')
	}
	return announcements
}

pub fn (mut app App) show_announcement() ! {
	announcements := app.get_announcements() or { return error('Could not get announcement') }

	// Sorting announcements array magic way
	mut announcements_array := announcements.announcements.clone()
	announcements_array.sort(a.timestamp < b.timestamp)

	// println(announcements_array)
	// exit(0)

	for key, value in announcements_array {
		timestamp := i64(value.timestamp.i64())

		println('${term.gray(time.unix_milli(timestamp).str())} ${term.gray('[${(key + 1).str()}]')}')
		println('${term.bright_blue(term.bold(value.title))}')
		if value.language == const_language {
			//println('${term.bright_yellow(value.description)}')
		}
		println('${term.bright_green(value.url)}')
	}
}
