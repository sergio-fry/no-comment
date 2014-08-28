class PageParser
  include Sidekiq::Worker

  def perform(page_url)
    page = Page.find_or_create_by(page_url)

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
