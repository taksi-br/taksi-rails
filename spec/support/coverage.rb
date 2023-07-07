# frozen_string_literal: true

if ENV['COVERAGE'] == 'true'
  require 'simplecov'
  require 'simplecov-cobertura'

  SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter

  SimpleCov.start('rails') do
    add_filter '/spec/'
    enable_coverage :branch
  end
end
