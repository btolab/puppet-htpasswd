require 'puppet/provider/parsedfile'
htdigest_file = '/etc/httpd/conf/htdigest'

Puppet::Type.type(:htdigest).provide(
  :parsed,
  parent: Puppet::Provider::ParsedFile,
  default_target: htdigest_file,
  filetype: :flat,
) do

  desc 'htdigest provider that uses the ParsedFile class'

  text_line :blank,
            match: %r{^\s*$}
  text_line :comment,
            match: %r{^#},
            post_parse: proc do |record|
              if record[:line] =~ %r{Puppet Name: (.+)\s*$}
                record[:name] = Regex.last_match(1)
              end
            end
  record_line :parsed,
              fields: ['username', 'realm', 'cryptpasswd'],
              joiner: ':',
              separator: ':',
              block_eval: :instance do
                def to_line(record)
                  if record[:name]
                    "# Puppet Name: #{record[:name]}\n"
                  else
                    ''
                  end + "#{record[:username]}:#{record[:realm]}:#{record[:cryptpasswd]}"
                end
              end

  def self.prefetch_hook(records)
    name = nil
    records = records.each do |record|
      case record[:record_type]
      when :comment
        if record[:name]
          name = record[:name]
          record[:skip] = true
        end
      else
        record[:name] = name
      end
    end
    records.reject { |record| record[:skip] }
  end
end
