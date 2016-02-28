class ListItem < ActiveRecord::Base
  belongs_to :list

  validates :list, presence: true
  validates :title, presence: true
  validates :content, presence: true

end
