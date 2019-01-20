class MonstersController < Sinatra::Base

  # Fixes reloader
  configure :development do
    register Sinatra::Reloader
  end

  # sets root as the parent-directory of the current file
  set :root, File.join(File.dirname(__FILE__), '..')

  # sets the view directory correctly
  set :views, Proc.new { File.join(root, "views") }

  # INDEX
  get "/" do
    @monsters = Monster.all
    erb :"monsters/index.html"
  end

  # NEW
  get "/new" do
    @monster = Monster.new

    erb :"monsters/new.html"
  end

  # SHOW
  get "/:id" do
    id = params[:id].to_i
    @monster = Monster.find id
    erb :"monsters/show.html"

  end

  # EDIT
  get "/:id/edit" do
    id = params[:id].to_i
    @monster = Monster.find id
    erb :"monsters/edit.html"

  end

  # CREATE
  post "/" do
    monster = Monster.new
    monster.update_values params
    monster.save

    redirect "/"
  end

  # UPDATE
  put "/:id" do
    id = params[:id].to_i
    monster = Monster.find id
    monster.update_values params
    monster.save

    redirect "/#{id}"
  end

  # DESTROY
  delete "/:id" do
    id = params[:id].to_i
    monster = Monster.find id
    monster.destroy

    redirect "/"
  end

end
