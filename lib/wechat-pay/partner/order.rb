# frozen_string_literal: true

module WechatPay
  # 订单相关
  module Partner

    def self.define_transaction_method(key, value, _document)
      const_set("INVOKE_TRANSACTIONS_IN_#{key.upcase}_FIELDS",
                %i[sub_mchid description out_trade_no notify_url amount].freeze)
      define_singleton_method("invoke_transactions_in_#{key}") do |params|
        transactions_method_by_suffix(value, params)
      end
    end

    define_transaction_method('native', 'native', 'document missing')
    define_transaction_method('js', 'jsapi', 'https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_2_2.shtml')
    define_transaction_method('app', 'app', 'https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_2_1.shtml')
    define_transaction_method('h5', 'h5', 'https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_2_4.shtml')
    define_transaction_method('miniprogram', 'jsapi', 'https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_2_3.shtml')

    QUERY_ORDER_FIELDS = %i[sub_mchid out_trade_no transaction_id].freeze # :nodoc:

    # JSAPI下单


    # 查询订单
    # GET https://api.mch.weixin.qq.com/v3/pay/partner/transactions/id/{transaction_id}

    # 关闭订单
    # POST https://api.mch.weixin.qq.com/v3/pay/partner/transactions/out-trade-no/{out_trade_no}/close

    # JSAPI调起支付
    # X

    # 支付结果通知
    # X

    # 申请退款
    # POST https://api.mch.weixin.qq.com/v3/refund/domestic/refunds

    # 查询单笔退款
    # GET https://api.mch.weixin.qq.com/v3/refund/domestic/refunds/{out_refund_no}

    # 退款结果通知
    # X

    # 申请交易账单
    # GET https://api.mch.weixin.qq.com/v3/bill/tradebill

    # 申请资金账单
    # GET https://api.mch.weixin.qq.com/v3/bill/fundflowbill

    # 申请单个子商户资金账单
    # GET https://api.mch.weixin.qq.com/v3/bill/sub-merchant-fundflowbill

    # 下载账单
    # ...

    class << self
      private

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
end
