require 'rubygems'
require 'parslet'

module FlexVerb
  class Parser < Parslet::Parser

    rule :expression do
      match('[0-9]').repeat(1).as(:integer)
    end

    root :expression

  end

  class IntegerLiteral < Struct.new(:integer)
    def eval
      integer.to_i
    end
  end

  class Transform < Parslet::Transform
    rule(:integer => simple(:integer)) { IntegerLiteral.new(integer) }
  end
end

