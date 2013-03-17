require 'rubygems'
require 'parslet'

module FlexVerb
  class Parser < Parslet::Parser

    rule :quote do
      match('["\']').as(:quote)
    end

    rule :integer do
      match('[0-9]').repeat(1).as(:integer)
    end

    rule :expression do
      integer | quote
    end

    root :expression

  end

  class IntegerLiteral < Struct.new(:integer)
    def eval
      integer.to_i
    end
  end

  class Transform < Parslet::Transform
    rule(:integer => simple(:integer)) do
      IntegerLiteral.new(integer)
    end
  end
end

