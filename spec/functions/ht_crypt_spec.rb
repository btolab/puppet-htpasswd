require 'spec_helper'

if Puppet.version.to_f >= 4.0
  describe 'ht_crypt' do
    it { is_expected.not_to eq(nil) }
    it { is_expected.to run.with_params.and_raise_error(ArgumentError) }
    it { is_expected.to run.with_params('', '').and_raise_error(ArgumentError) }
    it { is_expected.to run.with_params('asd', 'erwe', 'asdas').and_raise_error(ArgumentError) }
    it { is_expected.to run.with_params(42, 'asdas').and_raise_error(ArgumentError) }

    it 'does return a MD5 hash' do
      is_expected.to run.with_params('testpassword', 'aPhT5FuSg').and_return('aPArO4B5ImZAY')
    end
  end
end
