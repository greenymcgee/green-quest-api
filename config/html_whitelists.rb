class HTMLWhitelists
  def self.html_elements_whitelist
    Rails::Html::WhiteListSanitizer.allowed_tags +
      %w[
        font
        br
        p
        div
        span
        table
        tr
        td
        th
        tbody
        thead
        tfoot
        a
        b
        i
        em
        strong
        small
        img
        ul
        ol
        li
        dl
        dt
        dd
        pre
        code
        h1
        h2
        h3
        h4
        h5
        h6
        hr
      ].freeze
  end

  def self.html_attributes_whitelist
    Rails::Html::WhiteListSanitizer.allowed_attributes +
      %w[
        style
        color
        href
        src
        width
        height
        colspan
        rowspan
        cellspacing
        cellpadding
        border
      ].freeze
  end
end
