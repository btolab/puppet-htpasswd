# @summary
#   Hash a password using crypt. The first argument is the password and
#   the second one the salt to use

Puppet::Functions.create_function(:ht_crypt) do
  dispatch :ht_crypt do
    param 'String[1]', :value
    param 'String[1]', :salt
  end

  def ht_crypt(value, salt)
    value.crypt(salt)
  end
end
