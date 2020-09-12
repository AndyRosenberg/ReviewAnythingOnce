require 'spec_helper'

describe PaginationService do
  before do
    10.times { Review.create(product: SecureRandom.hex(4), rating: rand(1..10)) }
  end

  describe "::paginate" do
    it "receives paginate with default args" do
      expect(described_class).to receive(:new).with(described_class.send(:defaults)).and_call_original
      described_class.paginate
    end

    it "returns the reviews in descending order by default" do
      page = JSON.parse(described_class.paginate)["page"]
      expect(page.first).to eq(Review.last.as_json)
    end

    it "returns the reviews in acending order when + sort is specified" do
      page = JSON.parse(described_class.paginate(sort: "ASC"))["page"]
      expect(page.first).to eq(Review.first.as_json)
    end

    it "returns highest rated review when review order is specified" do
      page = JSON.parse(described_class.paginate(order: "rating"))["page"]
      expect(page.first["rating"]).to eq(Review.all.max_by(&:rating).rating)
    end

    it "filters with where queries" do
      page = JSON.parse(described_class.paginate(order: "rating", where: ["rating < ?", 5]))["page"]
      expect(page.all? {|r| r["rating"] < 5 }).to be
    end

    it "returns lowest rated review when review order and + sort is specified" do
      page = JSON.parse(described_class.paginate(sort: "ASC", order: "rating"))["page"]
      expect(page.first["rating"]).to eq(Review.all.min_by(&:rating).rating)
    end
    
    it "works with any class" do
      5.times { User.create(name: SecureRandom.hex(4), email: SecureRandom.hex(2) + "@example.com", password: SecureRandom.hex(4)) }
      page = JSON.parse(described_class.paginate(klass: User))["page"]
      expect(page.first["name"]).to eq(User.last.name)
    end

    context "multiple pages" do
      let(:json) { JSON.parse(described_class.paginate(limit: 5)) }
      let(:page) { json["page"] }
      let(:nav) { json["navigation"] }
      let(:page_2) { JSON.parse(described_class.paginate(cursor: nav["next_cursor"]))["page"] }

      it "changes page by limit attribute" do
        expect(page.size).to eq 5
      end

      it "finds the correct next cursor pased on defaults" do
        expect([page.first["id"], page_2.first["id"]]).to eq [10, 5]
      end
    end
  end
end