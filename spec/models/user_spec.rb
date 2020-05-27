require 'rails_helper'

describe User, type: :model do

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
    it { should validate_presence_of :email }
    it { should validate_presence_of :password}
  end

  describe "enum" do
    it { should define_enum_for(:role).with([:default, :merchant, :admin]) }
  end

end
