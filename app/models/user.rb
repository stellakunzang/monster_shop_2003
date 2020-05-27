class User < ApplicationRecord

  validates_presence_of :name, :address,
                        :city, :state,
                        :zip, :email,
                        :password_digest, :role

  enum role: %w(default merchant admin)
end
