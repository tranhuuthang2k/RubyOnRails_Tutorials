function Category(options) {
  var module = this;
  var defaults = {
    template: {
      category: $("#list-category-tempale"),
      comment: $("#list-comment-template"),
      rate: $("#list-rate-template"),
      edit_comment: $("#list-edit-comment-template"),
    },
    api: {
      category: "/api/v1/category",
      comment: "/api/v1/comment",
      edit_comment: "/api/v1/edit-comment",
      delete_comment: "/api/v1/delete-comment",
      rate: "/api/v1/rate",
      token: Cookies.get("authozition"),
      api_token: Cookies.get("api_token"),
    },
    data: {},
  };
  module.settings = $.extend({}, defaults, options);

  module.clickshowcategory = function () {
    $(".category").on("click", function () {
      $("div.list-category").hide();
      el = $(this).closest("div .categories");
      el.find("div.list-category").show();
    });
  };

  module.clickCategory = function () {
    $(".category").on("click", function () {
      el = $(this);
      ele = $(this).closest("div .categories");
      categories_id = $(el).closest("div .panel-heading").attr("id");
      $.ajax({
        url: module.settings.api.category,
        headers: {
          Authorization: "Bearer " + module.settings.api.token,
        },
        type: "get",
        data: { categories_id: categories_id },
        dataType: "json",
        success: function (data) {
          if (data.code == 200) {
            $(".list-category").html("");
            var template_category = Handlebars.compile(
              module.settings.template.category.html()
            );
            $(ele)
              .find(".list-category")
              .append(
                template_category({
                  categories: data.data.categories,
                })
              );
          }
        },
      });
    });
  };
  module.clickEventComments = function () {
    $(".in-comment").keypress(function (e) {
      if (event.keyCode == 13) {
        ele = $(this).closest("div #reviews");
        comment = $(ele).find(".in-comment").val();
        product_id = $(ele).find(".comments").attr("id");
        check_login = $(ele).find(".login").attr("id");
        if (check_login == 1) {
          $.ajax({
            url: module.settings.api.comment,
            headers: {
              Authorization: "Bearer " + module.settings.api.api_token,
            },
            type: "POST",
            data: {
              comment: comment,
              product_id: product_id,
              token: module.settings.api.api_token
            },
            dataType: "json",
            success: function (data) {
              if (data.code == 200) {
                var template_comment = Handlebars.compile(
                  module.settings.template.comment.html()
                );
                $(ele)
                  .find(".list-comment")
                  .append(
                    template_comment({
                      comment: data.data.comment,
                      name: data.data.name,
                      avatar: data.data.avatar,
                    })
                  );
                $(ele).find(".in-comment").val("");
              } else {
                console.log("error");
              }
            },
            error: function () {},
          });
        } else {
          Swal.fire({
            icon: "warning",
            title: "Please to login before Comment!",
          }).then(()=>{
            window.location="/login"
          });
        }
      }
    });
  };

  module.clickRateProduct = function () {
    $(".fa-star").click(function () {
      rate = $(this).attr("id").split("-")[1];
      ele = $(this).closest("div .check");
      product_id = parseInt($(ele).find(".id").attr("id"));
      check_login = $(ele).find(".login").attr("id");
      check_rate = $(ele).find("#check_rate").val();
      if (check_login == 1) {
        if (check_rate == 0) {
          $.ajax({
            url: module.settings.api.rate,
            headers: {
              Authorization: "Bearer " + module.settings.api.api_token,
            },
            type: "POST",
            data: {
              rate: rate,
              product_id: product_id,
              token: module.settings.api.api_token,
            },
            dataType: "json",
            success: function (data) {
              if (data.code == 200) {
                $(".list-rate").html("");
                var template_rate = Handlebars.compile(
                  module.settings.template.rate.html()
                );
                $(ele)
                  .find(".list-rate")
                  .append(
                    template_rate({
                      avg: data.data.avg,
                    })
                  );
                Swal.fire({
                  icon: "success",
                  title: "Rate successfully..",
                }).then(() => {
                  window.location.reload(true);
                });
              } else {
                Swal.fire({
                  icon: "error",
                  title: data.message,
                });
              }
            },
            error: function () {},
          });
        } else {
          Swal.fire({
            icon: "warning",
            title: "You have already rated this product",
          });
        }
      } else {
        Swal.fire({
          icon: "warning",
          title: "You must be logged in to rate!",
        });
      }
    });
  };

  module.hoverRateProduct = function () {
    $(".fa-star").hover(
      function () {
        $(this).prevAll().andSelf().addClass("checked");
      },
      function () {
        $(this).prevAll().andSelf().removeClass("checked");
      }
    );
  };

  module.clickeditComment = function () {
    $(document).on("click", ".edit-comment", function () {
      console.log("1");
      ele = $(this).closest(".comments");
      $(".in-comment-edit").hide();
      $(".list-edit-comment").show();
      $(ele).find(".in-comment-edit").show();
      $(ele).find(".list-edit-comment").hide();
    });
  };

  module.editComment = function () {
    $(document).on("keypress", ".in-comment-edit", function (e) {
      console.log("1");
      if (event.keyCode == 13) {
        ele = $(this).closest("div .comments");
        comment = $(ele).find(".in-comment-edit").val();
        comment_id = $(ele).find(".edit-comment").attr("id").split("-")[1];
        $.ajax({
          url: module.settings.api.edit_comment,
          headers: {
            Authorization: "Bearer " + module.settings.api.api_token,
          },
          type: "POST",
          data: {
            comment: comment,
            comment_id: comment_id,
            token: module.settings.api.api_token,
          },
          dataType: "json",
          success: function (data) {
            if (data.code == 200) {
              var template_edit_comment = Handlebars.compile(
                module.settings.template.edit_comment.html()
              );
              $(ele)
                .find(".list-edit-comment")
                .html(
                  template_edit_comment({
                    comment: data.data.comment,
                  })
                );
              $(ele).find(".list-edit-comment").show();
              $(ele).find(".in-comment-edit").hide();
              module.clickeditComment();
              module.editComment();
            } else {
              console.log("error");
            }
          },
          error: function () {},
        });
      }
    });
  };

  module.deleteComment = function () {
    $(document).on("click", ".delete-comment", function () {
      ele = $(this).closest(".delete_comment");
      comment_id = $(ele).find(".edit-comment").attr("id").split("-")[1];
      console.log(comment_id);
      $.ajax({
        url: module.settings.api.delete_comment,
        headers: {
          Authorization: "Bearer " + module.settings.api.api_token,
        },
        type: "delete",
        data: { comment_id: comment_id, token: module.settings.api.api_token },
        dataType: "json",
        success: function (data) {
          if (data.code == 200) {
            // alert("Delete comment successfully..");
            $(ele).html("");
            module.deleteComment();
          } else {
            console.log("error");
          }
        },
        error: function () {},
      });
    });
  };
  module.init = function () {
    module.clickshowcategory();
    module.clickCategory();
    module.clickEventComments();
    module.clickRateProduct();
    module.hoverRateProduct();
    module.editComment();
    module.clickeditComment();
    module.deleteComment();
  };
}
$(document).ready(function () {
  category = new Category();
  category.init();
});
