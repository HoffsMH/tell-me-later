class List < ActiveRecord::Base
  validates :code, presence: true, uniqueness: true

  before_create :generate_initial_last_changed

  def self.generate_code
    SecureRandom.urlsafe_base64
  end

  def generate_initial_last_changed
    self.last_changed.nil? ? ( self.last_changed = DateTime.now ) : nil
  end

end
