# frozen_string_literal: true

module SyntaxSuggest
  # Value object for accessing lex values
  #
  # This lex:
  #
  #   [IDENTIFIER(1,0)-(1,8)("describe"), 32]
  #
  # Would translate into:
  #
  #  lex.location # => (1,0)-(1,8)
  #  lex.type # => :IDENTIFIER
  #  lex.token # => "describe"
  class LexValue
    attr_reader :location, :type, :token

    KW_TYPES = %i[
      KEYWORD_IF KEYWORD_UNLESS KEYWORD_WHILE KEYWORD_UNTIL
      KEYWORD_DEF KEYWORD_CASE KEYWORD_FOR KEYWORD_BEGIN KEYWORD_CLASS KEYWORD_MODULE KEYWORD_DO KEYWORD_DO_LOOP
    ].to_set.freeze
    private_constant :KW_TYPES

    def initialize(prism_token)
      @location = prism_token.location
      @type = prism_token.type
      @token = prism_token.value

      @is_kw = KW_TYPES.include?(@type)
      @is_end = @type == :KEYWORD_END
    end

    def line
      @location.start_line
    end

    def ignore_newline?
      @type == :IGNORED_NEWLINE
    end

    def is_end?
      @is_end
    end

    def is_kw?
      @is_kw
    end

    def expr_beg?
      false # FIXME
    end
  end
end
