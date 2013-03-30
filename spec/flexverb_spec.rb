require 'flexverb'

describe FlexVerb do
  before do
    @transform = FlexVerb::Transform.new
  end

  context "Transform" do
    it "transforms a direct object" do
      expect(@transform.apply(:direct_object => '"hello world"')).to eq('hello world')
    end

    it "transforms a verb" do
      expect(@transform.apply(:verb => 'print')).to eq(:puts)
    end
  end

  context "Interpreter" do
    def interpret(code)
      FlexVerb::Interpreter.new(code).interpret
    end

    it "executes a method" do
      code = 'verb(print) direct-object("hello world")'
      Kernel.should_receive(:puts).with "hello world"
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
        @terms = [{:verb => "print"},
                  {:direct_object => '"hello world"'}]
      end

      it "parses" do
        code = 'verb(print) direct-object("hello world")'
        expect(parse(code)).to eq(@terms)
      end

      it "allows arbitrary white space" do
        code = '      verb(print)     direct-object("hello world")    '
        expect(parse(code)).to eq(@terms)
      end

      it "still parses if the code is 'reversed'" do
        code = 'direct-object("hello world") verb(print)'
        expect(parse(code)).to eq(@terms.reverse!)
      end
    end

    it "recognizes a verb" do
      code = 'verb(print)'
      term = {:verb => 'print'}
      expect(parse(code)).to eq(term)
    end

    it "recognizes a direct object" do
      code = 'direct-object("hello world")'
      term = {:direct_object => '"hello world"'}
      expect(parse(code)).to eq(term)
    end

    it "recognizes terse part-of-speech markers" do
      expect(parse('v(print)')).to eq(:verb => 'print')
      expect(parse('o("hello world")')).to eq(:direct_object => '"hello world"')
    end
  end

end

