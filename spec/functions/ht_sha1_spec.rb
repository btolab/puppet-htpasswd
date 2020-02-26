require 'spec_helper'

describe 'ht_sha1' do
  it 'does exist' do
    Puppet::Parser::Functions.function('ht_sha1').does == 'function_ht_sha1'
  end

  it 'does raise a ParseError if there is less than 1 argument' do
    is_expected.to run.with_params.and_raise_error(Puppet::ParseError)
  end

  it 'does raise a ParseError if there is more than 1 argument' do
    is_expected.to run.with_params('foo', 'bar').and_raise_error(Puppet::ParseError)
  end

  it 'does raise a ParseError if passed not a string' do
    is_expected.to run.with_params(42).and_raise_error(Puppet::ParseError)
  end

  it 'does return a SHA1 password' do
    is_expected.to run.with_params('testpassword').and_return('{SHA}i7YRj4/Wk1rQh2o740pxfTJwj/0=')
  end
end
