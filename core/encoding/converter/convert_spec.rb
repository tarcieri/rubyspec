require File.dirname(__FILE__) + '/../../../spec_helper'

ruby_version_is "1.9" do
  describe "Encoding::Converter#convert" do
    it "returns a String" do
      ec = Encoding::Converter.new('ascii', 'utf-8')
      ec.convert('glark').should be_an_instance_of(String)
    end

    it "sets the encoding of the result to the target encoding" do
      ec = Encoding::Converter.new('ascii', 'utf-8')
      str = 'glark'.force_encoding('ascii')
      ec.convert(str).encoding.should == Encoding::UTF_8
    end

    it "transcodes the given String to the target encoding" do
      ec = Encoding::Converter.new("utf-8", "euc-jp")
      ec.convert("\u3042".force_encoding('UTF-8')).should == \
        "\xA4\xA2".force_encoding('EUC-JP')
    end

    it "allows Strings of different encodings to the source encoding" do
      ec = Encoding::Converter.new('ascii', 'utf-8')
      str = 'glark'.force_encoding('SJIS')
      ec.convert(str).encoding.should == Encoding::UTF_8
    end

    it "reuses the given encoding pair if called multiple times" do
      ec = Encoding::Converter.new('ascii', 'SJIS')
      ec.convert('a'.force_encoding('ASCII')).should == 'a'.force_encoding('SJIS')
      ec.convert('b'.force_encoding('ASCII')).should == 'b'.force_encoding('SJIS')
    end

    it "raises UndefinedConversionError if the String contains characters invalid for the target encoding" do
      ec = Encoding::Converter.new('UTF-8', Encoding.find('macCyrillic'))
      lambda { ec.convert("\u{6543}".force_encoding('UTF-8')) }.should \
        raise_error(Encoding::UndefinedConversionError)
    end
  end
end