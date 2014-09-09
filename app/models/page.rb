class Page < ActiveRecord::Base
  has_many :comments, :foreign_key => :url, :primary_key => :url

  validates :url, :presence => true
  validates :domain, :presence => true
  serialize :additional_info, Hash

  scope :published, lambda { where(:status => STATUS_PUBLISHED) }
  scope :with_comments, lambda { where("comments_count > 0") }
  scope :recent, lambda { order("created_at DESC") }

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

  def build_comments_from_hc_data
    JSON.parse(additional_info["hypercomments"]["data"][1])["comments"].each do |hc_comment|
      begin
        comments.create({
          :hc_id => hc_comment["id"],
          :url => url,
          :acc_id => hc_comment["acc_id"],
          :created_at => Time.parse(hc_comment["time"]),
          :additional_info => { "hypercomments" => hc_comment },
        })
      rescue StandardError => ex
        App.logger.error "Can't create comment: #{ex}, #{hc_comment}"
      end
    end
  end

  def self.popular(period)

    min_comments_count = where("created_at > ?", period.ago).order("comments_count DESC").limit(10).last.try(:comments_count) || ENV["CONFIG_MIN_COMMENTS_COUNT"] || 3

    where("created_at > ?", period.ago).where("comments_count >= ?", min_comments_count).order("comments_count DESC, created_at DESC")
  end
end
