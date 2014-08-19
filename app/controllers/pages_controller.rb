require 'sinatra/content_for'

class PagesController < Sinatra::Base
  helpers Sinatra::ContentFor

  set :public_folder, File.join(App.root, 'public')
  set :views, File.join(App.root, 'app/views')

  get "/" do
    erb "pages/index".to_sym, :locals => { }, :layout => :layout
  end

  get %r{/comments/(.*)} do |url_escaped|
    url = url_escaped.split("/").map { |c| URI.unescape(c) }.join("/")

    @page = Page.find_or_initialize_by(:url => "http://" + url)

    if @page.new_record?
      @page.save!
      PageParser.perform_async(@page.id)
    end

    erb "pages/comments".to_sym, :locals => { :page => @page }, :layout => :layout
  end
end
