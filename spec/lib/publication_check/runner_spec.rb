require 'spec_helper'

module PublicationCheck
  describe Runner do
    let(:request_one){ double(register_check_attempt!: nil) }
    let(:request_two){ double(register_check_attempt!: nil) }
    let(:publish_requests){ [request_one, request_two] }
    let(:check){ double(new: double(run: true)) }

    it "passes each request to each check's run method" do
      allow(ContentStoreCheck).to receive(:new)
        .and_return(content_store_check = double())

      publish_requests.each do | publish_request |
        expect(content_store_check).to receive(:run)
          .with(publish_request)
      end

      Runner.run_check(publish_requests)
    end

    it "uses a new check object per check" do
      expect(ContentStoreCheck)
        .to receive(:new).exactly(2).times
        .and_return(double(run: true))
      Runner.run_check(publish_requests)
    end

    it "adds each checked PublishRequest to the result" do
      allow(Result).to receive(:new).and_return(result = Result.new)
      expect(result).to receive(:add_checked_request).with(request_one)
      expect(result).to receive(:add_checked_request).with(request_two)
      Runner.run_check(publish_requests, [check])
    end

    it "registers a check on the PublishRequest" do
      expect(request_one).to receive(:register_check_attempt!)
      Runner.run_check([request_one], [check])
    end
  end
end

