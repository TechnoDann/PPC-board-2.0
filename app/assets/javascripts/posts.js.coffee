# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.preview = () ->
    $.ajax("/posts/preview",
        type: 'POST',
        data: $('#post-change-form').serialize(),
        dataType: 'html'
        success: (html) ->
            $('#preview').html(html)
            $('#preview-accordion').collapse('hide').collapse('show')
            instrument_spoiler_tags()
            document.location.hash = "#preview-accordion"
        error: (object, thing, text) ->
            $('#preview').html("<div class=\"alert alert-error\"> Preview failed.</div>")
    )

window.add_show_more_links = () ->
    $('.show-more-link').each () ->
        link_span = $(this)
        div = link_span.parent().children(".post-body")
        if (div.height() > (14 * 10) && div.attr("data-show-more-state") != "expanded")\
          || div.attr("data-show-more-state") == "unexpanded"
            div.height(14 * 10)
            div.css("overflow", "hidden")
            div.attr("data-show-more-state", "unexpanded")
            link_span.html("<br><a href=\"javascript:void(0)\">Expand this post &rarr;</a><br>")
            link_span.children("a").click (event) ->
                div.height("auto")
                div.css("overflow", "visible")
                div.attr("data-show-more-state", "expanded")
                link_span.html("")
                event.preventDefault()
                return false
    if location.hash
      location.hash = location.hash

window.instrument_spoiler_tags = () ->
    $('a[href="#s"]').attr("data-turbolinks", "false")

$(document).on("turbolinks:load", () -> add_show_more_links(); instrument_spoiler_tags())
