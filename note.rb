require 'sinatra'
require 'data_mapper'
require 'json'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/note.db")

class Note
  include DataMapper::Resource
  property :id, Serial
  property :content, Text, :required => true, :length => 140
  property :nick, Text, :required => true
  property :created_at, DateTime
end

DataMapper.finalize.auto_upgrade!

get '/' do 
  @notes = Note.all :order => :id.desc
  @title = 'All Notes'
  erb :home
end

post '/' do
  n = Note.new
  n.content = params[:content]
  n.created_at = Time.now
  n.nick = params[:nick]
  n.save
  redirect '/'
end

get '/notes.?:format?' do
  @notes = Note.all(:order => :id.desc)
  if params[:format] == "json"
    content_type :json
    @notes.to_json
  elsif params[:format] == "xml"
    content_type :xml
    @notes.to_xml
  end
end

get '/users.?:format?' do
  @users = Note.all(:order => :id.desc)
  if params[:format] == "json"
    content_type :json
    @users.to_json(:only=>[:nick])
  else
    content_type :xml
    @users.to_xml(:only=>[:nick])
  end
end


