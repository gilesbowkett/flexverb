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
    def initialize(code)
      @code = code
      @transform = Transform.new
    end

    def interpret
      verb = extract_part_of_speech(:verb)
      direct_object = extract_part_of_speech(:direct_object)
      Kernel.send(verb, direct_object)
    end

    def extract_part_of_speech(name)
      @transform.apply(@code.detect {|hash| hash.has_key? name})
    end
  end

  class Parser < Parslet::Parser
    rule :verb_marker do
      str "verb"
    end

    rule :anything do
      (str "print").as :verb
    end

    rule :open_quote do
      str "("
    end

    rule :close_quote do
      str ")"
    end

    rule :verb do
      verb_marker >> open_quote >> anything >> close_quote
    end

    root :verb
  end
end

