class PageParser
  include Sidekiq::Worker

  def perform(page_id)
    page = Page.find(page_id)

    rca = YandexRca.new

    page_info = rca.get_page_info(page.url)

    page.title = page_info["title"]
    page.description = page_info["content"]
    page.img = page_info["img"][0] rescue nil

    page.additional_info["rca"] = page_info

    page.save!
  end
end
