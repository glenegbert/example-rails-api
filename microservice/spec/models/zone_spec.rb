require "rails_helper"

describe Zone do
  it "instantiates" do
    expect {create(:zone)}.to change {Zone.count}.by(1)
  end
end
