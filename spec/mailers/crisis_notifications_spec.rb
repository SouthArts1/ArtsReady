require "spec_helper"

describe CrisisNotifications do
  describe "announce" do
    let(:mail) { CrisisNotifications.announce }

    it "renders the headers" do
      mail.subject.should eq("Announce")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "resolve" do
    let(:mail) { CrisisNotifications.resolve }

    it "renders the headers" do
      mail.subject.should eq("Resolve")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "update" do
    let(:mail) { CrisisNotifications.update }

    it "renders the headers" do
      mail.subject.should eq("Update")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
