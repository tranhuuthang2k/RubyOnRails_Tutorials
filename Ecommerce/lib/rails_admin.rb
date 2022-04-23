# frozen_string_literal: true

module RailsAdmin
  module Config
    module Actions
      class Dashboard < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :root? do
          true
        end

        register_instance_option :breadcrumb_parent do
          nil
        end

        register_instance_option :controller do
          proc do
            # You can specify instance variables
            def order_items(order_items)
              data = []
              order_items.pluck('product_order').each do |item|
                data << JSON.parse(item)
              end
              data.flatten
            end

            def load_order_items(month, year)
              data_order_item = OrderItem.all
              order_items = data_order_item.this_status(Product::STATUS[:confirmed])
                                           .by_orders(month, year)
              total_order_cancel = data_order_item.this_status(Product::STATUS[:cancel])
                                                  .by_orders(month, year)
              top_service_shipping = data_order_item.unscoped.this_status(Product::STATUS[:confirmed])
                                                    .by_orders(month, year).group('service')
              order_for_aweek = data_order_item.unscoped.by_orders(month, year).group_by_day_of_week(:created_at,
                                                                                                     format: '%a')
              order_for_month = data_order_item.unscoped.by_orders(month, year).group_by_month(:created_at,
                                                                                               format: '%b %Y')
              fee_ship = order_items.pluck('fee').sum
              voucher = order_items.pluck('voucher').sum
              {
                order_items: order_items,
                fee_ship_voucher: fee_ship - voucher,
                total_order_cancel: total_order_cancel,
                top_service_shipping: top_service_shipping,
                order_for_aweek: order_for_aweek,
                order_for_month: order_for_month
              }
            end

            def base_statistic_products(product_id = {}, month, year)
              product_views = ProductView.by_month_year(month, year)
              product_view_ids = product_views.present? && product_views.pluck('product_id').compact.each_with_object(Hash.new(0)) do |c, counts|
                counts[c] += 1
              end
              if product_id.present?
                product = Product.find(product_id)
                best_availability = product.availability
              end

              availabilities = Availability.by_month_year(month, year)
              if availabilities.present? && (availabilities&.maximum('product_sold').positive? || availabilities&.maximum('is_ordering').positive?)
                best_availability_ordering = availabilities.find_by(is_ordering: availabilities.maximum('is_ordering'))
              end

              best_id_views = product_view_ids.present? ? product_view_ids.max_by { |_k, v| v }[0] : {}
              keywords = KeywordSearch.by_keywords(month, year)

              {
                best_seller: product.present? ? product : nil,
                best_keyword_search: keywords.present? ? keywords.find_by!(count: keywords.pluck('count').max) : {},
                best_product_views: best_id_views ? Product.find_by(id: best_id_views) : {},
                best_availability: best_availability,
                best_availability_ordering: best_availability_ordering,
                vouchers: Voucher.by_vouchers(month, year).size
              }
            end

            def not_have_params_month_year(product_id = {})
              base_statistic_products(product_id, Time.zone.month, Time.zone.year)
            end

            def statistic_products(order_items = {}, month_year = {})
              if order_items.present? # have order item
                product_id = order_items(order_items).pluck('id').each_with_object(Hash.new(0)) do |product, counts|
                               counts[product] += 1
                             end.max_by { |_k, v| v }[0] # count product_id of order_item when customer order is statistic best seller
                if month_year.present? # month_year exists
                  base_statistic_products(product_id, params['month_year'].split('-')[1],
                                          params['month_year'].split('-')[0])
                else # #month_year not exists
                  base_statistic_products(product_id, Time.zone.now.month, Time.zone.now.year)
                end
              elsif order_items.present? == false && month_year.present? == true # have order item && month_year exists
                base_statistic_products({}, params['month_year'].split('-')[1], params['month_year'].split('-')[0])
              elsif order_items.present? == false && month_year.present? == false # have order item exists but month_year not exists
                base_statistic_products({}, Time.zone.now.month, Time.zone.now.year)
              end
            end

            # You can access submitted params (just submit your form to the dashboard)
            def result_statistic
              year = params[:month_year] ? params['month_year'].split('-')[0] : Time.zone.now.year
              month = params[:month_year] ? params['month_year'].split('-')[1] : Time.zone.now.month

              data = load_order_items(month, year)
              @result = {
                data: order_items(data[:order_items]).pluck('total').map(&:to_f).sum.round(1) + data[:fee_ship_voucher],
                sold: order_items(data[:order_items]).size,
                total_order_cancel: order_items(data[:total_order_cancel]).size,
                top_service_shipping: data[:top_service_shipping].size,
                order_for_aweek: data[:order_for_aweek].size,
                order_for_month: data[:order_for_month].size,
                year: year,
                month: month,
                statistic_products: statistic_products(data[:order_items], params[:month_year])
              }
            end
            result_statistic

            # product sold of this month,year
            @total_availabilitys = Availability.all.size
            # You can specify flash messages
            flash.now[:success] = t 'welcome_to_dashboard'

            # After you're done processing everything, render the new dashboard
            render @action.template_name, status: 200
          end
        end

        register_instance_option :route_fragment do
          ''
        end

        register_instance_option :link_icon do
          'icon-home'
        end

        register_instance_option :statistics? do
          true
        end
      end
    end
  end
end
