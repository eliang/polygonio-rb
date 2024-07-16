# frozen_string_literal: true

require "test_helper"

class OptionsTest < Minitest::Test
  def setup
    @client = Polygonio::Rest::Client.new(api_key)
  end

  def test_contract
    VCR.use_cassette("options_contract") do
      res = @client.options.contract("SPY251219C00650000")
      assert_equal 650, res.results.strike_price
    end
  end

  def test_daily_open_close
    VCR.use_cassette("options_daily_open_close") do
      ticker = 'SPY251219C00650000'
      res = @client.options.daily_open_close(ticker, '2024-07-15')
      assert_equal ticker, res.symbol.gsub('O:', '')
    end
  end

  def test_aggregates
    VCR.use_cassette("options_aggregates") do
      ticker = 'SPY251219C00650000'
      res = @client.options.aggregates(ticker, 1, :day, "2024-07-01", "2024-07-05")
      assert_equal 2, res.results_count
    end
  end
end
