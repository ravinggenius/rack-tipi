require_relative '../../test_helper'

require 'pathname'
require 'rack/tipi/asset'

class AssetTest < TestHelper
  def setup
    @dir = File.join(File.dirname(__FILE__), '../../test_files')
    @asset_css = Rack::Tipi::Asset.new(:woot, File.join(@dir, '/stylesheet.css'), '/stylesheet.css')
    @asset_js = Rack::Tipi::Asset.new(:woot, File.join(@dir, 'javascript.js'), 'javascript.js')
  end

  def test_equalequal
    assert_operator @asset_css, :==, Rack::Tipi::Asset.new(:woot, File.join(@dir, '/stylesheet.css'), '/stylesheet.css')
    assert_operator @asset_js, :==, Rack::Tipi::Asset.new(:woot, File.join(@dir, 'javascript.js'), 'javascript.js')
    assert_operator @asset_js, :!=, nil
  end

  def test_content
    assert_equal "/* sample CSS file */\n", @asset_css.content
    assert_equal "// sample JavaScript file\n", @asset_js.content
  end

  def test_mime_type
    assert_equal 'text/css', @asset_css.mime_type
    assert_equal 'application/javascript', @asset_js.mime_type
  end

  def test_namespace
    assert_equal :woot, @asset_css.namespace
    assert_equal :woot, @asset_js.namespace
  end

  def test_path
    root = Pathname.new(__FILE__) + '..' + '..' + '..' + 'test_files'
    assert_equal (root + 'stylesheet.css'), @asset_css.path
    assert_equal (root + 'javascript.js'), @asset_js.path
  end

  def test_route
    assert_equal '/woot/stylesheet.css', @asset_css.route
    assert_equal '/woot/javascript.js', @asset_js.route
  end
end
