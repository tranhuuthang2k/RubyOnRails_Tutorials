function Cart(options) {
  var module = this;
  let shipping = parseFloat($("option:selected").text().split("$").pop());
  var defaults = {
    template: {
      carts: $("#list-cart-template"),
    },
    api: {
      checkout: "/api/v1/checkout",
      checkout_with_momo: "/api/v1/checkout_with_momo",
      voucher: "/api/v1/voucher",
      api_token: Cookies.get("api_token"),
    },
    data: {},
  };
  module.settings = $.extend({}, defaults, options);
  setCart = function (val) {
    var shopping_cart = JSON.stringify(val);
    localStorage.setItem("carts", shopping_cart);
  };
  module.showBadegs = () => {
    shopping_carts = localStorage.getItem("carts")
      ? JSON.parse(localStorage.getItem("carts"))
      : [];
    $("#lblCartCount").get(0).innerText =
      shopping_carts?.length > 0 ? shopping_carts.length : "";
  };
  module.addToCart = function () {
    let shopping_carts = [];
    shopping_carts = localStorage.getItem("carts")
      ? JSON.parse(localStorage.getItem("carts"))
      : [];
    $(document).on("click", ".add-to-cart", function () {
      el = $(this).closest(".single-products");
      infoProduct = el.find(".productinfo");
      id_product = parseFloat(infoProduct.find(".id").attr("id"));
      name_product = infoProduct.find(".title").get(0).innerText;
      price_product = infoProduct
        .find(".price")
        .get(0)
        .innerText.replace("$", "");
      image_product =
        document.location.origin +
        infoProduct.find(".imageProduct").attr("src");
      product = shopping_carts.find((e) => e.id === id_product);
      if (product) {
        product.quantity++;
        product.total_price = product.quantity * parseFloat(price_product);
        setCart(shopping_carts);

        Swal.fire({
          position: "top-end",
          icon: "success",
          title: "Add to cart successfully",
          showConfirmButton: false,
          timer: 1500,
        });
        return shopping_carts;
      }
      shopping_cart = {
        id: id_product,
        name_product,
        size_product: "S",
        price_product,
        image_product,
        quantity: 1,
        total_price: parseFloat(price_product),
      };
      shopping_carts.push(shopping_cart);
      setCart(shopping_carts);
      $("#lblCartCount").get(0).innerText = shopping_carts.length;
      Swal.fire({
        position: "top-end",
        icon: "success",
        title: "Đã thêm sản phẩm vào giỏ hàng",
        showConfirmButton: false,
        timer: 1500,
      });
    });
  };
  getTotal = () => {
    let result = shopping_carts.reduce(
      (total, item) => total + (item.price_product * item.quantity * 100) / 100,
      0
    );
    return result
  };

  module.showCarts = function () {
    shopping_carts = localStorage.getItem("carts")
      ? JSON.parse(localStorage.getItem("carts"))
      : [];
    carts = JSON.parse(localStorage.getItem("carts"));
    if ($("#list-cart-template").length) {
      template_cart = Handlebars.compile(module.settings.template.carts.html());
      $(".tbody").append(
        template_cart({
          carts: carts,
        })
      );
      $(".Cart_Sub_Total").get(0).innerText = "$" + getTotal();
      carts?.length > 0
        ? $(".check_out").css("display", "block")
        : $(".check_out").css("display", "none");
      if (carts?.length) {
        if (isNaN(shipping)) {
          $(".totalOrder").parent().css("display", "none");
          $(".shipping-cost").css("display", "none");
        }
        $(".totalOrder").get(0).innerText =
          "$" + parseFloat(shipping + getTotal());
        $("#lblCartCount").get(0).innerText = shopping_carts.length;
        $(".price_shipping").get(0).innerText = "$" + shipping;
      }
    }
  };
  module.incrementCart = function () {
    $(".cart_quantity_up")
      .off()
      .on("click", function () {
        shopping_carts = localStorage.getItem("carts")
          ? JSON.parse(localStorage.getItem("carts"))
          : [];
        el = $(this).closest(".cart_quantity_button");
        quantityInput = parseFloat(el.find(".cart_quantity_input").val());
        quantityInput++;
        if (quantityInput > 30) {
          el.find(".cart_quantity_input").val(30);
        } else {
          price_product = $(this)
            .closest(".list-cart")
            .find(".cart_price")
            .get(0)
            .innerText.replace("$", "");
          elLiscart = $(this).closest(".list-cart").get(0);
          productId = parseFloat(el.parent().parent().attr("id"));
          product = shopping_carts.find((e) => e.id === productId);
          if (product) {
            totalCart = 0;
            product.quantity++;
            product.total_price = quantityInput * parseFloat(price_product);
            el.find(".cart_quantity_input").val(quantityInput);
            setCart(shopping_carts);
            $(".Cart_Sub_Total").get(0).innerText = "$" + getTotal();
            $(".price_shipping").get(0).innerText = "$" + shipping;

            $(".totalOrder").get(0).innerText =
              "$" + parseFloat(shipping + getTotal());

            $(elLiscart)
              .find(".cart_total")
              .find(".cart_total_price")
              .get(0).innerText =
              "$" + quantityInput * parseFloat(price_product);
            module.incrementCart();
            return shopping_carts;
          }
        }
      });
  };
  module.decrementCart = function () {
    $(".cart_quantity_down")
      .off()
      .on("click", function () {
        shopping_carts = localStorage.getItem("carts")
          ? JSON.parse(localStorage.getItem("carts"))
          : [];
        el = $(this).closest(".cart_quantity_button");
        quantityInput = parseFloat(el.find(".cart_quantity_input").val());
        price_product = $(this)
          .closest(".list-cart")
          .find(".cart_price")
          .get(0)
          .innerText.replace("$", "");
        elLiscart = $(this).closest(".list-cart").get(0);

        if (quantityInput < 2) {
          alert("so luong khong duoc nho hon 1");
          parseFloat(el.find(".cart_quantity_input").val(1));
          return;
        }
        quantityInput--;
        productId = parseFloat(el.parent().parent().attr("id"));
        product = shopping_carts.find((e) => e.id === productId);
        if (product) {
          totalCart = 0;
          product.quantity--;
          product.total_price = quantityInput * parseFloat(price_product);
          el.find(".cart_quantity_input").val(quantityInput);
          setCart(shopping_carts);
          $(".Cart_Sub_Total").get(0).innerText = "$" + getTotal();
          $(".price_shipping").get(0).innerText = "$" + shipping;
          $(".totalOrder").get(0).innerText =
            "$" + parseFloat(shipping + getTotal());
          $(elLiscart)
            .find(".cart_total")
            .find(".cart_total_price")
            .get(0).innerText = "$" + quantityInput * parseFloat(price_product);
          module.decrementCart();
          return shopping_carts;
        }
      });
  };
  module.handleQuantityInput = function () {
    $(".cart_quantity_input")
      .off()
      .on("input", function () {
        shopping_carts = localStorage.getItem("carts")
          ? JSON.parse(localStorage.getItem("carts"))
          : [];
        el = $(this).closest(".cart_quantity_button");
        quantityInput = el.find(".cart_quantity_input").val();
        productId = parseFloat(el.parent().parent().attr("id"));
        price_product = $(this)
          .closest(".list-cart")
          .find(".cart_price")
          .get(0)
          .innerText.replace("$", "");
        elLiscart = $(this).closest(".list-cart").get(0);
        if (quantityInput < 1) {
          el.find(".cart_quantity_input").val(1);
          product = shopping_carts.find((e) => e.id === productId);
          if (product) {
            product.quantity = 1;
            product.total_price = parseFloat(price_product);
            setCart(shopping_carts);
            $(".Cart_Sub_Total").get(0).innerText = "$" + getTotal();
            $(".totalOrder").get(0).innerText =
              "$" + parseFloat(shipping + getTotal());
            $(elLiscart)
              .find(".cart_total")
              .find(".cart_total_price")
              .get(0).innerText = "$" + parseFloat(price_product);
            return shopping_carts;
          }
        } else {
          product = shopping_carts.find((e) => e.id === productId);
          if (product) {
            el.find(".cart_quantity_input").val(quantityInput);
            product.quantity = quantityInput;
            product.total_price = quantityInput * parseFloat(price_product);
            setCart(shopping_carts);
            $(".Cart_Sub_Total").get(0).innerText = "$" + getTotal();
            $(".totalOrder").get(0).innerText =
              "$" + parseFloat(shipping + getTotal());
            $(elLiscart)
              .find(".cart_total")
              .find(".cart_total_price")
              .get(0).innerText =
              "$" + quantityInput * parseFloat(price_product);
            return shopping_carts;
          }
        }
      });
  };
  module.removeCart = function () {
    shopping_carts = localStorage.getItem("carts")
      ? JSON.parse(localStorage.getItem("carts"))
      : [];
    $(".cart_quantity_delete")
      .off()
      .on("click", function () {
        el = $(this).closest(".list-cart");
        productId = parseFloat(el.attr("id"));
        shopping_carts = shopping_carts.filter((e) => e.id !== productId);
        setCart(shopping_carts);
        $(el).remove();
        $("#lblCartCount").get(0).innerText =
          shopping_carts?.length > 0 ? shopping_carts.length : "";
        $(".Cart_Sub_Total").get(0).innerText = "$" + getTotal();
        $(".totalOrder").get(0).innerText =
          "$" + parseFloat(shipping + getTotal());
        module.removeCart();
        shopping_carts.length < 1 && module.showCarts();
      });
  };
  module.addToCartInDetail = function () {
    shopping_carts = localStorage.getItem("carts")
      ? JSON.parse(localStorage.getItem("carts"))
      : [];
    $(".add-to-cart-detail").click(function () {
      input = $("#numberInput").val();
      console.log(input);
      if (input < 0) {
        Swal.fire({
          icon: "warning",
          title: "Quantity  must be greater than 0",
        }).then((result) => {
          $("#numberInput").val(1);
        });
      } else {
        el = $(this).closest(".product-information");
        id_product = parseFloat(el.find(".id").attr("id"));
        name_product = el.find(".title").get(0).innerText;
        quantity_product_input = parseFloat(el.find(".quantity").val());
        price_product = el.find(".price").get(0).innerText.replace("US $", "");
        image_product =
          document.location.origin +
          el.closest(".product-details").find(".imageProduct").attr("src");
        size_product = $(".sprd-select__items")
          .find(".active")
          .get(0).innerText;

        if (isNaN(quantity_product_input)) {
          Swal.fire({
            icon: "warning",
            title: "Quantity must be number",
          });
          parseFloat(el.find(".quantity").val(1));
          return;
        }
        product = shopping_carts.find((e) => e.id === id_product);
        if (product) {
          (product.quantity += quantity_product_input),
            (product.total_price =
              product.quantity * parseFloat(price_product));
          setCart(shopping_carts);
          Swal.fire({
            position: "top-end",
            icon: "success",
            title: "Add to cart successfully..",
            showConfirmButton: false,
            timer: 1500,
          });

          return shopping_carts;
        }
        shopping_cart = {
          id: id_product,
          name_product,
          size_product,
          price_product,
          image_product,
          quantity: quantity_product_input,
          total_price: quantity_product_input * parseFloat(price_product),
        };
        shopping_carts.push(shopping_cart);
        setCart(shopping_carts);
        $("#lblCartCount").get(0).innerText = shopping_carts.length;
        Swal.fire({
          position: "top-end",
          icon: "success",
          title: "Add to cart successfully",
          showConfirmButton: false,
          timer: 1500,
        });
      }
    });
  };
  module.checkout = function () {
    shopping_carts = localStorage.getItem("carts")
      ? JSON.parse(localStorage.getItem("carts"))
      : [];
    $(".check_out").click(function () {
      voucher_code = $(".voucher_code").val().trim();
      method_shipping = parseFloat($("option:selected").val());
      $.ajax({
        url: module.settings.api.checkout,
        headers: {
          Authorization: "Bearer " + module.settings.api.api_token,
        },
        type: "POST",
        data: {
          token: module.settings.api.api_token,
          data: shopping_carts,
          voucher_code: voucher_code,
          method_shipping: method_shipping,
        },
        dataType: "json",
        success: function (data) {
          if (data.code == 200) {
            localStorage.clear();
            Swal.fire("Order Success!", "Order Success", "success").then(() => {
              window.location = "/users/orders";
            });
          } else {
            Swal.fire({
              icon: "error",
              title: "Shopping cart is invalid or Out of stock",
              text: "We remove your cart, then your order product another again, thank you!",
            }).then(() => {
              window.localStorage.removeItem("carts");
              window.location = "/users/carts";
            });
          }
        },
        error: function () {},
      });
    });
  };

  module.checkVoucher = function () {
    shopping_carts = localStorage.getItem("carts")
      ? JSON.parse(localStorage.getItem("carts"))
      : [];
    $(".voucher")
      .off()
      .on("click", function () {
        voucher_code = $(".voucher_code").val().trim();
        $.ajax({
          url: module.settings.api.voucher,
          headers: {
            Authorization: "Bearer " + module.settings.api.api_token, //z9SNcLnCMHJUXdtzU0VBeQ
          },
          type: "POST",
          data: { voucher_code: voucher_code },
          dataType: "json",
          success: function (data) {
            if (data.code == 200) {
              Swal.fire({
                icon: "success",
                title: "Voucher cost is: $" + data.data.cost,
                showConfirmButton: false,
                timer: 2500,
              });
              shipping = parseFloat(
                $("option:selected").text().split("$").pop()
              );
              total_payment =
                parseFloat(shipping + getTotal()) - parseFloat(data.data.cost);
              $(".totalOrder").get(0).innerText = "$" + total_payment;
            } else {
              Swal.fire({
                icon: "error",
                title: "Voucher is invalid",
                text: "or expired",
              });
            }
          },
          error: function () {},
        });
      });
  };

  module.changeMethodShipping = function () {
    $("select")
      .off()
      .on("change", function () {
        method_id = this;
        var price_shipping = $("option:selected").text().split("$").pop();
        $(".totalOrder").get(0).innerText =
          "$" + parseFloat(getTotal() + parseFloat(price_shipping));
        $(".price_shipping").get(0).innerText =
          "$" + parseFloat($("option:selected").text().split("$").pop());
      });
    module.checkout_with_momo = function () {
      shopping_carts = localStorage.getItem("carts")
        ? JSON.parse(localStorage.getItem("carts"))
        : [];

      $(document).on("click", ".checkout_with_momo", function () {
        voucher_code = $(".voucher_code").val().trim();
        method_shipping = parseFloat($("option:selected").val());
        $.ajax({
          url: module.settings.api.checkout_with_momo,
          headers: {
            Authorization: "Bearer " + module.settings.api.api_token,
          },
          type: "POST",
          data: {
            token: module.settings.api.api_token,
            data: shopping_carts,
            voucher_code: voucher_code,
            method_shipping: method_shipping,
          },
          dataType: "json",
          success: function (data) {
            if (data.code == 200) {
              console.log(data);
              window.location = data.data.url;
            } else {
              Swal.fire({
                icon: "error",
                title: "error",
              }).then(() => {
                window.localStorage.removeItem("carts");
                window.location = "/users/carts";
              });
            }
          },
          error: function () {},
        });
      });
    };
  };

  module.init = function () {
    module.addToCart();
    module.showCarts();
    module.incrementCart();
    module.decrementCart();
    module.handleQuantityInput();
    module.removeCart();
    module.showBadegs();
    module.addToCartInDetail();
    module.checkout();
    module.checkVoucher();
    module.changeMethodShipping();
    module.checkout_with_momo();
  };
}
$(document).ready(function () {
  cart = new Cart();
  cart.init();
});
