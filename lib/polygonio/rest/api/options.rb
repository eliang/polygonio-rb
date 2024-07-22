# frozen_string_literal: true

module Polygonio
  module Rest
    class Options < PolygonRestHandler
      class ContractResponse < PolygonResponse
        attribute :results do
          attribute :cfi, Types::String
          attribute :contract_type, Types::String
          attribute :exercise_style, Types::String
          attribute :expiration_date, Types::JSON::DateTime
          attribute :primary_exchange, Types::String
          attribute :shares_per_contract, Types::Integer
          attribute :strike_price, Types::JSON::Decimal
          attribute :ticker, Types::String
          attribute :underlying_ticker, Types::String
        end
      end

      def contract(ticker)
        ticker = Types::String[ticker]

        res = client.request.get("v3/reference/options/contracts/O:#{ticker}")

        ContractResponse[res.body]
      end

      class DailyOpenCloseResponse < PolygonResponse
        attribute :status, Types::String
        attribute :symbol, Types::String
        attribute :open, Types::JSON::Decimal
        attribute :high, Types::JSON::Decimal
        attribute :low, Types::JSON::Decimal
        attribute :close, Types::JSON::Decimal
        attribute :volume, Types::Integer
        attribute :after_hours, Types::JSON::Decimal
        attribute :from, Types::JSON::DateTime
      end

      def daily_open_close(symbol, date)
        symbol = Types::String[symbol]
        date = Types::JSON::Date[date]

        res = client.request.get("/v1/open-close/O:#{symbol}/#{date}")
        DailyOpenCloseResponse[res.body]
      end

      class AggregatesResponse < PolygonResponse
        attribute :ticker, Types::String
        attribute :status, Types::String
        attribute :adjusted, Types::Bool
        attribute :query_count, Types::Integer
        attribute :results_count, Types::Integer
        attribute :results, Types::Array.default([].freeze) do
          attribute? :T, Types::String # Not appearing
          attribute :v, Types::JSON::Decimal
          attribute? :vw, Types::JSON::Decimal
          attribute :o, Types::JSON::Decimal
          attribute :c, Types::JSON::Decimal
          attribute :h, Types::JSON::Decimal
          attribute :l, Types::JSON::Decimal
          attribute :t, Types::Integer
          attribute? :n, Types::Integer
        end
      end

      def aggregates(ticker, multiplier, timespan, from, to, unadjusted = false) # rubocop:disable Metrics/ParameterLists
        ticker = Types::String[ticker]
        multiplier = Types::Integer[multiplier]
        timespan = Types::Coercible::String.enum("minute", "hour", "day", "week", "month", "quarter", "year")[timespan]
        from = Types::JSON::Date[from]
        to = Types::JSON::Date[to]
        unadjusted = Types::Bool[unadjusted]

        res = client.request.get("/v2/aggs/ticker/O:#{ticker}/range/#{multiplier}/#{timespan}/#{from}/#{to}",
                                 { unadjusted: unadjusted })
        AggregatesResponse[res.body]
      end
    end
  end
end
