#
# = Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
#
# Category::    Net
# Package::     Whois
# Author::      Simone Carletti <weppos@weppos.net>
# License::     MIT License
#
#--
#
#++


require 'whois/answer/parser/base'


module Whois
  class Answer
    class Parser

      #
      # = whois.nic.cz parser
      #
      # Parser for the whois.nic.cz server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisNicCz < Base

        property_supported :status do
          @status ||= if content_for_scanner =~ /status:\s+(.+)\n/
            case $1.downcase
              when "paid and in zone" then :registered
              else
                raise ParserError, "Unknown status `#{$1}'. " +
                      "Please report the issue at http://github.com/weppos/whois/issues"
            end
          else
            :available
          end
        end

        property_supported :available? do
          @available  ||= !!(content_for_scanner =~ /% No entries found/)
        end

        property_supported :registered? do
          @registered ||= !available?
        end


        property_supported :created_on do
          @created_on ||= if content_for_scanner =~ /registered:\s+(.*)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          @updated_on ||= if content_for_scanner =~ /changed:\s+(.*)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          @expires_on ||= if content_for_scanner =~ /expire:\s+(.*)\n/
            Time.parse($1)
          end
        end


        property_supported :nameservers do
          @nameservers ||= content_for_scanner.scan(/nserver:\s+(.+)\n/).flatten.map(&:strip)
        end

      end

    end
  end
end
