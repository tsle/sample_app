require 'spec_helper'

describe "UserPages" do
  let(:submit) { "Create my account" }  
  subject { page }

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }
    
    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end

  describe "signup page" do
    before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_title(full_title 'Sign up') }
  end

  describe "sign up" do
    before { visit signup_path }

    describe "with invalid information" do
      let(:user) { FactoryGirl.create(:user) }
      it "should not create a user" do
        expect{ click_button submit }.not_to change(User, :count)
      end

      it "should receive email invalid error message" do
        user.email = "notvalid@"
        click_button submit
        should have_content("Email is invalid")
      end

      it "should receive password to short error" do
        user.password = user.password_confirmation = "short"
        click_button submit
        should have_content("Email is invalid")
      end

      it "should receive invalid name error" do
        user.name = " "
	click_button submit
	should have_content("Email is invalid")
      end     
      
    end

    describe "with valid information" do
    
      before do
        fill_in "Name", with: "Jerry"
        fill_in "Email", with: "jerry@yahoo.com"
        fill_in "Password", with: "jerrypw"
        fill_in "Confirmation", with: "jerrypw"
      end
    
      it "should create a user" do
        expect { click_button submit }.to change(User, :count)
      end

      describe "after saving the user" do
        before { click_button submit }
	let(:user) { User.find_by(email: "jerry@yahoo.com") }

	it { should have_title(user.name) }
	it { should have_link("Sign out") }
	it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end              
    end
  end
end
  

