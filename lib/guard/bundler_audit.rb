require 'guard'
require 'bundler/audit'
require 'guard/plugin'
require 'bundler/audit/scanner'

module Guard
  class BundlerAudit < Plugin #Guard
    #
    # Guard callback
    #
    def start
      ::Bundler::Audit::Database.update!
      audit
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
        color = :red
        notify message
      else
        message = "No vulnerabilities found."
        color = :green
      end
      UI.info(UI.send(:color, message, color))
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
