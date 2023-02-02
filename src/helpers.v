module main

import regex

fn remove_needless_new_lines(value string) string {
	mut codes_re := regex.regex_opt('\n{3,}') or { panic(err) }

	return codes_re.replace(value, '\n')
}

fn prepare_text(value string) string {
	return remove_needless_new_lines(convert_html_to_text(value))
}
