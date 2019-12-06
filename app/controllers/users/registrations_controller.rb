# frozen_string_literal: true

require 'resolv' unless defined?(Resolv)

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :prevent_tor_sign_up, only: [ :new, :create ]
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
  protected
  def prevent_tor_sign_up
    if is_tor(request.remote_ip)
      redirect_to posts_url, :flash => { :error => "To combat ban evasion, accounts cannot be created over Tor." }
    end
  end

  TOR_BLACKLIST = ".torexit.dan.me.uk"
  TOR_LOOKUP_SUCCESS = "127.0.0.100"
  RDNS_IPV4_SUFFIX = ".in-addr.arpa"
  RDNS_IPV6_SUFFIX = ".ip6.arpa"

  def ip_for_dnsbl(ip_address)
    addr = IPAddr::new(ip_address)
    addr.reverse
      .sub(RDNS_IPV4_SUFFIX, TOR_BLACKLIST)
      .sub(RDNS_IPV6_SUFFIX, TOR_BLACKLIST)
  end

  def is_tor(ip_address)
    hostname = ip_for_dnsbl(ip_address)
    # DNS lookup code from https://github.com/dryruby/tor.rb/blob/master/lib/tor/dnsel.rb
    begin
      Resolv::each_address(hostname) do |addr|
        if a.to_s == TOR_LOOKUP_SUCCESS
          return true
        end
      end
      false
    rescue Resolv::ResolvError # NXDOMAIN
      false
    rescue Resolv::ResolvTimeout
      nil
    rescue Errno::EHOSTUNREACH
      nil
    rescue Errno::EADDRNOTAVAIL
      nil
    end
  end
end
