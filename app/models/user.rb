class User <ApplicationRecord


  validates :email, uniqueness: true, presence: true
  validates_presence_of :password_digest, require: true
  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip,
                        :role

  has_secure_password


  enum role: %w(default merchant admin)
end

# TO DO LIST
# create model spec for enum roles
# password_digest? in schema
