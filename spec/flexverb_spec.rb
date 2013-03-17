require 'flexverb'

describe FlexVerb do

  before do
    @parser = FlexVerb::Parser.new
    @transform = FlexVerb::Transform.new
  end

  it "parses integers" do
    parsed = @transform.apply(@parser.parse("123")).eval
    parsed.should == 123
  end

  it "recognizes quotes" do
    single = @transform.apply(@parser.parse("'"))
    single[:quote].should be_instance_of Parslet::Slice

    double = @transform.apply(@parser.parse("\""))
    double[:quote].should be_instance_of Parslet::Slice
  end

end
