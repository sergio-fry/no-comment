class Page < ActiveRecord::Base
  validates :url, :presence => true
  validates :domain, :presence => true
  serialize :additional_info, Hash

  scope :published, lambda { where(:status => STATUS_PUBLISHED) }

  STATUS_NEW = 0
  STATUS_PUBLISHED = 1
  STATUS_ERROR = 2

  def text
    self["text"] || self["description"]
  end

  def video
    additional_info["rca"]["video"][0]["url"] rescue nil
  end

  def url=(new_url)
    if new_url.blank?
      super
    else
      uri = Addressable::URI.parse(new_url)
      self.domain = self.class.prepare_domain(uri.host)

      result = "#{uri.scheme}://#{domain}#{uri.path}"

      # TODO: очищать маркетинговый мусор (будут дубликаты страниц)

      result += "?#{uri.query}" if uri.query.present?
      
      #result += "##{uri.fragment}" if uri.fragment.present?

      self["url"] = result
    end
  end

  def uri
    Addressable::URI.parse(url) rescue nil
  end

  def self.prepare_domain(domain)
    SimpleIDN.to_unicode(domain)
  end
end
