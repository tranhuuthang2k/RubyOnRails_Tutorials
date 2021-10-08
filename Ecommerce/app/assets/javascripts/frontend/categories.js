function Category(options) {
  var module = this;
  var defaults = {
    template: {
      category: $("#list-category-tempale"),
    },
    api: {
      category: "/api/v1/category",
      token: Cookies.get("authozition"),
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
  module.init = function () {
    module.clickshowcategory();
    module.clickCategory();
  };
}

$(document).ready(function () {
  category = new Category();
  category.init();
});
