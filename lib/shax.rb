class Shax
  attr_accessor :xml, :root

  class Node
    attr_accessor :tag, :parent, :val, :kids

    def initialize(tag=nil, parent=nil, val=nil)
      @tag    = tag
      @parent = parent
      @val    = val
      @kids   = []
    end
  end

  Tags = %r`
    <(/?[-\w:.]+)                          # 1: tag (loose, but probably ok)
    ([^>]+)?>                              # 2: atts
    ((?:<!\[CDATA\[[\s\S]*?\]\]>|[^<]+)+)? # 3: text
  `mx

  Atts = %r`
    ([-\w:.]+)\s*=\s* # 1: name
    (['"])            # 2: quote
    ([\s\S]*?)\2      # 3: value
  `x

  Data = %r`
    <!\[CDATA\[([\s\S]*?)\]\]>
  `x

  def self.load(str)
    new(str).convert
  end

  def self.load!(str, deep=4)
    (+load(str))[['*'] * deep * '/']
  end

  def self.show(obj, lev=0)
    min = '  ' * (lev + 0)
    pre = '  ' * (lev + 1)
    puts "{" if lev == 0
    case obj
    when Hash
      obj.each do |k, v|
        case v
        when Hash
          puts "#{pre}#{k.inspect} => {"
          show(v, lev + 1)
          puts "#{pre}},"
        when Array
          puts "#{pre}#{k.inspect} => ["
          show(v, lev + 2)
          puts "#{pre}],"
        else
          puts "#{pre}#{k.inspect} => #{v.inspect},"
        end
      end
    when Array
      obj.each do |v|
        case v
        when Hash
          puts "#{pre}{"
          show(v, lev + 1)
          puts "#{pre}},"
        when Array
          abort "ERROR: arrays of arrays not yet supported"
        else
          puts "#{min}#{v.inspect},"
        end
      end
    end
    puts "}" if lev == 0
  end

  def initialize(xml)
    @xml  = xml
    @root = parse xml
  end

  def parse(str)
    node = root = Node.new "!xml"
    tags = []; str.scan(Tags).each {|hits| tags.push(hits)}
    skip = nil

    tags.each_with_index do |(tag, atts, text), i|
      next if i == skip

      # closing tag
      if tag[0] == '/'
        node = node.parent

      # create baby
      else
        node.kids.push(baby = Node.new(tag, node))
        # baby.atts = @parse_atts atts if atts? # if config.atts

        # self-closing tag
        if atts && atts[-1] == '/'
          baby.val = ''

        # text node
        elsif ((skip = i + 1) < tags.size) and tags[skip][0] == "/#{tag}"
          # baby.val = @value text?...
          # baby.val = !text ? '' : text.scan(Data).each {|hits| hits[0]}
          baby.val = text

        # starting tag
        else
          node = baby
          skip = nil
        end
      end
    end
    root
  end

  def parse_atts(str)
    if str and (str = str.strip!).length > 3
      atts = {}
      str.scan(Atts).each {|hits| atts["#{skip_ns(hits[1])}"] = value hits[3]}
      atts
    end
  end

  def skip_ns(str)
    return str unless str.include?(':')
    pre = str[0] == '/' ? '/' : ''
    pre = str.split(':', 2)[-1]
  end

  def value(str)
    return '' unless str
    return '' + str # if isNan str ???
    return str.to_f if str.include? '.'
    return str.to_i
  end

  def convert(node=@root)
    return node.val if node.val
    out = {}
    for kid in node.kids
      obj = convert kid
      tag = kid.tag
      tag = skip_ns tag
      if out.key?(tag)
        val = out[tag]
        out[tag] = [val] unless val.is_a?(Array)
        out[tag].push obj
      else
        out[tag] = obj
      end
    end
    out
  end
end
