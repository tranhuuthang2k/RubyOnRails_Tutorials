function Post(options) {
    var module = this;
    var defaults = {
      template: {
        'comment' : $('#list-comment-template'),
        'friend'  : $('#story-micro-template')
      },
        api: {
          'comment': 'api/v1/comment',
          'friends': 'api/v1/users/friends',
          'token': $.cookie('api_token'),
        },
        data: {}
      };
    module.settings = $.extend({}, defaults, options);
  
    module.clickPost = function(){
        var modal = document.getElementById("myModal");
        // Get the button that opens the modal
        var btn = document.getElementById("myBtn");
        // Get the <span> element that closes the modal
        var span = document.getElementsByClassName("close")[0];
        // When the user clicks the button, open the modal 
        btn.onclick = function() {
          modal.style.display = "block";
        }
        // When the user clicks on <span> (x), close the modal
        span.onclick = function() {
          modal.style.display = "none";
        }
        // When the user clicks anywhere outside of the modal, close it
        window.onclick = function(event) {
          if (event.target == modal) {
            modal.style.display = "none";
          }
        }
      };
      module.addComment = function(){
        $('.btn-addcomment').on('click', function(){
          el = $(this).closest('li').find('.user-comment');
          if ($(el).css('display') == 'none'){
            $(el).css({ 'display': 'block' })
          }else{
            $(el).css({ 'display': 'none' })
          }
        });
      };
      module.enterComment = function(){
  
        $( ".btn-donecomment").click(function() {
          comment = $(this).parent().find("#formControlDefault").val()
          post_id = $(this).closest('li').attr('id').split('-')[1];
          el = $(this).closest('li').find('.user-comment');
          $.ajax({
            url: module.settings.api.comment,
            headers: {
              'Api-Token': module.settings.api.token  //z9SNcLnCMHJUXdtzU0VBeQ
            },
            type: 'POST',
            data: { comment: comment, post_id: post_id },
            dataType: 'json',
            success: function(data) {
              if (data.code == 200) {
                var template_comment = Handlebars.compile(module.settings.template.comment.html());
                $('.list-comment').append(template_comment({
                  avatar: data.data.avatar,
                  comment: data.data.comment,
                }));
                $(el).val("");
                $(el).css({ 'display': 'none' })
              } else {
                console.log("error")
              }
            },
            error: function() {}
          });
        }
        );
      }


      module.viewShowComments = function(){
        $( ".view-comments").click(function() {
          el = $(this).closest('li').find('#show_comments');
          $(el).css({ 'display': 'block' })
          $(this).css({'display': 'none'})
        }
        );
      }
      module.nextFriends = function(){
        $( ".next").click(function() {
          page = parseInt ($(this).parent().find('.story').attr('id').split('-')[1])
          $.ajax({
            url: module.settings.api.friends,
            headers: {
              'Api-Token': module.settings.api.token  //z9SNcLnCMHJUXdtzU0VBeQ
            },
            type: 'GET',
            data: { page: page},
            dataType: 'json',
            success: function(data) {
              if (data.code == 200) {
                console.log('ok')
                var template_friend = Handlebars.compile(module.settings.template.friend.html());
                console.log(module.settings.template.friend.html())
                $(".story").html("");
                $('.story').append(template_friend({
                  users: data.data.users,
                }));
                next_page = data.data.next_page
                total_pages = data.data.total_pages
                console.log(next_page)
                if (next_page > total_pages){
                  next_page = 1;
                }
                $(".story").attr("id",'page-'+ next_page);


              } else {
                console.log("error")
              }
            },
            error: function() {}
          });
        }
        );
      }
    module.init = function(){
      module.clickPost();
      module.addComment();
      module.enterComment();
      module.viewShowComments()
      module.nextFriends();
    };
  
  }
  
  $(document).ready(function(){ 
    post = new Post;
    post.init();
  });
  