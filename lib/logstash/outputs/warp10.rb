#
#   Copyright 2016  Cityzen Data
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#     http:#www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#

# encoding: utf-8

require 'logstash/namespace'
require 'logstash/outputs/base'
require 'logstash/json'
require 'stud/buffer'
require 'openssl'

# This output lets you output Metrics to Warp10
# config_name "warp10"
# The configuration here attempts to be as friendly as possible
# and minimize the need for multiple definitions to write
# multiple series and still be efficient
#
class LogStash::Outputs::Warp < LogStash::Outputs::Base
  include Stud::Buffer

  config_name 'warp10'

  # The URL address to reach your Warp application
  config :warp_uri, validate: :string, required: true

  # The write token credential of your application
  config :token, validate: :string, required: true

  # The given name of your gts
  config :gts_name, validate: :string, default: 'logstash', required: true

  # List of log's key word to put as gts labels
  # Example: `['label0' , 'label1']`
  config :labels, validate: :array, default: [], required: true

  # Boolean true to keep only one field as value of the entire log
  config :only_one_value, validate: %w[true false], default: 'false', required: true

  # The key oy the value to keep if onlyMessage is to true
  config :value_key, validate: :string, default: 'message'

  # This setting controls how many events will be buffered before sending a batch
  # of events. Note that these are only batched for the same series
  config :flush_size, validate: :number, default: 300

  # The amount of time since last flush before a flush is forced.
  #
  # This setting helps ensure slow event rates don't get stuck in Logstash.
  # For example, if your `flush_size` is 100, and you have received 10 events,
  # and it has been more than `idle_flush_time` seconds since the last flush,
  # logstash will flush those 10 events automatically.
  #
  # This helps keep both fast and slow log streams moving along in
  # near-real-time.
  config :idle_flush_time, validate: :number, default: 2

  def to_boolean(str)
    str == 'true'
  end

  def register
    require 'ftw' # gem ftw
    require 'cgi'
    require 'uri'
    require 'net/http'
    require 'net/https'
    require 'json'
    @queue = []
    @is_only_message = to_boolean(@only_one_value)

    buffer_initialize(
      max_items: @flush_size,
      max_interval: @idle_flush_time,
      logger: @logger
    )
  end # def register

  def receive(event)
    data_points = JSON.parse(event.to_json)
    tags = 'source=logstash'
    labels.each do |label|
      tags += ',' + label + '=' + data_points[label]
    end
    gts_name = @gts_name
    gts_time = (event.timestamp.to_f * 1_000_000.0).to_i
    gts_value = if @is_only_message
                  data_points[value_key]
                else
                  event.to_s
                end
    fix = "'"
    res = gts_time.to_s + '// ' + gts_name.to_s + '{' + tags + '} ' + fix + gts_value + fix + "\n"
    buffer_receive(res)
  end # def receive

  def flush(events, _teardown = false)
    collect_string = ''
    events.each do |ev|
      collect_string += ev
    end
    https.use_ssl = true
    uri = URI.parse(warp_uri)
    flow = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Post.new(uri.path, initheader = { 'X-Warp10-Token' => token, 'Content-Type' => 'text/plain' })
    body = collect_string.encode('iso-8859-1').force_encoding('utf-8')
    flow.request(req, body)
  end # def flush

  def close
    buffer_flush(final: true)
  end
end # class LogStash::Outputs::Warp
