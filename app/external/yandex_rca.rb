require 'net/http'
require 'json'

class YandexRca
  def get_page_info(url, options={})
    url_encoded = URI.escape(url, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    
    request_url = "http://rca.yandex.com/?key=#{ENV["RCA_KEY"]}&url=#{url_encoded}"
    request_url += "&full=1" if options[:full]

    uri = URI(request_url)
    JSON.parse Net::HTTP.get(uri)
  end
end
