class ListItem < ActiveRecord::Base
  belongs_to :list
  validates :list, presence: true

end
