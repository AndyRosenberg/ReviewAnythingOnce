require 'spec_helper'

describe User do
  describe "#hash_password" do
    let(:new_user) { User.new(name: "Test User", email: "test@example.com", password: "4444444") }

    context "Created" do
      context "success" do
        before { new_user.save }

        it "saves" do
          expect(new_user.persisted?).to be
        end

        it "hashes the password" do
          expect(new_user.reload.password.start_with?("$argon2")).to be
        end
      end
      
      context "Password too short" do
        before do
          new_user.password = "1"
          new_user.save
        end

        it "will not save" do
          expect(new_user.new_record?).to be
        end

        it "will not hash the password" do
          expect(new_user.password).to eq("1")
        end
      end
    end

    context "updated" do
      let(:created_user) { User.create(name: "Test User", email: "test@example.com", password: "4444444") }
      let(:original_pw) { created_user.password }

      context "Flag is set" do
        before do
          created_user.update(password: "1234567", password_has_changed: true)
        end

        it "changes the password" do
          expect(created_user.saved_change_to_password?).to be
        end

        it "changes the password" do
          expect(created_user.password.start_with?("$argon2")).to be
        end
      end
    end
  end
end