class Function < ActiveRecord::Base

	CYCLE = 0.5
	@start_time = Time.now

	def self.say_hello
		print Colorize.magenta('ENV["WEBHOOK_SECRET"]: ')
		puts Colorize.cyan(ENV["WEBHOOK_SECRET"])
	end

	def self.how_long_a_nap
	  stop_time = Time.now
	  processing_duration = stop_time - @start_time
	  wait_time = (CYCLE - processing_duration).ceil
	  sleep wait_time if wait_time > 0
	  @start_time = Time.now
	end

	def self.check_single_customer(c)
		old_tags = c.tags
		products_of_interest = [326390525, 544494276, 444345360, 544065732]

		Function.how_long_a_nap
		ordered_products = c.orders.map do |order|
			order.line_items.map do |line_item|
				line_item.product_id
			end[0]
		end

		if ordered_products.count > (ordered_products - products_of_interest).count
			c.tags = c.tags.add_tag('show_form_higherspec')
			puts Colorize.cyan('Customer ' << c.first_name << ' ' << c.last_name << ' has bought one of the products. ') << Colorize.green('Add Tag!')
		else
			c.tags = c.tags.remove_tag('show_form_higherspec')
			puts Colorize.magenta('Customer ' << c.first_name << ' ' << c.last_name << ' has not bought one of the products. ') << Colorize.red('Remove Tag!')
		end

		unless c.tags == old_tags
			Function.how_long_a_nap
			c.save
		end

	end

	def self.check_all_customers
		customer_count = ShopifyAPI::Customer.count
		nb_pages = (customer_count / 250.0).ceil

		1.upto(nb_pages) do |page|

			unless page == 1
				Function.how_long_a_nap
		  end

		  customers = ShopifyAPI::Customer.find( :all, :params => { :limit => 250, :page => page } )

		  customers.each do |c|
				Function.check_single_customer(c)
		  end

		end		

		puts Colorize.green('All done!')
	end

end