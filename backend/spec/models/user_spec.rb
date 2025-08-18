require "rails_helper"

RSpec.describe User, type: :model do
  describe "password strength validation" do
    let(:user) { build(:user) }

    it "is valid when password contains uppercase, lowercase and a digit" do
      user.password = "GoodPass1"
      user.password_confirmation = "GoodPass1"

      expect(user).to be_valid
    end

    it "is invalid without an uppercase letter" do
      user.password = "goodpass1"
      user.password_confirmation = "goodpass1"

      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("must include at least one lowercase letter, one uppercase letter, and one digit")
    end

    it "is invalid without a lowercase letter" do
      user.password = "GOODPASS1"
      user.password_confirmation = "GOODPASS1"

      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("must include at least one lowercase letter, one uppercase letter, and one digit")
    end

    it "is invalid without a digit" do
      user.password = "GoodPass"
      user.password_confirmation = "GoodPass"

      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("must include at least one lowercase letter, one uppercase letter, and one digit")
    end

    it "does not add the strong password error when password is blank" do
      user.password = ""
      user.password_confirmation = ""

      user.valid?
      expect(user.errors[:password]).not_to include("must include at least one lowercase letter, one uppercase letter, and one digit")
    end
  end
end
