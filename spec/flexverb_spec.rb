require 'flexverb'

describe FlexVerb do

  context "Transform" do
    it "transforms a direct object" do
      xform = FlexVerb::Transform.new
      expect(xform.apply(:direct_object => '"hello world"')).to eq('hello world')
    end

    it "transforms a verb" do
      xform = FlexVerb::Transform.new
      expect(xform.apply(:verb => 'print')).to eq(:puts)
    end
  end

  context "Interpreter" do
    def interpret(abstract_syntax_tree)
      FlexVerb::Interpreter.new(abstract_syntax_tree).interpret
    end

    # the variable terms here would normally be called ast or
    # abstract_syntax_tree. however, a programmer with a pretty
    # significant academic history in linguistics and formal semantics
    # told me that people who speak languages in which word order is
    # optional or immaterial actually construct ordered versions of
    # unordered sentences in real time, and that he knows this because
    # studies have been able to identify the precise amount of real time
    # in specific observations of speakers of specific free-word-order
    # languages. and in the same way, where a parser would normally
    # return an abstract syntax tree, we're actually just dealing with
    # a list of tagged terms. the list is in fact ordered, because Ruby
    # Arrays are ordered, and I didn't feel like switching to Sets just
    # to be pedantic, but the point is that the Transform itself will
    # construct an AST from the list.
    it "executes a method" do
      terms = [{:verb => "print"}, {:direct_object => '"hello world"'}]

      Kernel.should_receive(:puts).with "hello world"
      interpret(terms)
    end

    it "ignores word order" do
      terms = [{:direct_object => '"hello world"'}, {:verb => "print"}]

      Kernel.should_receive(:puts).with "hello world"
      interpret(terms)
    end
  end

  context "Parser" do
    def parse(code)
      FlexVerb::Parser.new.parse(code)
    end

    it "parses a complete line of code" do
      pending
      # verb(print) object("hello world").
      # parse('verb(print) direct-object("hello world")').should eq
    end

    it "recognizes a verb" do
      expect(parse('verb(print)')).to eq(:verb => 'print')
    end

    it "recognizes a direct object" do
      expect(parse('direct-object("hello world")')).to eq(:direct_object => '"hello world"')
    end

    it "ignores term position"

    it "recognizes terse part-of-speech markers" do
      expect(parse('v(print)')).to eq(:verb => 'print')
      expect(parse('o("hello world")')).to eq(:direct_object => '"hello world"')
    end
  end

end

