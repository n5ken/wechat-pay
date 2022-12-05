# frozen_string_literal: true

require 'json'
require 'wechat-pay/helper'
require 'wechat-pay/partner/withdraw'

module WechatPay
  module Partner
    include WechatPayHelper

    def transactions_method_by_suffix(suffix, params)
      url = "/v3/pay/partner/transactions/#{suffix}"
      method = 'POST'

      params = {
        sp_appid: WechatPay.app_id,
        sp_mchid: WechatPay.mch_id
      }.merge(params)

      payload_json = params.to_json

      make_request(
        method: method,
        path: url,
        for_sign: payload_json,
        payload: payload_json
      )
    end
  end
end