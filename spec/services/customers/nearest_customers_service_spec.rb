require 'rails_helper'

RSpec.describe Customers::NearestCustomersService do
  let(:only_text_file) do
    fixture_file_upload(
      Rails.root.join('spec/fixtures/files/only_text.txt'),
      'text/plain'
    )
  end

  let(:valid_json_file) do
    fixture_file_upload(
      Rails.root.join('spec/fixtures/files/valid_json.txt'),
      'text/plain'
    )
  end


  it "returns empty customers and no crash for plain text file" do
    result = described_class.new(only_text_file).call

    expect(result.customers).to eq([])
    expect(result.invalid_lines).not_to be_empty
  end

  it "tracks invalid json line numbers" do
    result = described_class.new(valid_json_file).call

    expect(result.invalid_lines).to all(be_an(Integer))
    expect(result.invalid_lines).not_to be_empty
  end

  it "returns customers within 100km" do
    result = described_class.new(valid_json_file).call

    customers = result.customers

    expect(customers).not_to be_empty
    expect(customers.size).to eq(2)

    customers.each do |customer|
      expect(customer.keys).to match_array(%w[id name])
    end
  end

  it "returns a structured result object" do
    result = described_class.new(valid_json_file).call

    expect(result).to respond_to(:customers, :invalid_lines)
  end
end
