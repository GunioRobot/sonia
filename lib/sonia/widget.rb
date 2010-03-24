require "yajl"

module Sonia
  class Widget
    attr_reader :channel, :sid, :config

    def self.encoder
      @encoder ||= Yajl::Encoder.new
    end
    
    def self.decoder
      @decoder ||= Yajl::Parser.new
    end

    def initialize(config)
      @channel = EM::Channel.new
      @config = config
    end

    def subscribe!(websocket)
      @sid = channel.subscribe { |msg| websocket.send msg }
    end

    def unsubscribe!
      channel.unsubscribe(sid)
    end

    def push(msg)
      payload = { "widget" => self.widget_name, "payload" => msg }

      channel.push self.class.encoder.encode({ "message" => payload })
    end
    
    def widget_name
      self.class.name.split("::").last
    end
  end
end