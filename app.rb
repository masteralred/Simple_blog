require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, "sqlite3:./db/blog.db"

class Post < ActiveRecord::Base
	validates :name, {:presence=> true}
	validates :content, presence: true
end

class Comment <ActiveRecord::Base
end

# def fields_validation hh
# 	hh.each_key do |i|
# 		if params[i]==''
# 			@error = "Введите: " + hh.select {|k,_| params[k] == ''}.values.join(", ")
# 		end
# 	end
# end

# before '/details/:post_id' do
# 	post_id=params[:post_id]
# 	#db = init_db
# 	results = db.execute 'SELECT * FROM Posts WHERE Id=?', [post_id]
# 	@row=results[0]
# 	@comments = db.execute 'SELECT * FROM Comments WHERE Post_id=? ORDER BY Id', [post_id]
# 	db.close
# end

get '/' do
	@posts = Post.all
  	erb :index
end

get '/new' do
	@p = Post.new
	erb :new
end

get '/details/:post_id' do
	erb :details
end

post '/new' do
	@p = Post.new params[:post]
	if @p.save
		redirect '/'
	else
		@error = @p.errors.full_messages.first
		erb :new	
	end
end

# post '/details/:post_id' do
# 	comment=params[:content]
# 	post_id=params[:post_id]
# 	(@error="Сначала введите комментарий!"; return erb :details) if comment.strip.empty?
# 	db = init_db
# 	db.execute 'INSERT INTO Comments (Post_id, Creation_date, Content) VALUES (?, datetime(), ?)', [post_id, comment]
# 	db.close
# 	redirect ('/details/' + post_id)
# end