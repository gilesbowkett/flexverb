require 'flexverb'

describe FlexVerb do
  let(:xform) { FlexVerb::Transform.new }

  it "transforms a direct object" do
    expect(xform.apply(:direct_object => '"hello world"')).to eq('hello world')
  end

  it "transforms a verb" do
    expect(xform.apply(:verb => 'print')).to eq(:puts)
  end

  it "executes a method" do
    interpreter = FlexVerb::Interpreter.new
    abstract_syntax_tree = {:verb => "print", :direct_object => '"hello world"'}

    Kernel.should_receive(:puts).with "hello world"
    interpreter.interpret(abstract_syntax_tree)
  end
end

