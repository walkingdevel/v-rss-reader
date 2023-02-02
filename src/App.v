module main

import ui
import vxml

[heap]
struct App {
mut:
	window &ui.Window
	urls   []string
	items  []&FeedItem
}

fn (mut app App) on_init(_ &ui.Window) {
	app.fetch_sources()
	app.update_listbox()
}

fn (mut app App) on_update(_ &ui.Button) {
	app.fetch_sources()
	app.update_listbox()
}

fn (app &App) on_open_url(_ &ui.Button) {
	listbox_widget := app.window.get_or_panic[ui.ListBox](item_listbox_id)
	index := listbox_widget.selected_item_at()

	if index == -1 {
		return
	}

	item := app.items[index]

	spawn ui.open_url(item.url)
}

fn (app &App) on_change(listbox &ui.ListBox) {
	mut title_widget := app.window.get_or_panic[ui.TextBox](info_widget_id)
	index := listbox.selected_item_at()
	item := app.items[index]
	preview := item.preview()

	title_widget.set_text(preview)
}

fn (mut app App) on_add_url(_ &ui.Button) {
	url_widget := app.window.get_or_panic[ui.TextBox]('textbox_url')

	// TODO: validate url before saving
	app.add_url(url_widget.text)
	app.save_config() or {
		ui.message_box(err.str())

		return
	}

	app.fetch_sources()
	app.update_listbox()
}

fn (mut app App) fetch_sources() {
	result_chan := chan vxml.Node{}
	error_chan := chan IError{}

	for url in app.urls {
		spawn fetch_and_parse_with_chans(result_chan, error_chan, url)
	}

	app.items = []

	for _ in 0 .. app.urls.len {
		select {
			result := <-result_chan {
				app.items = get_feed_items_from_node(result)
			}
			error := <-error_chan {
				ui.message_box(error.str())
			}
		}
	}
}

fn (app &App) update_listbox() {
	mut list_widget := app.window.get_or_panic[ui.ListBox](item_listbox_id)

	list_widget.clear()

	for index, item in app.items {
		list_widget.add_item(index.str(), item.title)
	}
}

fn (mut app App) add_url(url string) {
	// TODO: duplicates
	app.urls << url
}

fn (app &App) save_config() ! {
	write_config(config_path, app.urls)!
}
