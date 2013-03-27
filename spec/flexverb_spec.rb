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
    it "executes a method" do
      abstract_syntax_tree = [{:verb => "print"}, {:direct_object => '"hello world"'}]
      interpreter = FlexVerb::Interpreter.new(abstract_syntax_tree)

      Kernel.should_receive(:puts).with "hello world"
      interpreter.interpret
    end

    it "ignores word order" do
      abstract_syntax_tree = [{:direct_object => '"hello world"'}, {:verb => "print"}]
      interpreter = FlexVerb::Interpreter.new(abstract_syntax_tree)

      Kernel.should_receive(:puts).with "hello world"
      interpreter.interpret
    end
  end

end

