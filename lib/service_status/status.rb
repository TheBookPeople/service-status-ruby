require 'service_status/version'

require 'pp'
require 'net/http'
require 'uri'
require 'socket'
require 'sys/filesystem'

module ServiceStatus
  class Status
    attr_reader :name, :version, :hostname, :errors, :checks, :timestamp, :stats

    def initialize(name, version, boot_time)
      @boot_time = boot_time
      @name = name
      @version = version
      @hostname = Socket.gethostname
      @checks = []
      @timestamp = Time.now.strftime('%Y-%m-%d %T')
      @errors = []
      @stats = []
    end

    def add_check(name, ok)
      @checks << name
      @errors << name unless ok
    end

    def add_http_get_check(name, url)
      @checks << name
      uri = URI(url)
      begin
        res = Net::HTTP.get_response(uri)
        @errors << name unless res.is_a?(Net::HTTPSuccess)
      rescue
        @errors << name
      end
    end

    def add_stat(name, value, description = nil)
      if description
        @stats << { name: name, value: value, description: description }
      else
        @stats << { name: name, value: value }
      end
    end

    def status
      online? ? 'online' : 'offline'
    end

    def online?
      @errors.empty?
    end

    def uptime
      total_seconds = Time.now - @boot_time
      seconds = total_seconds % 60
      minutes = (total_seconds / 60) % 60
      hours = total_seconds / (60 * 60)
      days = total_seconds / (60 * 60 * 24)
      format('%01dd:%02d:%02d:%02d', days, hours, minutes, seconds)
    end

    def disk_usage
      format('%01d%%', (disk_used / disk_size) * 100)
    end

    # rubocop:disable MethodLength
    def to_json(*a)
      {
        name: name,
        version: version,
        hostname: hostname,
        errors: errors,
        stats: stats,
        checks: checks,
        timestamp: timestamp,
        uptime: uptime,
        diskusage: disk_usage,
        status: status
      }.to_json(*a)
    end

    private

    def disk_used
      disk_size - disk_available
    end

    def disk_available
      @blocks_available ||= filesystem.blocks_available.to_f
    end

    def disk_size
      @disk_size ||= filesystem.blocks.to_f
    end

    def filesystem
      @root_filesystem ||= Sys::Filesystem.stat('/')
    end
  end
end
