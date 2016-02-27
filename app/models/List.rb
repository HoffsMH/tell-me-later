class List < ActiveRecord::Base

  def self.generate_code
    SecureRandom.urlsafe_base64
  end

end
