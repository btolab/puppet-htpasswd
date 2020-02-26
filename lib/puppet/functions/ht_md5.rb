# @summary
#   Hash a password using apache md5 algorithm. The first argument is the
#   password and the second one the salt to use

require 'digest/md5'
require 'stringio'

Puppet::Functions.create_function(:ht_md5) do
  dispatch :ht_md5 do
    param 'String[1]', :value
    param 'String[1]', :salt
  end

  def ht_md5(value, salt)
    encode(value, salt)
  end

  # from https://github.com/copiousfreetime/htauth/blob/master/lib/htauth/algorithm.rb
  # this is not the Base64 encoding, this is the to64() method from apr
  def to_64(number, rounds)
    salt_chars = (['.', '/'] + ('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a).freeze
    r = StringIO.new
    rounds.times do
      r.print(salt_chars[number % 64])
      number >>= 6
    end
    r.string
  end

  # from https://github.com/copiousfreetime/htauth/blob/master/lib/htauth/md5.rb
  def encode(password, salt)
    digest_length = 16
    prefix = '$apr1$'

    primary = ::Digest::MD5.new
    primary << password
    primary << prefix
    primary << salt

    md5_t = ::Digest::MD5.digest("#{password}#{salt}#{password}")

    l = password.length
    while l > 0
      slice_size = (l > digest_length) ? digest_length : l
      primary << md5_t[0, slice_size]
      l -= digest_length
    end

    # weirdness
    l = password.length
    while l != 0
      case (l & 1)
      when 1
        primary << 0.chr
      when 0
        primary << password[0, 1]
      end
      l >>= 1
    end

    pd = primary.digest

    encoded_password = "#{prefix}#{salt}$"

    # apr_md5_encode has this comment about a 60Mhz Pentium above this loop.
    1000.times do |x|
      ctx = ::Digest::MD5.new
      ctx << (((x & 1) == 1) ? password : pd[0, digest_length])
      unless (x % 3).zero?
        (ctx << salt)
      end
      unless (x % 7).zero?
        (ctx << password)
      end
      ctx << ((x & 1).zero? ? password : pd[0, digest_length])
      pd = ctx.digest
    end

    l = (pd[0].ord << 16) | (pd[6].ord << 8) | pd[12].ord
    encoded_password << to_64(l, 4)

    l = (pd[1].ord << 16) | (pd[7].ord << 8) | pd[13].ord
    encoded_password << to_64(l, 4)

    l = (pd[2].ord << 16) | (pd[8].ord << 8) | pd[14].ord
    encoded_password << to_64(l, 4)

    l = (pd[3].ord << 16) | (pd[9].ord << 8) | pd[15].ord
    encoded_password << to_64(l, 4)

    l = (pd[4].ord << 16) | (pd[10].ord << 8) | pd[5].ord
    encoded_password << to_64(l, 4)
    encoded_password << to_64(pd[11].ord, 2)

    encoded_password
  end
end
