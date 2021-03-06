# encoding: utf-8

module DataMapper
  module Model
    # @since 0.0.2
    # @example Post.paginate(page, order: [:updated_at.desc])
    def paginate(pagenum = 1, options = Hash.new)
      pagenum = 1 if pagenum.nil?
      page = self.page(pagenum.to_i, options)
      Page.current = page
      offset = page.number(:db) * page.per_page
      self.all(options.merge!(offset: offset, limit: page.per_page))
    end

    # @since 0.0.2
    def page(current, options = Hash.new)
      per_page = defined?(PER_PAGE) ? PER_PAGE : 10
      # the count options are very important
      # Product.count vs. Product.count(online: true)
      Page.new(current: current, count: self.count(options), per_page: per_page)
    end
  end
end
