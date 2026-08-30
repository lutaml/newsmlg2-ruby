# frozen_string_literal: true

module Newsmlg2
  module Base
    # iCalendar RECUR-aligned attributes (events.py).
    module RecurrenceRuleAttributes
      def self.included(klass)
        klass.class_eval do
          xml_attributes(
            :freq, :interval, :until, :count,
            :bysecond, :byminute, :byhour, :byday,
            :bymonthday, :bymonth, :byyearday, :byweekno, :bysetpos, :wkst
          )
        end
      end
    end
  end
end
