// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//= require handlebars
//= require_tree ./templates

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
require("trix")
require("@rails/actiontext")
import "../trix-editor-overrides"


Rails.start()
Turbolinks.start()
ActiveStorage.start()
window.Cookies = require("js-cookie")
window.Handlebars = require("handlebars")
require("trix")
require("@rails/actiontext")