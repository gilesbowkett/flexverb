require 'rubygems'
require 'parslet'

module FlexVerb

  class Transform < Parslet::Transform
    rule(:direct_object => simple(:slice)) do
      String(slice.to_s.gsub(/"/, ''))
    end

    rule(:verb => simple(:string)) do
      :puts
    end
  end

  class Interpreter
    def initialize(code)
      @terms = Parser.new.parse code
      @transform = Transform.new
    end

    def interpret
      verb = extract_part_of_speech(:verb)
      direct_object = extract_part_of_speech(:direct_object)
      Kernel.send(verb, direct_object)
    end

    def extract_part_of_speech(name)
      @transform.apply(@terms.detect {|hash| hash.has_key? name})
    end
  end

  class Parser < Parslet::Parser
    rule :verb_marker do
      (str "verb") | (str "v")
    end

    rule :direct_object_marker do
      (str "direct-object") | (str "o")
    end

    rule :the_actual_verb do
      (str(')').absent? >> any).repeat.as(:verb)
    end

    rule :the_actual_direct_object do
      (str(')').absent? >> any).repeat.as(:direct_object)
    end

    rule :open_quote do
      str "("
    end

    rule :close_quote do
      str ")"
    end

    rule :verb do
      verb_marker >> open_quote >> the_actual_verb >> close_quote
    end

    rule :direct_object do
      direct_object_marker >> open_quote >> the_actual_direct_object >> close_quote
    end

    rule :space do
      str " "
    end

    rule :term do
      verb | direct_object
    end

    rule :expression do
      space.repeat(0) >> term >> space.repeat(0) >> term.maybe >> space.repeat(0)
    end

    root :expression

    def parse(code)
      parsed = super(code)
      if 1 == parsed.keys.size
        parsed
      else
        parsed.collect do |key, value|
          {key => value}
        end
      end
    end
  end
end

