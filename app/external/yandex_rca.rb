require 'net/http'
require 'json'

class YandexRca
  def get_page_info(url)
    url_encoded = URI.escape(url, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    
    uri = URI("http://rca.yandex.com/?key=#{ENV["RCA_KEY"]}&url=#{url_encoded}")
    JSON.parse Net::HTTP.get(uri)
  end
end
