require 'spec_helper'
require 'digest/sha1'

RSpec.describe Lois::Github do
  describe '#commit_status_api_url' do
    subject { github.commit_status_api_url }

    let(:github) { described_class.new(creds, org, repo, sha) }
    let(:creds) { '[redacted]' }
    let(:org) { 'ketiko' }
    let(:repo) { 'lois' }
    let(:sha) { Digest::SHA1.hexdigest('foo') }
    let(:expected_url) { "https://api.github.com/repos/#{org}/#{repo}/statuses/#{sha}" }

    it { is_expected.to eq(expected_url) }
  end
end
