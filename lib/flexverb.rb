require 'rubygems'
require 'parslet'

module FlexVerb
  class Transform < Parslet::Transform
    rule(:direct_object => simple(:string)) do
      String(string.gsub(/"/, ''))
    end

    rule(:verb => simple(:string)) do
      :puts
    end
  end

  class Interpreter
    def interpret(code)
      verb, direct_object = code.collect {|term| Transform.new.apply(term)}
      Kernel.send(verb, direct_object)
    end
  end
end

