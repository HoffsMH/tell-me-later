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

  def item_added
    update(item_count: item_count + 1, last_changed: Time.now)
  end

  def item_deleted
    update(item_count: item_count - 1, last_changed: Time.now)
  end
end
