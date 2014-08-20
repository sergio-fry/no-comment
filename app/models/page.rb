class Page < ActiveRecord::Base
  validates :url, :presence => true
  validates :domain, :presence => true
  serialize :additional_info, Hash

  def url=(new_url)
    if new_url.blank?
      super
    else
      uri = Addressable::URI.parse(new_url)
      self.domain = SimpleIDN.to_unicode(uri.host)

      result = "#{uri.scheme}://#{domain}#{uri.path}"

      # NOTE: не учитываем ничего, кроме path, чтобы не захватить
      #  маркетинговый мусор (будут дубликаты страниц)
      #result += "?#{uri.query}" if uri.query.present?
      #result += "##{uri.fragment}" if uri.fragment.present?

      self["url"] = result
    end
  end

  def uri
    Addressable::URI.parse(url) rescue nil
  end
end
