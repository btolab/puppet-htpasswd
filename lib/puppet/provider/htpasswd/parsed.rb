require 'puppet/provider/parsedfile'
htpasswd_file = '/etc/httpd/conf/htpasswd'

Puppet::Type.type(:htpasswd).provide(
  :parsed,
  parent: Puppet::Provider::ParsedFile,
  default_target: htpasswd_file,
  filetype: :flat,
) do

  desc 'htpasswd provider that uses the ParsedFile class'

  text_line :blank, match: %r{^\s*$}
  text_line :comment,
            match:      %r{^#},
            post_parse: proc do |record|
              if record[:line] =~ %r{Puppet Name: (.+)\s*$}
                record[:name] = Regexp.last_match(1)
              end
            end
  record_line :parsed,
              fields:     ['username', 'cryptpasswd'],
              joiner:     ':',
              separator:  ':',
              block_eval: :instance do
                def to_line(record)
                  if record[:name]
                    "# Puppet Name: #{record[:name]}\n"
                  else
                    ''
                  end + "#{record[:username]}:#{record[:cryptpasswd]}"
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
