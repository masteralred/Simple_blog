require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, "sqlite3:./db/blog.db"

class Post < ActiveRecord::Base
	has_many :comments
	validates :name, {:presence=> true}
	validates :content, presence: true
end

class Comment <ActiveRecord::Base
	belongs_to :post
	validates :content, presence: true
end

get '/' do
	@posts = Post.order('created_at DESC')
  	erb :index
end

get '/new' do
	@p = Post.new
	erb :new
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

before '/details/:id' do
	@post = Post.find(params[:id])
	#@comments = Comment.where("post_id = ?", [params[:id]])
	@comments = Comment.where(post_id: params[:id])
end

get '/details/:id' do
	erb :details
end

post '/details/:id' do
	@c = Comment.new params[:comment]
	@c.post_id = params[:id]
	if @c.save
		redirect ('/details/' + params[:id])
	else
		@error = @c.errors.full_messages.first
		erb :details
	end
end