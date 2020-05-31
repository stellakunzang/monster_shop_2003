require 'rails_helper'

describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of :email }
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
    it { should validate_presence_of :password}
  end

  describe "enum" do
    it { should define_enum_for(:role).with_values([:default, :merchant, :admin]) }
  end

  describe "roles" do
    it "can be created as a default user" do
      default_1 = User.create(name: "Hank Hill", address: "801 N Alamo St", city: "Arlen", state: "Texas",
                             zip: "61109", email: "ProPAIN@aol.com", password_digest: "W33dWacker", role: 0)
      expect(default_1.role).to eq("default")
      expect(default_1.default?).to be_truthy
    end
  end
end
