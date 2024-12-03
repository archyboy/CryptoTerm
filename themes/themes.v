module themes

import term

pub struct Themes {
pub mut:
	standard Standard
	funky    Funky
}

// ------------------------------------ STANDARD Theme ---------------------------------------------
//
pub enum Standard {
	title
	text
	link
	notice
	success
	failure
	warning
	error
	panic
}

pub fn (st Standard) colorize(text string) ?string {
	match st {
		.title {
			return term.bg_blue(term.bright_white(term.bold(text)))
		}
		.text {
			return term.white(text)
		}
		.link {
			return term.bg_white(term.black(text))
		}
		.notice {
			return term.gray(text)
		}
		.success {
			return term.bg_green(term.bright_yellow(term.bold(text)))
		}
		.failure {
			return term.bg_yellow(term.bright_red(term.bold(text)))
		}
		.warning {
			return term.bg_magenta(term.red(term.bold(term.underline(term.warn_message(text)))))
		}
		.error {
			return term.bright_red(term.bold(text))
		}
		.panic {
			for i in 1 .. 10 {
				term.set_cursor_position(x: i + 5, y: i + 5)
				println(term.bg_yellow(term.bright_red(term.bold('PANIC!!!!!!'))))
				term.reset('')
			}
		}
	}
	return none
}

// ------------------------------------ FUNKY Theme ---------------------------------------------
//
pub enum Funky {
	title
	text
	link
	notice
	success
	failure
	warning
	error
	panic
}

// Colorizing the stuff
// colorize(funky_text)
pub fn (st Funky) colorize(text string) string {
	match st {
		.title {
			return term.bg_blue(term.bright_white(term.bold(text)))
		}
		.text {
			return term.white(text)
		}
		.link {
			return term.bg_white(term.black(text))
		}
		.notice {
			return term.gray(text)
		}
		.success {
			return term.bg_green(term.bright_yellow(term.bold(text)))
		}
		.failure {
			return term.bg_yellow(term.bright_red(term.bold(text)))
		}
		.warning {
			return term.bg_magenta(term.red(term.bold(term.underline(term.warn_message(text)))))
		}
		.error {
			return term.bright_red(term.bold(text))
		}
		.panic {
			for i in 1 .. 10 {
				term.set_cursor_position(x: i + 5, y: i + 5)
				println(term.bg_yellow(term.bright_red(term.bold('PANIC!!!!!!'))))
				term.reset('Ohhha yeahh')
			}
			return term.bg_yellow(term.bright_red(term.bold(term.rapid_blink(text))))
		}
	}
}
