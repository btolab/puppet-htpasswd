require 'spec_helper'

if Puppet.version.to_f >= 4.0
  describe 'ht_digest' do
    it { is_expected.not_to eq(nil) }
    it { is_expected.to run.with_params.and_raise_error(ArgumentError) }
    it { is_expected.to run.with_params('', '', '').and_raise_error(ArgumentError) }
    it { is_expected.to run.with_params('asd', 'asd', 'erwe', 'asdas').and_raise_error(ArgumentError) }
    it { is_expected.to run.with_params(42, 'asdas', 'dsds').and_raise_error(ArgumentError) }

    it { is_expected.to run.with_params('testuser', 'testrealm', 'AS#(sdasdas').and_return('98598181c068e6d389d7c5d0b15cae6a') }
  end
end
