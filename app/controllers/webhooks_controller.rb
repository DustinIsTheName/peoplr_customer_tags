class WebhooksController < ApplicationController

	skip_before_filter :verify_authenticity_token, :only => [:customer, :order]

	def customer
		verified = verify_webhook(request.body.read, request.headers["HTTP_X_SHOPIFY_HMAC_SHA256"])

		if verified
			id = params[:id]
			customer = ShopifyAPI::Customer.find(id)
			Function.check_single_customer(customer)
		end

		head :ok, content_type: "text/html"
	end

	def order
		verified = verify_webhook(request.body.read, request.headers["HTTP_X_SHOPIFY_HMAC_SHA256"])

		if verified
			customer_id = params[:customer][:id]
			customer = ShopifyAPI::Customer.find(customer_id)
			Function.check_single_customer(customer)
		end

		head :ok, content_type: "text/html"
	end

	private

		def verify_webhook(data, hmac_header)
			digest  = OpenSSL::Digest.new('sha256')
			calculated_hmac = Base64.encode64(OpenSSL::HMAC.digest(digest, ENV["WEBHOOK_SECRET"], data)).strip
			if calculated_hmac == hmac_header
				puts Colorize.green("Verified!")
			else
				puts Colorize.red("Invalid verification!")
			end
			calculated_hmac == hmac_header
		end

end