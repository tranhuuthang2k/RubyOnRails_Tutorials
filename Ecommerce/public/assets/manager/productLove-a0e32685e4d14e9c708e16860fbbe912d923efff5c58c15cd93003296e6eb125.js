function productLove(options) {
  var module = this;
  var defaults = {
    template: {
      productLove: $("#product-love-template"),
    },
    api: {
      love: "/api/v1/love",
      unlove: "/api/v1/unlove",
      api_token: Cookies.get("api_token"),
    },
    data: {},
  };
  module.settings = $.extend({}, defaults, options);

  module.clickLove = function () {
    $(document).on("click", "#heart", function () {
      $(this).toggleClass("red");
      product_id = $(this).attr("product-id");
      $.ajax({
        url: module.settings.api.love,
        headers: {
          Authorization: "Bearer " + module.settings.api.api_token, //z9SNcLnCMHJUXdtzU0VBeQ
        },
        type: "POST",
        data: { token: module.settings.api.api_token, product_id },
        dataType: "json",
        success: function (data) {
          if (data.code == 200) {
            $(".product_love").html("");
            var template_product_love = Handlebars.compile(
              module.settings.template.productLove.html()
            );
            $(".product_love").append(
              template_product_love({
                productLove: data.data.product_favorite,
              })
            );
          } else {
            console.log("error");
          }
        },
        error: function () {},
      });
    });
  };
  module.unLove = function () {
    $(document).on("click", "#heart-red", function () {
      $(this).attr("id", "heart");
      product_id = $(this).attr("product-id");
      $.ajax({
        url: module.settings.api.unlove,
        headers: {
          Authorization: "Bearer " + module.settings.api.api_token, //z9SNcLnCMHJUXdtzU0VBeQ
        },
        type: "DELETE",
        data: { token: module.settings.api.api_token, product_id },
        dataType: "json",
        success: function (data) {
          if (data.code == 200) {
            // console.log("unlove success");
          } else {
            console.log("error");
          }
        },

        error: function () {},
      });
    });
  };

  module.init = function () {
    module.clickLove();
    module.unLove();
  };
}

$(document).ready(function () {
  p_love = new productLove();
  p_love.init();
});
