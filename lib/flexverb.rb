require 'rubygems'
require 'parslet'

module FlexVerb

  class Transform < Parslet::Transform
    rule(:string => simple(:string_contents)) do
      String(string_contents)
    end

    rule(:int => simple(:int)) do
      Integer(int)
    end

    rule(:direct_object => simple(:value)) do
      value
    end

    rule(:verb => simple(:verb)) do
      verb.to_sym
    end
  end

  module Interpreter
    class Interpreter
      def initialize(code)
        @terms = Parser.new.parse code
        @transform = Transform.new
        @environment = {:global_subject => GlobalSubject.new}
      end

      def interpret
        verb = extract_part_of_speech(:verb)
        direct_object = extract_part_of_speech(:direct_object)

        subject_name = begin
          extract_part_of_speech(:subject)
        rescue MissingPartOfSpeechError
          :global_subject
        end
        subject = @environment[subject_name]

        subject.send(verb, direct_object)
      end
 
      def extract_part_of_speech(name)
        term = @terms.detect {|hash| hash.has_key? name}
        raise MissingPartOfSpeechError.new(name) if term.nil?
        @transform.apply(term)
      end
    end

    class GlobalSubject
      def print(*args)
        Kernel.puts(*args)
      end
    end

    class MissingPartOfSpeechError < StandardError
      def initialize(missing_part_name)
        @missing_part_name = missing_part_name
      end
      def message
        "missing part of speech ‘#{@missing_part_name}’"
      end
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
      (term_close_quote.absent? >> any).repeat.as(:verb)
    end

    rule :the_actual_direct_object do
      (string | int).as(:direct_object)
    end
  
    rule :str_open_quote do
      str('"')
    end
  
    rule :str_close_quote do
      str('"')
    end
  
    rule :string do
      str_open_quote >> (str_close_quote.absent? >> any).repeat.as(:string) >> str_close_quote
    end

    rule :int do
      match('\d').repeat.as(:int)
    end

    rule :term_open_quote do
      str "("
    end

    rule :term_close_quote do
      str ")"
    end

    rule :verb do
      verb_marker >> term_open_quote >> the_actual_verb >> term_close_quote
    end

    rule :direct_object do
      direct_object_marker >> term_open_quote >> the_actual_direct_object >> term_close_quote
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

