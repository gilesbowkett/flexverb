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
      xform = Transform.new
      verb = xform.apply(code.detect {|hash| hash.has_key? :verb})
      direct_object = xform.apply(code.detect {|hash| hash.has_key? :direct_object})
      Kernel.send(verb, direct_object)
    end

  end
end

