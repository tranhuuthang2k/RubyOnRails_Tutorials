function Blog(options) {
    var module = this;
    var defaults = {
      template: {
        search: $("#list-search-blog-template"),
      },
      api: {
        search: "/api/v1/search_blog",
        api_token: Cookies.get("api_token"),
      },
      data: {},
    };
    module.settings = $.extend({}, defaults, options);
    module.searchBlog = function () {
      $(".in-search-blog").keypress(function (e) {
        if (event.keyCode == 13) {
          search = $(this).val();
          $.ajax({
            url: module.settings.api.search,
            headers: {
              Authorization: "Bearer " //z9SNcLnCMHJUXdtzU0VBeQ
            },
            type: "POST",
            data: {
              search,
            },
            dataType: "json",
            success: function (data) {
              if (data.code == 200) {
                  console.log(data);
                var template_search = Handlebars.compile(
                    module.settings.template.search.html()
                  );
                $(".list-post").html("");
                $(".list-post").append(
                  template_search({
                    blogs: data.data.blogs,
                    keyword: search,
                  })
                );
              } else {
                console.log("error");
              }
            },
            error: function () {},
          });
        }
      });
    };
    check_i18n = function () {
      return true
        ? window.location.pathname.substr(
            window.location.pathname.indexOf("/en"),
            (2, 3)
          ) === "/en"
        : false;
    };
  

    module.init = function () {
      module.searchBlog();
    };
  }
  
  $(document).ready(function () {
    blog = new Blog();
    blog.init();
  });
  
