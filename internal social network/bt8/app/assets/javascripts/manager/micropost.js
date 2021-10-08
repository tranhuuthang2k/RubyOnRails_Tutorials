function Micropost(options) {
    var module = this;
    var defaults = {
      template: {},
      api: {},
      data: {}
    };
    module.settings = $.extend({}, defaults, options);
  
    module.search = function(){
       
      $('.btn_search').on('click', function(){
        content = $('.content').val();
        location.href = "/microposts?content=" + content
      });
    };
  
  
    module.init = function(){
      module.search();
    };
  
  }
  
  $(document).ready(function(){ 
    micropost = new Micropost;
    micropost.init();
  });
  