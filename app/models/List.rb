class List < ActiveRecord::Base
  validates :code, presence: true, uniqueness: true

  def self.generate_code
    SecureRandom.urlsafe_base64
  end

end
