require './lib/lib/version'

RSpec.describe VsQueueGem do
  it "has a version number" do
    expect(VsQueueGem::VERSION).not_to be nil
  end
end