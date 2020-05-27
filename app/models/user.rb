class User <ApplicationRecord

  validates_presence_of :name, :address, :city, :state, :zip, :email, :password_digest

  # has_secure_password

  enum role: %w(default merchant admin)
end

# TO DO LIST
# create model spec for enum roles
