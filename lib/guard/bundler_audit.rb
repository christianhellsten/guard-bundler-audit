require 'guard'
require 'guard/guard'
require 'bundler/audit'
require 'bundler/audit/scanner'

module Guard
  class BundlerAudit < Guard
    #
    # Guard callback
    #
    def start
      ::Bundler::Audit::Database.update!
    end

    #
    # Guard callback
    #
    def run_all
      audit
    end

    #
    # Guard callback
    #
    def run_on_changes paths
      audit
    end

    private

    #
    # Scans for vulnerabilities and reports them.
    #
    def audit
      res = ::Bundler::Audit::Scanner.new.scan.to_a.map do |vuln|
        case vuln
        when ::Bundler::Audit::Scanner::InsecureSource
          insecure_source_message vuln
        when ::Bundler::Audit::Scanner::UnpatchedGem
          insecure_gem_message vuln
        else
          insecure_message vuln
        end
      end
      if res.any?
        message = "Vulnerabilities found:\n" + res.join("\n")
        notify message
        fail message
      end
    end

    def notify message
      ::Guard::Notifier.notify(message, title: message, image: :pending)
    end

    def insecure_message vuln
      "Vulnerability found: #{vuln.name}"
    end

    def insecure_source_message vuln
      "Insecure source URI found: #{vuln.source}"
    end

    def insecure_gem_message vuln
      "Insecure gem found: #{vuln.gem} #{vuln.advisory} #{vuln.advisory.url}"
    end
  end
end
