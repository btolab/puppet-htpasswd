require 'digest/sha1'
require 'base64'

module Puppet::Parser::Functions
  newfunction(
    :ht_sha1,
    type: :rvalue,
    doc: <<-EOS
      encrypt a password using a sha1 digest
    EOS
  ) do |args|
    if args.size != 1
      raise(Puppet::ParseError, 'ht_sha1(): Wrong number of arguments ' \
        "given (#{args.size} for 1)")
    end

    value = args[0]

    unless value.class == String
      raise(Puppet::ParseError, 'ht_sha1(): Requires a string to work with')
    end

    '{SHA}' + Base64.encode64(Digest::SHA1.digest(value)).chomp!
  end
end
