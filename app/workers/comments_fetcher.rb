require 'net/http'

class CommentsFetcher
  include Sidekiq::Worker

  def perform(page_url)
    page = Page.find_or_create_by(url: page_url)

    uri = URI('http://c1n1.hypercomments.com/api/comments')

    xid = page.url.remove(/http:\/\//).remove(/^www\./)

    res = Net::HTTP.post_form(uri, :data => {
      "stream" => "streamstart",
      "widget_id" => 20856,
      "href" => xid,
      "xid" => xid,
      "limit" => 20,
      "filter" => "all",
      "reverse" => "true",
      "hypertext" => "false"
    }.to_json)

    page.additional_info["hypercomments"] = JSON.parse res.body

    page.comments_count = JSON.parse(page.additional_info["hypercomments"]["data"][1])["cm2"]

    page.save!

    page.build_comments_from_hc_data
  end
end

