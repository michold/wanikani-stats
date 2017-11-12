require 'test_helper'

describe Log do
  it "last_update" do
    last_update = Date.today
    create(:log, created_at: last_update)
    create(:log, created_at: last_update - 1.day)
    create(:log, created_at: last_update - 1.second)
    expect(described_class.last_update).to eq(last_update)
  end
end
