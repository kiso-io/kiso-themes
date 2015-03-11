module FormattingHelper
  def code_block(&block)
    code = capture(&block)
    indent = code.scan(/^ +/).first.size

    code.gsub!(/^ {#{indent}}/, "")
    code.chomp!

    content_tag :pre, code, :class => "prettyprint linenums"
  end
end