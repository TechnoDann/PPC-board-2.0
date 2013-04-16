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
        error: (object, thing, text) ->
            $('#preview').html("<div class=\"alert alert-error\"> Preview failed.</div>")
    )

window.add_show_more_links = () ->
    $('.show-more-link').each () ->
        link_span = $(this)
        div = link_span.parent().children(".post-body")
#        console.log(div.height())
#        console.log(div.html())
        if div.height() > (14 * 10)
            div.data("oldHeight", div.height())
            div.height(14 * 10)
            div.css("overflow", "hidden")
            link_span.html("<br><a href=\"javascript:void(0)\">Expand this post &rarr;</a><br>")
            link_span.children("a").click (event) ->
                div.height(div.data("oldHeight"))
                div.css("overflow", "visible")
                link_span.html("")
                e.preventDefault()
                return false
