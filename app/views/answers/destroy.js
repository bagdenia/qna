$('.delete_answer').bind('ajax:success', function() {  
        $(this).closest('tr').fadeOut();
}); 
