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
      # = whois.cira.ca parser
      #
      # Parser for the whois.cira.ca server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisCiraCa < Base

        property_supported :status do
          @status ||= if content_for_scanner =~ /Domain status:\s+(.*?)\n/
            case $1.downcase
              when "exist"  then :registered
              when "avail"  then :available
              else
                raise ParserError, "Unknown status `#{$1}'. " +
                      "Please report the issue at http://github.com/weppos/whois/issues"
            end
          end
        end

        property_supported :available? do
          @available  ||= (status == :available)
        end

        property_supported :registered? do
          @registered ||= !available?
        end


        property_supported :created_on do
          @created_on ||= if content_for_scanner =~ /Approval date:\s+(.*?)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          @updated_on ||= if content_for_scanner =~ /Updated date:\s+(.*?)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          @expires_on ||= if content_for_scanner =~ /Renewal date:\s+(.*?)\n/
            Time.parse($1)
          end
        end


        property_supported :registrar do
          @registrar ||= if content_for_scanner =~ /^Registrar:\n(.*\n?)^\n/m
            match = $1
            id    = match =~ /Number:\s+(.*)$/ ? $1.strip : nil
            name  = match =~ /Name:\s+(.*)$/   ? $1.strip : nil
            Whois::Answer::Registrar.new(:id => id, :name => name, :organization => name)
          end
        end


        property_supported :nameservers do
          @nameservers ||= if content_for_scanner =~ /Name servers:\n((?:\s+([^\s]+)\s+([^\s]+)\n)+)/
            $1.split("\n").map { |value| value.split(" ").first }
          else
            []
          end
        end

      end

    end
  end
end
