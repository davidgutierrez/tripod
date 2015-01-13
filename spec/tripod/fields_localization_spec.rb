require "spec_helper"

describe Tripod::Fields do

  describe ".localized" do

    let(:barry) do
      b = Person.new('http://example.com/id/barry')
      b.name = 'Barry'

      I18n.locale = :en
      b.title = 'Doctor'
      I18n.locale = :fr
      b.title = 'Docteur'

      b
    end

    it "creates a getter for the field, which accesses data for the predicate, returning the value of the current locale in a single String" do
      I18n.locale = :en
      barry.title.should == "Doctor"
      I18n.locale = :fr
      barry.title.should == "Docteur"
    end

    it "creates a parameter for the getter to get the data in a different locale" do
      I18n.locale = :en
      barry.title(:locale => :fr).should == "Docteur"
    end

    it "creates a parameter for the getter to get the data from all locales" do
      I18n.locale = :en
      titles = barry.title(:locale => :all)
      titles.length.should == 2
      titles.should include?("Doctor")
      titles.should include?("Docteur")
    end

    it "creates a setter for the field, which sets data for the predicate in the current locale" do
      I18n.locale = :en
      barry.title = "Professor"
      barry.title.should == "Professor"
      I18n.locale = :fr
      barry.title.should == "Docteur"
      barry.title = "Professeur"
      barry.title.should == "Professeur"
      I18n.locale = :en
      barry.title.should == "Professor"
    end

    it "creates a check? method, which returns true when the value is present in the current locale" do
      I18n.locale = :en
      barry.title?.should == true
    end

    context "when the value is not set in the current locale" do
      it "should have a check? method which returns false" do
        I18n.locale = :es
        barry.title?.should == false
      end
    end

    context "where the attribute is multi-valued" do
      before do
        I18n.locale = :en
        barry.greetings = ['Hello', 'Good morning']
        I18n.locale = :fr
        barry.greetings = ['Salut', 'Bonjour']
      end

      it "should return an array" do
        I18n.locale = :en
        barry.greetings.should == ['Hello', 'Good morning']
        I18n.locale = :fr
        barry.greetings.should == ['Salut', 'Bonjour']
        barry.greetings(:locale => :all).length.should == 4
      end
    end

    I18n.locale = :en
  end
end
