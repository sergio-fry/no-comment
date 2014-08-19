class PagesController < Sinatra::Base
  set :public_folder, File.join(App.root, 'public')
  set :views, File.join(App.root, 'app/views')

  get "/" do
    erb "pages/index".to_sym, :locals => { }, :layout => :layout
  end

  get %r{/comments/.*} do
    erb "pages/comments".to_sym, :locals => { }, :layout => :layout
  end
end
