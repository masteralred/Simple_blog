require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
	db = SQLite3::Database.new 'db/leprosorium.db'
	db.results_as_hash = true
	return db
end

configure do
	db = init_db
	db.execute 'CREATE TABLE IF NOT EXISTS
	"Posts"
		(
			"Id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"Creation_date" DATE,
			"Content" TEXT
		)'
	db.close
end

before '/new' do
	db = init_db
	db.close
end

get '/' do
  	erb :index
end

get '/new' do
	erb :new
end

post '/new' do
	message=params[:content]
	(@error="Please, type your post!"; return erb :new) if message.strip.empty?
	db = init_db
	db.execute 'INSERT INTO Posts (Creation_date, Content) VALUES (datetime(), ?)', [message]
	db.close
	erb "Your typed:</br> #{message}"
end