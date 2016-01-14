require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
	db = SQLite3::Database.new 'db/blog.db'
	db.results_as_hash = true
	return db
end

def fields_validation hh
	hh.each_key do |i|
		if params[i]==''
			@error = "Введите: " + hh.select {|k,_| params[k] == ''}.values.join(", ")
		end
	end
end

configure do
	db = init_db
	db.execute 'CREATE TABLE IF NOT EXISTS
	"Posts"
		(
			"Id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"Creation_date" DATE,
			"Username" TEXT,
			"Content" TEXT
		)'
	db.execute 'CREATE TABLE IF NOT EXISTS
	"Comments"
		(
			"Id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"Post_id" INTEGER,
			"Creation_date" DATE,
			"Content" TEXT
		)'
	db.close
end

before '/' do
	db = init_db
	@results = db.execute 'SELECT * FROM Posts ORDER BY Id DESC'
	db.close
end

before '/details/:post_id' do
	post_id=params[:post_id]
	db = init_db
	results = db.execute 'SELECT * FROM Posts WHERE Id=?', [post_id]
	@row=results[0]
	@comments = db.execute 'SELECT * FROM Comments WHERE Post_id=? ORDER BY Id', [post_id]
	db.close
end

get '/' do
  	erb :index
end

get '/new' do
	erb :new
end

get '/details/:post_id' do
	erb :details
end

post '/new' do
	@username=params[:username]
	@message=params[:content]
	hh = {:username=>'ваше имя', :content=>'текст поста'}
	fields_validation hh
	return erb :new if !@error.nil?
	db = init_db
	db.execute 'INSERT INTO Posts (Creation_date, Username, Content) VALUES (datetime(), ?, ?)', [@username, @message]
	db.close
	redirect '/'
end

post '/details/:post_id' do
	comment=params[:content]
	post_id=params[:post_id]
	(@error="Сначала введите комментарий!"; return erb :details) if comment.strip.empty?
	db = init_db
	db.execute 'INSERT INTO Comments (Post_id, Creation_date, Content) VALUES (?, datetime(), ?)', [post_id, comment]
	db.close
	redirect ('/details/' + post_id)
end