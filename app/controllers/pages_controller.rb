require 'sinatra/content_for'

class PagesController < Sinatra::Base
  helpers Sinatra::ContentFor

  helpers do
    def page_path(url)
      uri  = Addressable::URI.parse(url)
      path_escaped = uri.path.split("/").map { |c| URI.escape(c) }.join("/")
      "/comments/#{Page.prepare_domain(uri.host)}#{path_escaped}"
    end

    def video_tag(url)
      "<iframe src='#{url}' width='320px' height='240px' noborder noscroll></iframe>"
    end

    def favicon_url(url_or_domail)
      url = url_or_domail.clone
      url = "http://" + url unless url.match(/^https?:/)

      domain = Addressable::URI.parse(url).try :host

      "http://g.etfv.co/http://#{domain}"
    end
  end

  use ActiveRecord::ConnectionAdapters::ConnectionManagement

  set :public_folder, File.join(App.root, 'public')
  set :views, File.join(App.root, 'app/views')

  get "/" do
    erb "pages/index".to_sym, :locals => { }, :layout => :layout
  end

  get %r{/comments/?$} do
    erb "pages/list".to_sym, :locals => { }, :layout => :layout
  end

  # domain
  get %r{/comments/([^/]+)[/]?$} do |domain|
    erb "pages/domain".to_sym, :locals => { :domain => domain }, :layout => :layout
  end

  get %r{/comments/([^/]+)/(.*)} do |domain, path_escaped|
    url = domain + "/" + path_escaped.split("/").map { |c| URI.unescape(c) }.join("/")

    @page = Page.find_or_initialize_by(:url => "http://" + url)

    if @page.new_record?
      @page.save!
      PageParser.perform_async(@page.id)
    end

    case @page.status
    when Page::STATUS_PUBLISHED
      erb "pages/comments".to_sym, :locals => { :page => @page }, :layout => :layout
    when Page::STATUS_NEW
      erb "pages/comments_waiting".to_sym, :locals => { :page => @page }, :layout => :layout
    else
      #erb "pages/comments_error".to_sym, :locals => { :page => @page }, :layout => :layout
      "Error! Contact: sergei.udalov@gmail.com"
    end
  end
end
