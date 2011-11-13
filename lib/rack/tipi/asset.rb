require 'rack/mime'

module Rack
  module Tipi
    class Asset
      attr_reader :namespace, :path

      def initialize(namespace, path, route)
        @namespace = namespace
        @path = Pathname.new(path).expand_path
        @route = route.sub(/\//, '')
      end

      def ==(other)
        route == other.route if other.respond_to? :route
      end

      def content
        path.read
      end

      def mime_type
        Rack::Mime.mime_type(path.extname)
      end

      def route
        "/#{namespace}/#{@route}"
      end
    end
  end
end
