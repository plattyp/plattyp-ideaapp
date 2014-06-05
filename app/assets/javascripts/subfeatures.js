  $(function(){
       $('.toggleSubfeatureList').click(function(){
           $('#subfeature_list_div').toggle(true);
           $('#subfeature_create_div').toggle(false);
           $('.toggleSubfeatureList')
       });
   });

  function toggle() {
    var link = document.getElementById("linkText");
    var create = document.getElementById("toggleCreate");
    var list = document.getElementById("toggleList");
    if(list.style.display == "block") {
          list.style.display = "none";
          create.style.display = "block";
          link.innerHTML = "Show all Subfeatures";
      }
    else {
          list.style.display = "block";
          create.style.display = "none";
          link.innerHTML = "Add a Subfeature";
  }
  }