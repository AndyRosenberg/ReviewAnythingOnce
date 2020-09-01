require 'spec_helper'

describe Photo do
  subject { described_class.new(key: "mykey") }
  let(:client) { Aws::S3::Client.new(stub_responses: true) }
  
  before do
    allow(subject).to receive(:client).and_return(client)
  end

  describe "#upload" do 
    it "sets uploaded to false on bad upload" do
      client.stub_responses(:put_object, -> { raise "Boom" })
      subject.upload("pic")
      expect(subject.uploaded).to be false
    end

    it "sets uploaded to true on a good upload" do
      client.stub_responses(:put_object, OpenStruct.new(error: false))
      subject.upload("pic")
      expect(subject.uploaded).to be true
    end
  end

  describe "#has_uploaded?" do
    it "works on happy path" do
      client.stub_responses(:put_object, OpenStruct.new(error: false))
      subject.upload("pic")
      expect { subject.save! }.to_not raise_error(ActiveRecord::RecordInvalid)
    end

    it "is invalid" do
      client.stub_responses(:put_object, -> { raise "Boom" })
      subject.upload("pic")
      subject.save
      expect(subject.errors["key"]).to eq(["Photo failed to upload."])
    end
  end
end