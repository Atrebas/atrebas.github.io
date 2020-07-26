$(document).ready(function(){
    $('#hideshow').on('click', function(event) {        
         console.log("click");
         $('pre').not('.r, .python').toggle('show');
         if (this.value == "Show the outputs") this.value = "Hide the outputs";
         else this.value = "Show the outputs";
    });
});
