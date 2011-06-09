class Article < ActiveRecord::Base
  
  attr_accessible :title, :content
  
  validates_presence_of :title
  validates_presence_of :content

  def self.featured
    [{"id" => 1, "title" => 'Featured Library Article', "published_on" => 1.day.ago.to_date, "content" => 'Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Aenean eu leo quam. Sed posuere at lobortis. Aenean lacinia bibendum nulla sed consectetur.\nThis is meant to be a leader to draw people in.'}]
  end

  def self.recent
    [
      {"id" => 2, "title" => 'Library Article Title', "published_on" => 1.week.ago.to_date},
      {"id" => 3, "title" => 'Another Library Article Title', "published_on" => 1.month.ago.to_date},
      {"id" => 4, "title" => 'Yet Another Library Article Title', "published_on" => 1.year.ago.to_date}
    ]
  end
  
end