class PageParser
  include Sidekiq::Worker

  def perform(page_url_or_id)

    page = if page_url_or_id.is_a? Numeric
             Page.find page_url_or_id
           else
             Page.find_or_create_by(url: page_url_or_id)
           end

    rca = YandexRca.new

    page_info = rca.get_page_info(page.url, :full => true)

    page.title = page_info["title"]
    page.text = page_info["content"]
    page.img = page_info["img"][0] rescue nil

    page.additional_info["rca"] = page_info

    page.status = Page::STATUS_PUBLISHED

    page.save!
  end
end
