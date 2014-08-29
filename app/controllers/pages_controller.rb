require 'sinatra/content_for'

class PagesController < Sinatra::Base
  helpers Sinatra::ContentFor

  helpers do
    def page_path(url)
      path = url.strip.sub(/https?:\/\//, "")

      path = path.split("/").map { |c| URI.encode_www_form_component(c) }.join("/")

      "/обсуждение/#{path}"
    end

    def video_tag(url)
      if url.match /youtu/
        "<iframe src='#{url}' width='420px' height='315px'  frameborder='0' allowfullscreen></iframe>"
      else
        <<-EMBEDLY
        <a class="embedly-card" data-card-chrome="0" href="#{url}">Загрузка видео...</a>
        <script>!function(a){var b="embedly-platform",c="script";if(!a.getElementById(b)){var d=a.createElement(c);d.id=b,d.src=("https:"===document.location.protocol?"https":"http")+"://cdn.embedly.com/widgets/platform.js";var e=document.getElementsByTagName(c)[0];e.parentNode.insertBefore(d,e)}}(document);</script>
        EMBEDLY
      end
    end

    def favicon_url(url_or_domail)
      url = url_or_domail.clone
      url = "http://" + url unless url.match(/^https?:/)

      domain = Addressable::URI.parse(url).try :host

      "http://g.etfv.co/http://#{domain}"
    end

    def simple_format(text)
      text.split("\n").map { |l| "<p>#{l}</p>" }.join
    end

    def resize_image(url, width, height=nil)
      sizes = "w=#{width}"
      sizes += "&h=#{height}" if height.present?

      "http://pic.russianpulse.ru/resize?src=#{URI.encode_www_form_component(url)}&#{sizes}"
    end
  end

  use ActiveRecord::ConnectionAdapters::ConnectionManagement

  set :public_folder, File.join(App.root, 'public')
  set :views, File.join(App.root, 'app/views')

  get "/" do
    erb "pages/index".to_sym, :layout => :layout
  end

  get %r{/#{URI.encode_www_form_component("о-сайте")}/?$} do
    erb "pages/about".to_sym, :layout => :layout
  end

  get %r{/#{URI.encode_www_form_component("обсуждение")}/?$} do
    erb "pages/list".to_sym, :layout => :layout
  end

  # domain
  get %r{/#{URI.encode_www_form_component("обсуждение")}/([^/]+)[/]?$} do |domain|
    @domain = domain
    erb "pages/domain".to_sym, :layout => :layout
  end

  get %r{/#{URI.encode_www_form_component("обсуждение")}/([^/]+)/(.*)} do |domain, path_escaped|
    url = domain + "/" + path_escaped.split("/").map { |c| URI.unescape(c) }.join("/")

    @page = Page.find_or_initialize_by(:url => "http://" + url)

    if @page.new_record?
      @page.save!
      PageParser.perform_async(@page.url)
    end

    case @page.status
    when Page::STATUS_PUBLISHED
      erb "pages/comments".to_sym, :layout => :layout
    when Page::STATUS_NEW
      erb "pages/comments_waiting".to_sym, :layout => :layout
    else
      #erb "pages/comments_error".to_sym, :layout => :layout
      "Error! Contact: sergei.udalov@gmail.com"
    end
  end

  post %r{/#{URI.encode_www_form_component("обсуждение")}/([^/]+)/(.*)} do |domain, path_escaped|
    begin
      url = domain + "/" + path_escaped.split("/").map { |c| URI.unescape(c) }.join("/")

      @page = Page.find_or_initialize_by(:url => "http://" + url)

      CommentsFetcher.perform_async(@page.url)

      "OK"
    rescue StandardError => ex
      "ERROR: #{ex}"
    end
  end
end
