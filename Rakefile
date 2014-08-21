require File.join(File.dirname(__FILE__), %w{config boot})

load "ruby-app/tasks.rake"
load "ruby-app-ar/tasks.rake"

require File.join(File.dirname(__FILE__), "config/environment")

task :fake do

  5.times do
    domain = "example-#{rand(100)}.com"

    10.times do
      page = Page.new
      page.url = "http://#{domain}/page-#{rand(1000)}"
      page.status = Page::STATUS_PUBLISHED

      word = (1..rand(10)+3).to_a.map { ("a".."z").to_a.sort_by{ rand }[0] }.join
      page.title = (0..rand(3) + 3).to_a.map { word }.join(' ').titleize
      page.text = (0..rand(100) + 30).to_a.map { word }.join(' ').titleize

      page.save!
    end
  end
end
