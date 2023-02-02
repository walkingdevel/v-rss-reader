module main

import ui
import gx

const (
	config_path     = './config.json'
	window_width    = 1000
	window_height   = 600
	window_title    = 'RSS Reader'
	info_widget_id  = 'textbox_info'
	item_listbox_id = 'listbox_titles'
)

fn main() {
	mut app := &App{
		window: 0
		urls: read_config(config_path) or { panic(err.str()) }
	}

	app.window = ui.window(
		width: window_width
		height: window_height
		title: window_title
		mode: .resizable
		on_init: app.on_init
		children: [
			ui.column(
				margin_: 5.0
				spacing: 5
				heights: [30.0, 30.0, ui.stretch]
				children: [
					ui.row(
						widths: [ui.stretch]
						children: [
							ui.textbox(
								id: 'textbox_url'
								placeholder: 'RSS URL'
							),
						]
					),
					ui.row(
						widths: [
							ui.stretch,
							50.0,
						]
						children: [
							ui.button(
								text: 'Add'
								radius: 0
								border_color: gx.gray
								bg_color: gx.light_gray
								on_click: app.on_add_url
							),
							ui.button(
								text: 'Update'
								radius: 0
								border_color: gx.gray
								bg_color: gx.light_gray
								on_click: app.on_update
							),
						]
					),
					ui.row(
						spacing: 5
						widths: [
							300.0,
							ui.stretch,
						]
						children: [
							ui.column(
								heights: [
									ui.stretch,
								]
								children: [
									ui.listbox(
										id: item_listbox_id
										selection: 0
										on_change: app.on_change
									),
								]
							),
							ui.column(
								heights: [
									20.0,
									ui.stretch,
								]
								widths: [
									ui.stretch,
									ui.stretch,
								]
								margin_: 5.0
								children: [
									ui.button(
										text: 'Open in browser'
										radius: 0
										border_color: gx.gray
										bg_color: gx.light_gray
										on_click: app.on_open_url
									),
									ui.textbox(
										id: info_widget_id
										height: 300
										read_only: true
										is_wordwrap: true
										is_multiline: true
									),
								]
							),
						]
					),
				]
			),
		]
	)

	ui.run(app.window)
}
