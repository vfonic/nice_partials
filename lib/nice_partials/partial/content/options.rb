class NicePartials::Partial::Content::Options
  class TokenList
    def initialize(view_context)
      @view_context, @content = view_context, +""
    end
    delegate :to_s, :to_str, to: :@content

    def <<(list)
      @content << " " << @view_context.token_list(list) and @content.strip! unless list.empty?
      self
    end
  end

  def initialize(view_context)
    @view_context = view_context
    @hash = Hash.new { |h,k| h[k] = TokenList.new(view_context) }
  end
  delegate :tag, :token_list, to: :@view_context
  delegate :to_h, :to_hash, to: :@hash

  def class_list(*arguments)
    @hash[:class] << arguments
  end

  def data(*arguments)
    @hash[:data] << arguments
  end

  def aria(*arguments)
    @hash[:aria] << arguments
  end

  def merge(**options)
    self.class.new(@view_context).merge!(**@hash).merge!(**options)
  end

  def merge!(**options)
    options[:class_list] = options.delete(:class)
    options.each { public_send(_1, _2) }
    self
  end

  def to_s
    tag.attributes(to_h)
  end
end
