require 'spec_helper'

if Puppet.version.to_f >= 4.0
  describe 'ht_sha1' do
    it { is_expected.not_to eq(nil) }
    it { is_expected.to run.with_params.and_raise_error(ArgumentError) }
    it { is_expected.to run.with_params('').and_raise_error(ArgumentError) }
    it { is_expected.to run.with_params('erwe', 'asdas').and_raise_error(ArgumentError) }

    it 'does return a SHA1 hash' do
      is_expected.to run.with_params('testpassword').and_return('{SHA}i7YRj4/Wk1rQh2o740pxfTJwj/0=')
    end
  end
end
