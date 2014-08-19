class PagesController < Sinatra::Base
  set :public_folder, File.join(App.root, 'public')
  set :views, File.join(App.root, 'app/views')

  get "/" do
    erb "pages/index".to_sym, :locals => { }, :layout => :layout
  end

  get %r{/comments/(.+)} do |url_without_protocol|
    url = "http://" + url_without_protocol
    page_id = url_without_protocol

    erb "pages/comments".to_sym, :locals => { :url => url, :page_id => page_id }, :layout => :layout
  end
end
