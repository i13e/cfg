;; [[file:config.org::*String inflection][String inflection:1]]
(package! string-inflection :pin "fd7926ac17293e9124b31f706a4e8f38f6a9b855")
;; String inflection:1 ends here

;; [[file:config.org::*Info colours][Info colours:1]]
(package! info-colors :pin "47ee73cc19b1049eef32c9f3e264ea7ef2aaf8a5")
;; Info colours:1 ends here

;; [[file:config.org::*Modus themes][Modus themes:1]]
(package! modus-themes :pin "392ebb115b07f8052d512ec847619387d109edd6")
;; Modus themes:1 ends here

;; [[file:config.org::*Prettier page breaks][Prettier page breaks:1]]
(package! page-break-lines :recipe (:host github :repo "purcell/page-break-lines"))
;; Prettier page breaks:1 ends here

;; [[file:config.org::*Spray][Spray:1]]
(package! spray :pin "74d9dcfa2e8b38f96a43de9ab0eb13364300cb46")
;; Spray:1 ends here

;; [[file:config.org::*Elcord][Elcord:1]]
(package! elcord :pin "64545671174f9ae307c0bd0aa9f1304d04236421")
;; Elcord:1 ends here

;; [[file:config.org::*Systemd][Systemd:1]]
(package! systemd :pin "b6ae63a236605b1c5e1069f7d3afe06ae32a7bae")
;; Systemd:1 ends here

;; [[file:config.org::*Ebooks][Ebooks:1]]
(package! calibredb :pin "cb93563d0ec9e0c653210bc574f9546d1e7db437")
;; Ebooks:1 ends here

;; [[file:config.org::*Ebooks][Ebooks:2]]
(package! nov :pin "b3c7cc28e95fe25ce7b443e5f49e2e45360944a3")
;; Ebooks:2 ends here

(package! org-pretty-table
  :recipe (:host github :repo "Fuco1/org-pretty-table") :pin "87772a9469d91770f87bfa788580fca69b9e697a")

(package! org-appear :recipe (:host github :repo "awth13/org-appear")
  :pin "148aa124901ae598f69320e3dcada6325cdc2cf0")

(package! org-ol-tree :recipe (:host github :repo "Townk/org-ol-tree")
  :pin "207c748aa5fea8626be619e8c55bdb1c16118c25")

(package! ob-julia :recipe (:local-repo "lisp/ob-julia" :files ("*.el" "julia")))

(package! ob-http :pin "b1428ea2a63bcb510e7382a1bf5fe82b19c104a7")

(package! org-transclusion :recipe (:host github :repo "nobiot/org-transclusion")
  :pin "8cbbade1e3237200c2140741f39ff60176e703e7")

(package! org-graph-view :recipe (:host github :repo "alphapapa/org-graph-view") :pin "13314338d70d2c19511efccc491bed3ca0758170")

(package! org-chef :pin "a97232b4706869ecae16a1352487a99bc3cf97af")

(package! citar :pin "a6926650114a8091f98bff8c7fd00add82043190")
(package! citeproc :pin "38e70c0a94eeefe86ddefc38dfa8ab2311008774")
(package! org-cite-csl-activate :recipe (:host github :repo "andras-simonyi/org-cite-csl-activate") :pin "8f49ccbd337edda01e52da0c75f6a76e2cc976f7")

(package! org-super-agenda :pin "a5557ea4f51571ee9def3cd9a1ab1c38f1a27af7")

(package! doct
  :recipe (:host github :repo "progfolio/doct")
  :pin "67fc46c8a68989b932bce879fbaa62c6a2456a1f")

(package! org-roam :disable t)

(package! org-roam-ui :recipe (:host github :repo "org-roam/org-roam-ui" :files ("*.el" "out")) :pin "cd1aefd56f648d32a25aae672ac1ab90893c0133")
(package! websocket :pin "fda4455333309545c0787a79d73c19ddbeb57980") ; dependency of `org-roam-ui'

;; (package! org-pretty-tags :pin "5c7521651b35ae9a7d3add4a66ae8cc176ae1c76")

(package! ox-gfm :pin "99f93011b069e02b37c9660b8fcb45dab086a07f")

;; [[file:config.org::*Graphviz][Graphviz:1]]
(package! graphviz-dot-mode :pin "3642a0a5f41a80c8ecef7c6143d514200b80e194")
;; Graphviz:1 ends here

;; [[file:config.org::*Beancount][Beancount:1]]
(package! beancount :recipe (:host github :repo "beancount/beancount-mode")
  :pin "ea8257881b7e276e8d170d724e3b2e179f25cb77")
;; Beancount:1 ends here
