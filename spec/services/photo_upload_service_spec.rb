require 'spec_helper'

describe PhotoUploadService do
  describe '#initialize' do
    it 'raises error when non-accepted attributes are passed in' do
      expect{
        described_class.new(thing: "thing", key: "key", body: "body")
      }.to raise_error(/thing[=]/)
    end
  end
  
  describe "#call" do
    it 'raises error when object without photos association passed in' do
      expect{
        described_class.new(key: "key", body: "body", object: Photo.new).call
      }.to raise_error(/photos/)
    end

    
    it "caches the photo body on the happy path" do
      review = Review.create(product: "something", rating: 5.0)
      instance = described_class.new(key: "key", body: "body", object: review)
      allow_any_instance_of(Photo).to receive(:upload).and_return(Photo.new(key: instance.send(:key), uploaded: true))
      expect(RodaCache).to receive(:set)
      instance.call
    end
  end
end