class User <ApplicationRecord

  belongs_to :merchant, optional: true

  validates :email, uniqueness: true, presence: true
  validates_presence_of :password, require: true
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
# test conditional inclusion of merchant_id (not required)
