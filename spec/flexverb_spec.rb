require 'flexverb'

describe FlexVerb do

  context "Transform" do
    it "transforms a direct object with a string" do
      xform = FlexVerb::Transform.new
      expect(xform.apply(:direct_object => {:string => 'hello world'})).to eq('hello world')
    end

    it "transforms a direct object with an int" do
      xform = FlexVerb::Transform.new
      expect(xform.apply(:direct_object => {:int => 42})).to eq(42)
    end

    it "transforms a verb" do
      xform = FlexVerb::Transform.new
      expect(xform.apply(:verb => 'print')).to eq(:puts)
    end
  end

  context "Interpreter" do
    def interpret(code)
      FlexVerb::Interpreter.new(code).interpret
    end

    it "executes a method with a string" do
      code = 'verb(print) direct-object("hello world")'
      Kernel.should_receive(:puts).with "hello world"
      interpret(code)
    end

    it "executes a method with an int" do
      code = 'verb(print) direct-object(42)'
      Kernel.should_receive(:puts).with 42
      interpret(code)
    end

    it "ignores term order" do
      code = 'direct-object("hello world") verb(print)'
      Kernel.should_receive(:puts).with "hello world"
      interpret(code)
    end
  end

  context "Parser" do
    def parse(code)
      FlexVerb::Parser.new.parse(code)
    end

    context "with a complete line of code" do
      before do
        @terms = [{:verb => "print"}, {:direct_object => {:string => 'hello world'}}]
      end

      it "parses" do
        code = 'verb(print) direct-object("hello world")'
        expect(parse(code)).to eq(@terms)
      end

      it "allows arbitrary white space" do
        code = '      verb(print)     direct-object("hello world")    '
        expect(parse(code)).to eq(@terms)
      end

      it "ignores term position" do
        code = 'direct-object("hello world") verb(print)'
        expect(parse(code)).to eq(@terms.reverse)
      end
    end

    it "recognizes a verb" do
      expect(parse('verb(print)')).to eq(:verb => 'print')
    end

    it "recognizes a direct object" do
      code = 'direct-object("hello world")'
      term = {:direct_object => {:string => 'hello world'}}
      expect(parse(code)).to eq(term)
    end

    it "recognizes terse part-of-speech markers" do
      expect(parse('v(print)')).to eq(:verb => 'print')
      expect(parse('o("hello world")')).to eq(:direct_object => {:string => 'hello world'})
    end

    it "recognizes an integer literal" do
      code = 'direct-object(42)'
      term = {:direct_object => {:int => '42'}}
      expect(parse(code)).to eq(term)
    end
  end

end

