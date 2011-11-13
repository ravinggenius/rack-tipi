require_relative '../../test_helper'

require 'pathname'
require 'rack/tipi/assets'

class AssetsTest < TestHelper
  def setup
    @asset_root = Pathname.new(__FILE__) + '..' + '..' + '..' + 'test_files'
    @app = lambda { |env| [ 200, { 'Content-Type' => 'text/plain' }, ['testing...'] ] }
    @assets = Rack::Tipi::Assets.new(@app, :tipi_root => '/assets')
  end

  def teardown
    Rack::Tipi::Assets.instance_variable_set('@resources', []) if Rack::Tipi::Assets.resources.count > 0
  end

  def add_script
    Rack::Tipi::Assets.register(:woot, (@asset_root + 'javascript.js'), 'javascript.js')
  end

  def add_style
    Rack::Tipi::Assets.register(:woot, (@asset_root + 'stylesheet.css'), 'stylesheet.css')
  end

  def test_call
    add_script
    add_style

    assert_equal ['testing...'], @assets.call('REQUEST_PATH' => '/').last
    assert_equal ["/* sample CSS file */\n"], @assets.call('REQUEST_PATH' => '/assets/woot/stylesheet.css').last
    assert_equal ["// sample JavaScript file\n"], @assets.call('REQUEST_PATH' => '/assets/woot/javascript.js').last
  end

  def test_resouces
    assert_equal 0, Rack::Tipi::Assets.resources.count

    add_script
    add_style

    assert_equal 2, Rack::Tipi::Assets.resources.count
  end

  def test_register
    assert_equal 0, Rack::Tipi::Assets.resources.count

    Rack::Tipi::Assets.register(:woot, (@asset_root + 'javascript.js'), 'javascript.js')
    assert_equal 1, Rack::Tipi::Assets.resources.count

    Rack::Tipi::Assets.register(:woot, (@asset_root + 'javascript.js'), 'javascript.js')
    assert_equal 1, Rack::Tipi::Assets.resources.count

    Rack::Tipi::Assets.register(:woot, (@asset_root + 'stylesheet.css'), 'stylesheet.css')
    assert_equal 2, Rack::Tipi::Assets.resources.count
  end
end
