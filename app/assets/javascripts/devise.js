  //This function runs after the page has loaded to check onclick changes
  window.onload = function () { document.getElementById('user_join_group_checkbox').onclick=change; }

  //Adding Javascript to show Organization Input on sign-up checkbox
  function change(){
  var details_div = document.getElementById('join_organization');
     if(this.checked) {
       details_div.style['display'] = 'block';
     } else {
       details_div.style['display'] = 'none';
     }
  };