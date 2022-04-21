function Product(options) {
  var module = this;
  var defaults = {
    template: {
      product: $("#list-product-template"),
      search: $("#list-search-template"),
      more_products: $("#list-more-product-template"),
    },
    api: {
      product: "/api/v1/product",
      search: "/api/v1/search",
      delete_order: "/api/v1/delete_order",
      load_more_product: "/api/v1/load_more_product",
      api_token: Cookies.get("api_token"),
    },
    data: {},
  };
  module.settings = $.extend({}, defaults, options);
  module.searchProduct = function () {
    $(".in-search").keypress(function (e) {
      if (event.keyCode == 13) {
        search = $(this).val();
        $.ajax({
          url: module.settings.api.search,
          headers: {
            Authorization: "Bearer " + module.settings.api.api_token, //z9SNcLnCMHJUXdtzU0VBeQ
          },
          type: "POST",
          data: {
            token: module.settings.api.api_token,
            search,
          },
          dataType: "json",
          success: function (data) {
            if (data.code == 200) {
              $(".padding-right").html("");
              $("#cart_items").html("");
              $("#do_action").html("");
              var template_search = Handlebars.compile(
                module.settings.template.search.html()
              );
              $(".padding-right").append(
                template_search({
                  products: data.data.products,
                  keyword: search,
                })
              );
              $("#cart_items").append(
                template_search({
                  products: data.data.products,
                  keyword: search,
                })
              );
              $("html, body").animate(
                {
                  scrollTop: $(".features_items").offset().top,
                },
                1000
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

  module.Productofmonth = function () {
    $("#submit")
      .off()
      .on("click", function () {
        var date = new Date($("#start").val());
        var month = date.getMonth() + 1;
        var year = date.getFullYear();
        $.ajax({
          url: module.settings.api.product,
          headers: {
            Authorization: "Bearer " + module.settings.api.api_token, //z9SNcLnCMHJUXdtzU0VBeQ
          },
          type: "POST",
          data: {
            token: module.settings.api.api_token,
            month,
            year,
          },
          dataType: "json",
          success: function (data) {
            if (data.code == 200) {
              $(".tbody").html("");
              let total_order_of_month = data.data.carts_order.reduce(
                (total, item) => total + item.total,
                0
              );
              if (data.data.carts_order.length > 0) {
                $(".total_order_of_month").css("display", "block");
                if (check_i18n()) {
                  $(".total_order_of_month").get(0).innerText =
                    "Total money order (include fee ship & voucher code ) of month is " +
                    "$" +
                    parseFloat(
                      total_order_of_month + parseFloat(data.data.fee_ship)
                    );
                } else {
                  $(".total_order_of_month").get(0).innerText =
                    "Tổng tiền đặt hàng (bao gồm phí ship & mã giảm giá) trong tháng là " +
                    "$" +
                    parseFloat(
                      total_order_of_month + parseFloat(data.data.fee_ship)
                    );
                }
              } else {
                $(".total_order_of_month").css("display", "none");
              }

              var template_product = Handlebars.compile(
                module.settings.template.product.html()
              );
              $(".tbody").append(
                template_product({
                  product_of_month: data.data.product_of_month,
                  carts_order: data.data.carts_order,
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

  module.CancelOrder = function () {
    $(".submit_delete")
      .off()
      .on("click", function () {
        product_id = $(this).attr("product_id");
        order_id = $(this).attr("order_id");
        size_product = $(this)
          .parent()
          .parent()
          .find(".size_product")
          .find("p")
          .get(0).innerText;
        $.ajax({
          url: module.settings.api.delete_order,
          headers: {
            Authorization: "Bearer " + module.settings.api.api_token, //z9SNcLnCMHJUXdtzU0VBeQ
          },
          type: "POST",
          data: {
            token: module.settings.api.api_token,
            product_id,
            order_id,
            size_product,
          },
          dataType: "json",
          success: function (data) {
            if (data.code == 200) {
              window.location = check_i18n()
                ? "/en/users/orders"
                : "/vi/users/orders";
            } else {
              Swal.fire({
                icon: "error",
                title: check_i18n()
                  ? data.message
                  : "Đơn hàng của bạn đã xác nhận, không thể hủy",
              }).then(() => {
                window.location = check_i18n()
                  ? "/en/users/orders"
                  : "/vi/users/orders";
              });
            }
          },
          error: function () {},
        });
      });
  };

  module.LoadMore = function () {
    var current_page = 2;

    $(".load_more")
      .off()
      .on("click", function () {
        $(".load_more").css("display", "none");
        $("#load").css("display", "block");

        $.ajax({
          url:
            module.settings.api.load_more_product + "?page=" + current_page++,
          headers: {
            Authorization: "Bearer " + module.settings.api.api_token, //z9SNcLnCMHJUXdtzU0VBeQ
          },
          type: "GET",
          dataType: "json",
          success: function (data) {
            if (data.code == 200) {
              var template_products = Handlebars.compile(
                module.settings.template.more_products.html()
              );

              $(".features_items").append(
                template_products({
                  products: data.data.products,
                })
              );
            }
            $(".load_more").css("display", "block");
            $("#load").css("display", "none");
            if (data.data.products.length == 0) {
              $(".load_more").css("display", "none");
            }
          },
          error: function () {},
        });
      });
    module.LoadMore();
  };

  module.init = function () {
    module.searchProduct();
    module.Productofmonth();
    module.CancelOrder();
    module.LoadMore();
  };
}

$(document).ready(function () {
  product = new Product();
  product.init();
});
