#!/usr/bin/env ruby
# frozen_string_literal: false
#
# DESCRIPTION:
#   Takes host + port combination and checks cluster status from patroni's
#   REST API. So far only single master + multiple replicas are expected.
#   Feel free to add more logic with pull requests
#
# OUTPUT:
#   plain text
#
# PLATFORMS:
#   Linux
#
# DEPENDENCIES:
#   gem: sensu-plugin
#   gem: json
#
# USAGE:
#   ./check-patroni-cluster.rb [-h HOST] [-p PORT] [--lag-warn NUM] [--lag-crit NUM] [-t SECS]
#
# NOTES:
#   Based on check-http-json from sensu-plugins/sensu-plugins-http
#
# LICENSE:
#   Copyright 2021 Jan Michalek <VeselaHouba@googlegroups.com>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugin/check/cli'
require 'json'
require 'net/http'
require 'net/https'

class CheckPatroni < Sensu::Plugin::Check::CLI
  option :url, short: '-u URL'
  option :host, short: '-h HOST', default: 'localhost'
  option :port, short: '-P PORT', proc: proc(&:to_i), default: 8008
  option :lagwarn, long: '--lag-warn LAG', default: 1024
  option :lagcrit, long: '--lag-crit LAG', default: 10240
  option :timeout, short: '-t SECS', proc: proc(&:to_i), default: 15

  def run
    cluster = get_data("/cluster")
    # puts cluster
    crit = 0
    warn = 0
    message = stats = ""

    # loop through members to get leader timeline
    ltimeline = get_leader_timeline(cluster)

    cluster['members'].each do |member|
      stats += member['name']+", "+member['role']+", tl: "+member['timeline'].to_s
      case member['role']
      when "replica"
        if member['lag'] > config[:lagwarn]
          stats += "Lag for "+member['name']+" over "+config[:lagwarn].to_s+"\n"
          warn += 1
        end
        if member['lag'] > config[:lagcrit]
          message += "Lag for "+member['name']+" over "+config[:lagcrit].to_s+"\n"
          crit += 1
        end
        if member['timeline'] != ltimeline
          message += "Timeline for "+member['name']+" does not match leader\n"
          crit += 1
        end
        stats +=", lag: "+member['lag'].to_s+"\n"
      when "leader"
        stats +="\n"
      end
    end
    critical message + stats if crit > 0
    warning message + stats if warn > 0
    ok stats
  end

  def get_leader_timeline(cluster)
    cluster['members'].each do |member|
      return member['timeline'] if member['role'] == 'leader'
    end
    critical "Cluster has no leader"
  end

  def get_data(resource)
    begin
      Timeout.timeout(config[:timeout]) do
        return acquire_resource(resource)
      end
    rescue Timeout::Error
      critical 'Connection timed out'
    rescue StandardError => e
      critical "Connection error: #{e.message}"
    end
  end

  def json_valid?(str)
    ::JSON.parse(str)
    true
  rescue ::JSON::ParserError
    false
  end

  def acquire_resource(path)
    http = Net::HTTP.new(config[:host], config[:port])
    req = Net::HTTP::Get.new([path, config[:query]].compact.join('?'))
    res = http.request(req)

    critical 'invalid JSON from request' unless json_valid?(res.body)

    json = ::JSON.parse(res.body)
    return json
  end
end
