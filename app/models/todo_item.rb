class TodoItem < ActiveRecord::Base
  belongs_to :todo_list

  validates :todo_list, presence: true
  validates :title, presence: true
  validates :content, presence: true

  before_create :generate_initial_show_time

  def generate_initial_show_time
    self.show_time.nil? ? ( self.show_time = DateTime.now ) : nil
  end

  def type
    :todo_item
  end

  def list
    todo_list
  end

  def list_changed!
    list.items.empty? ? list.delete : list.items_changed
  end
end
