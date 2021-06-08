# encoding: utf-8
require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

# This file is generated by the Ruby Holiday gem.
#
# Definitions loaded: definitions/sg.yaml
class SgDefinitionTests < Test::Unit::TestCase  # :nodoc:

  def test_sg
    assert_equal "New Year's Day", (Holidays.on(Date.civil(2014, 1, 1), [:sg], [:informal])[0] || {})[:name]

    assert_equal "Valentine's Day", (Holidays.on(Date.civil(2014, 2, 14), [:sg], [:informal])[0] || {})[:name]

    assert_equal "Total Defence Day", (Holidays.on(Date.civil(2014, 2, 15), [:sg], [:informal])[0] || {})[:name]

    assert_equal "Good Friday", (Holidays.on(Date.civil(2014, 4, 18), [:sg], [:informal])[0] || {})[:name]

    assert_equal "Labour Day", (Holidays.on(Date.civil(2014, 5, 1), [:sg], [:informal])[0] || {})[:name]

    assert_equal "National Day", (Holidays.on(Date.civil(2014, 8, 9), [:sg], [:informal])[0] || {})[:name]

    assert_equal "Christmas Day", (Holidays.on(Date.civil(2014, 12, 25), [:sg], [:informal])[0] || {})[:name]

  end
end