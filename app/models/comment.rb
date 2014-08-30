class Comment < ActiveRecord::Base
  validates :url, :presence => true
  serialize :additional_info, Hash

  belongs_to :page, :foreign_key => :url, :primary_key => :url, :counter_cache => false

  def text
    additional_info["hypercomments"]["text"]
  end

  def avatar_url
    "http://static.hypercomments.com/data/avatars/#{acc_id}/avatar"
  end

  def nick
    additional_info["hypercomments"]["nick"]
  end
end

