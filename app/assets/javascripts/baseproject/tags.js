// #####################################
// TAGS #27/03/2013 @manu
// #####################################

// Tags control
$('li.bp-tags-field .bp-add-tag a').live('click', function(){
    var li          = $(this).closest('.bp-tags-field'),
        input_field = $('.bp-input-field', li),
        form_field  = $('.bp-tags-form-field input', li),
        tags_list   = $('.bp-tags-list',li),
        tags_array  = input_field.val().split(",");

    for (var i = 0; i < tags_array.length; i++) {
        var tag = $.trim(tags_array[i]);
        if (tag != '' && $.inArray(tag, form_field.val().split(',')) == -1) {
            tags_list.append('<li style="display:none"><span>'+ tag +'</span><b>X</b></li>');
            bp_update_tags(li);
            $('li:last',tags_list).fadeIn();
        }
    }
    input_field.val('');

    return false;
});

// Delete tag
$('li.bp-tags-field b').live('click', function (){
    var li  = $(this).closest('.bp-tags-field'),
        tag = $(this).closest('li');

    tag.fadeOut(function () {
        tag.remove();
        bp_update_tags(li);
    });
    return false;
});

// Update Tags
function bp_update_tags(li) {
    var form_field  = $('.bp-tags-form-field input', li),
        tags_list   = $('.bp-tags-list li span',li),
        out = Array();

    for (var i=0; i < tags_list.length; i++) {
        out[i] = tags_list[i].innerHTML;
    }
    form_field.val(out.join(","));
}

// End Tags
// =============================================================================