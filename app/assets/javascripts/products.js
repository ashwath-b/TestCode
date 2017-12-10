// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready(function() {
  $('input.cats_chbx').change(function () {
      alert('changed');
      $.get( "/public_view", function( data ) {
        // $( ".result" ).html( data );
        console.log('data');
        // alert( "Load was performed." );
      });
  });
});
