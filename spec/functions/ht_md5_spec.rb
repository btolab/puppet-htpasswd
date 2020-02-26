require 'spec_helper'

if Puppet.version.to_f >= 4.0
  describe 'ht_md5' do
    it { is_expected.not_to eq(nil) }
    it { is_expected.to run.with_params.and_raise_error(ArgumentError) }
    it { is_expected.to run.with_params('', '').and_raise_error(ArgumentError) }
    it { is_expected.to run.with_params('asd', 'erwe', 'asdas').and_raise_error(ArgumentError) }
    it { is_expected.to run.with_params(42, 'asdas').and_raise_error(ArgumentError) }

    it 'does return a MD5 hash' do
      is_expected.to run.with_params('testpassword', 'PhT5FuSg').and_return('$apr1$PhT5FuSg$3o4QbIJfx4SZMLaa9T1A9.')
    end
  end
end
