# @summary
#   hash a password using htdigest. The first argument is the username, second is realm and the third the password.
require 'digest/md5'

Puppet::Functions.create_function(:ht_digest) do
  dispatch :ht_digest do
    param 'String[1]', :user
    param 'String[1]', :realm
    param 'String[1]', :value
  end

  def ht_digest(user, realm, value)
    ::Digest::MD5.hexdigest("#{user}:#{realm}:#{value}")
  end
end
