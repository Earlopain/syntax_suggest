# frozen_string_literal: true

module SyntaxSuggest
  # Lexes the whole source and wraps the tokens in `LexValue`.
  #
  # Example usage:
  #
  #   lex = LexAll.new(source: source)
  #   lex.each do |value|
  #     puts value.line
  #   end
  class LexAll
    include Enumerable

    def initialize(source:)
      @lex = self.class.lex(source, 1)
      @lex.map! { |token, _state|
        LexValue.new(token)
      }
    end

    def self.lex(source, line_number)
      lex = Prism.lex(source, line: line_number).value
      lex.sort_by! { |token, _state| token.location.start_line }
      lex
    end

    def to_a
      @lex
    end

    def each
      return @lex.each unless block_given?
      @lex.each do |x|
        yield x
      end
    end

    def [](index)
      @lex[index]
    end

    def last
      @lex.last
    end
  end
end

require_relative "lex_value"
