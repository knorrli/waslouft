# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "@easepick/bundle", to: "@easepick--bundle.js" # @1.2.1
pin_all_from "app/javascript/controllers", under: "controllers"
