require 'flexverb'

describe FlexVerb do

  it "parses integers" do

    parser = FlexVerb::Parser.new
    transform = FlexVerb::Transform.new    

    transform.apply(parser.parse("123")).eval.should == 123

  end

end
