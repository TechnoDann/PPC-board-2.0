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
