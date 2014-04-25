require 'guard'
require 'guard/guard'
require 'bundler/audit'
require 'bundler/audit/scanner'

module Guard
  class BundlerAudit < Guard
    def start
      Bundler::Audit::Database.update!
    end

    def run_all
      audit
    end

    def run_on_changes paths
      audit
    end

    def audit
      res = Bundler::Audit::Scanner.new.scan.to_a.map do |vuln|
        case vuln
        when Bundler::Audit::Scanner::InsecureSource
          "Insecure source URI found: #{vuln.source}"
        when Bundler::Audit::Scanner::UnpatchedGem
          "Insecure gem found: #{vuln.gem} #{vuln.advisory}"
        end
      end
      if res.any?
        message = res.join("\n")
        notify message
        fail message
      end
    end

    def notify message
      ::Guard::Notifier.notify(message, title: message, :image => :pending)
    end
  end
end
