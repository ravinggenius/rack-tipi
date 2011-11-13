require 'rack/tipi/asset'

module Rack
  module Tipi
    class Assets
      attr_reader :app, :tipi_root

      def initialize(app, options)
        @app = app
        @tipi_root = options[:tipi_root]
      end

      def call(env)
        asset = self.class.resources.detect do |a|
          "#{tipi_root}#{a.route}" == env['REQUEST_PATH']
        end

        if asset
          [ 200, { 'Content-Type' => asset.mime_type }, [ asset.content ] ]
        else
          app.call(env)
        end
      end

      def self.resources
        @resources || []
      end

      def self.register(namespace, path, route)
        asset = Asset.new(namespace, path, route)
        (@resources ||= []) << asset unless resources.include? asset
      end
    end
  end
end
