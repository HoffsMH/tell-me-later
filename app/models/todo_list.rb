class TodoList < ActiveRecord::Base
  has_many :todo_items

  validates :code, presence: true, uniqueness: true

  before_create :generate_initial_last_changed

  def self.generate_code
   SecureRandom.urlsafe_base64
  end

  def generate_initial_last_changed
   self.last_changed.nil? ? ( self.last_changed = DateTime.now ) : nil
  end

  def items_changed
    self.last_changed = DateTime.now
    self.save
  end

  def type
    :todo_list
  end

  def items
    todo_items
  end
end
