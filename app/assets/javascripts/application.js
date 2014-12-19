// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap.min
//= require retina
//= require pnotify.min
//= require jquery.tagsinput
//= require chosen.jquery.min
//= require bootstrap-editable.min
//= require typeahead.bundle.min
//= require handlebars-v1.3.0
//= require_tree .

$.fn.editable.defaults.mode = 'inline';
$.fn.editable.defaults.ajaxOptions = {type: "PATCH"};

(function () {
    $(function () {
        return $("[data-xeditable=true]").each(function () {
            return $(this).editable({
                ajaxOptions: {
                    type: "PATCH",
                    dataType: "json"
                },
                params: function (params) {
                    var railsParams;
                    railsParams = {};
                    railsParams[$(this).data("model")] = {};
                    railsParams[$(this).data("model")][params.name] = params.value;
                    return railsParams;
                }
            });
        });
    });
}).call();
