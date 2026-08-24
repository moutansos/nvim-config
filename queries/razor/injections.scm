; inherits: c_sharp

([
  (html_comment)
  (razor_comment)
] @injection.content
  (#set! injection.language "comment"))

; Razor parses markup bodies as ERROR nodes, which HTML needs to receive.
((element) @injection.content
  (#set! injection.language "html")
  (#set! injection.combined)
  (#set! injection.include-children))
