###########################################################
#   Late Night Cex - NMC Pimp v0.1 by Serial77
###########################################################
###
  EMA CROSSOVER TRADING ALGORITHM
  The script engine is based on CoffeeScript (http://coffeescript.org)
  Any trading algorithm needs to implement two methods:
    init(context) and handle(context,data)
###
debug "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
debug "Late Night Cex... Get ready for some serious pimpin!"
debug "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
# Initialization method called before a simulation starts.
# Context object holds script data and will be passed to 'handle' method.
class EMA
  @context: (context)->
      context.buy_treshold = 0.025
      context.sell_treshold = 0.1

  # This method is called for each tick
  @handle: (context, data)->
      # data object provides access to the current candle (ex. data.instruments[0].close)
      instrument = data.instruments[0]
      short = instrument.ema(2) # calculate EMA value using ta-lib function
      long = instrument.ema(9)
      # draw moving averages on chart
      plot
          short: short
          long: long
      diff = 100 * (short - long) / ((short + long) / 2)
      debug "Short: #{short.toFixed(5)} | Long: #{long.toFixed(5)} | Diff: #{diff.toFixed(5)}"
      # Uncomment next line for some debugging
      #debug 'EMA difference: '+diff.toFixed(3)+' price: '+instrument.price.toFixed(2)+' at '+new Date(data.at)
      if diff > context.buy_treshold
#          sell instrument # Spend all amount of cash for asset
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Stats & Orders module v0.5.9 by sportpilot
#
# sell() method - with optional (, amount) parameter
#
        Stats.sell context
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

      else
          if diff < -context.sell_treshold
            debug "Looking to Sell..."
#              buy instrument # Sell asset position
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Stats & Orders module v0.5.9 by sportpilot
#
# buy() method - with optional (, amount) parameter
#
            Stats.buy context
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Stats & Orders module v0.5.9 by sportpilot
#
#   BTC: 1561k5XqWFJSHP8apmvGt15ecWjw9ZLKGi
#
#   Description: This module provides Statistics reporting
#     and the ability to use Limit Orders, change the
#     Trade Timeout, set Reserves for USD &/or BTC
#     and more...
#
#   Ref: https://cryptotrader.org/topics/332486/stats-orders-module
#   Usage:
#
# Functions code block
#   Installation: Paste this block just BEFORE the
#     init: method
#
class Stats
  @context: (context) ->
  # Context for Stats
    context.stats = 'both'             # Display Stats? (all = every stats period , sell = only on sells, both = only on buy or sell, off = no Stats)
    context.stats_period = 120        # Display Stats only every n minutes when .stats = 'all' (for Stats on every tick, this # should match the period selected)
    context.trade_emails = false      # Send an Email when a trade is attempted and another when it completes or fails (Live only)
    context.trade_log_entries = true  # Display msg in the log when a trade is attempted and another when it completes or fails
    context.balances = true           # Display Balances?
    context.gain_loss = true          # Display Gain / Loss?
    context.win_loss = true           # Display Win / Loss & Trade Fees?
    context.prices = true             # Display Prices?
  #  context.triggers = false         # Display Trade triggers? *** Temporarily disabled
  #
  # Context for Orders
  #
    context.asset_reserve = 0         # Asset Reserve
    context.curr_reserve = 0          # Currency Reserve
    context.buy_timeout = null        # buy timeout (null = default 30 sec)
    context.sell_timeout = null       # sell timeout (null = default 30 sec)
    context.use_limit_orders = false  # Use Limit orders rather than Market orders?
    context.buy_limit_percent = 0     # % to increase buy price with Limit order (e.g. 0.1)
    context.sell_limit_percent = 0    # % to decrease sell price with Limit order (e.g. 0.1)
    context.trade_retries = 0         # Retry Limit orders n number of times before failing (0 = default Limit order behavior, no retries)
    context.trade_adj_pct = 0         # Adjust Limit order price by % with each retry (e.g. 0.1)
    context.price_rounding = null     # Round order price to n decimal digits (null = no rounding)
  #
  # Required variables
  #   Comment any defined in the Host strategy code. The values listed here will be
  #     overwritten if they are later redefined by other code.
  #
    context.pair = 'nmc_btc'          # Asset / Currency pair
    context.min_trade_asset = 0.0001    # Minimum asset trade size of exchange (e.g. MtGox btc = 0.01)
    context.fee_percent = 0         # Exchange trade fee
  #
  # DO NOT change anything below
  #
    context.next_stats = 0
    context.time = 0
    context.mins = 0
    context.trade_value = null
    context.cur_ins = null
    context.cur_data = null
    context.cur_portfolio = null
    context.currencies = []
    context.curr = null
    context.asset = null
    context.trader_asset = null
    context.trader_curr = null
    context.value_initial = 0
    context.price_initial = 0
    context.asset_initial = 0
    context.curr_initial = 0
    context.fees_paid = 0
    context.buy_value = null
    context.traded = false
    context.trade_open = false
    context.trade_type = null
    # Ichi/Scalp
    context.mode = null
    # Win & Losses
    context.Strat1_win_cnt = 0
    context.Strat1_win_value = 0
    context.Strat1_loss_cnt = 0
    context.Strat1_loss_value = 0
    context.Strat2_win_cnt = 0
    context.Strat2_win_value = 0
    context.Strat2_loss_cnt = 0
    context.Strat2_loss_value = 0
#
# Serialized Context
#
  @serialize: (context)->
    next_stats:context.next_stats
    cur_ins:context.cur_ins
    cur_data:context.cur_data
    cur_portfolio:context.cur_portfolio
    currencies:context.currencies
    curr:context.curr
    asset:context.asset
    trader_asset:context.trader_asset
    trader_curr:context.trader_curr
    value_initial:context.value_initial
    price_initial:context.price_initial
    asset_initial:context.asset_initial
    curr_initial:context.curr_initial
    fees_paid:context.fees_paid
    traded:context.traded
    trade_open:context.trade_open
    Strat1_win_cnt:context.Strat1_win_cnt
    Strat1_win_value:context.Strat1_win_value
    Strat1_loss_cnt:context.Strat1_loss_cnt
    Strat1_loss_value:context.Strat1_loss_value
    Strat2_win_cnt:context.Strat2_win_cnt
    Strat2_win_value:context.Strat2_win_value
    Strat2_loss_cnt:context.Strat2_loss_cnt
    Strat2_loss_value:context.Strat2_loss_value

  @handle: (context, data)->
    context.cur_ins = data[context.pair]
    context.cur_data = data
    context.cur_portfolio = portfolio
    if context.value_initial == 0
      Stats.initial(context)
    context.trader_asset = context.cur_portfolio.positions[context.asset].amount
    context.trader_curr = context.cur_portfolio.positions[context.curr].amount

  @initial: (context) ->
    context.currencies.push (context.pair.split "_")[0]
    context.currencies.push (context.pair.split "_")[1]
    context.asset = context.currencies[0]
    context.curr = context.currencies[1]
    context.trader_asset = context.cur_portfolio.positions[context.asset].amount
    context.trader_curr = context.cur_portfolio.positions[context.curr].amount

    if context.trader_asset > 0
      context.asset_initial = context.trader_asset
      context.buy_value = (context.trader_asset * context.cur_ins.price) + context.trader_curr
      context.trade_open = true
    else
      context.asset_initial = context.trader_curr / context.cur_ins.price
    context.curr_initial = context.trader_curr
    context.price_initial = context.cur_ins.price
    context.value_initial = (context.cur_ins.price * context.trader_asset) + context.curr_initial

#
# finalize: method
#
  @finalize: (context)->
    if _.contains(['all', 'both', 'sell'], context.stats)
      context.stats = 'all'
      context.next_stats = 0
      debug "~~~~~~~~~~~~~~~~~~~~~~"
      debug "~  Final Stats"
      Stats.report(context)
  @exec_stats: (context) ->
    if context.next_stats == 0 then context.next_stats = context.time
    if context.time >= context.next_stats
      context.next_stats += context.stats_period
      return true

  @report: (context) ->
    data = context.cur_data
    context.time = data.at / 60000
    context.trader_asset = context.cur_portfolio.positions[context.asset].amount
    context.trader_curr = context.cur_portfolio.positions[context.curr].amount
    if (context.stats == 'all' and Stats.exec_stats(context)) or (context.traded and (context.stats == 'both' or context.stats =='all')) or (context.traded and context.stats == 'sell' and context.trade_type == 'sell')

      balance = (context.cur_ins.price * context.trader_asset) + context.trader_curr
      price = context.cur_ins.price.toFixed(5)
      open = context.cur_ins.open[context.cur_ins.open.length - 1].toFixed(5)
      high = context.cur_ins.high[context.cur_ins.high.length - 1].toFixed(5)
      low = context.cur_ins.low[context.cur_ins.low.length - 1].toFixed(5)
      gain_loss = (balance - context.value_initial).toFixed(5)
      gain_loss_pct = ((balance - context.value_initial) / context.value_initial * 100).toFixed(1)
      BH_gain_loss = (balance - (context.cur_ins.price * context.asset_initial)).toFixed(5)
      trade_gain_loss = (balance - (context.buy_value)).toFixed(5)
      trade_gain_loss_pct = ((balance - context.buy_value) / context.buy_value * 100).toFixed(1)
      bal_asset = context.trader_asset.toFixed(5)
      bal_curr = context.trader_curr.toFixed(5)
      balance = balance.toFixed(5)

      if context.traded is false
        debug "~~~~~~~~~~~~~~~~~~~~~~"
      else
        debug "~"

      if context.balances
        debug "Balance (#{context.curr}): #{balance} | #{context.curr}: #{bal_curr} | #{context.asset}: #{bal_asset}"
      if context.gain_loss
        if context.trade_open or context.traded
          debug "[G/L] Session: #{gain_loss} (#{gain_loss_pct}%) | Trade: #{trade_gain_loss} (#{trade_gain_loss_pct}%) | B&H: #{BH_gain_loss}"
        else
          debug "[G/L] Session: #{gain_loss} (#{gain_loss_pct}%) | B&H: #{BH_gain_loss}"

      if context.win_loss
        if context.mode == null
          if _.contains(['sell_amt', 'buy_amt'], context.trade_type)
            debug "[W/L]: Disabled | Fees: #{context.fees_paid.toFixed(5)}"
          else
            debug "[W/L]: #{context.Strat1_win_cnt} / #{context.Strat1_loss_cnt} | #{context.Strat1_win_value.toFixed(5)} / #{context.Strat1_loss_value.toFixed(5)} | Fees: #{context.fees_paid.toFixed(5)}"
        else
          debug "[W/L] Ichi: #{context.Strat1_win_cnt} / #{context.Strat1_loss_cnt} | #{context.Strat1_win_value.toFixed(5)} / #{context.Strat1_loss_value.toFixed(5)} | Scalp: #{context.Strat2_win_cnt} / #{context.Strat2_loss_cnt} ~ $#{context.Strat2_win_value.toFixed(5)} / $#{context.Strat2_loss_value.toFixed(5)}"

      if context.prices
        debug "Price: #{price} | O: #{open} | H: #{high} | L: #{low}"
    context.traded = false
    context.trade_value = null

#    if context.triggers and context.mode == 'ichi'
#      if context.trader_asset > 0
#        warn "Long - Close: #{tk_diff.toFixed(3)} >= #{config.long_close} [&] #{c.tenkan.toFixed(3)} <= #{c.kijun.toFixed(3)} [&] (#{c.chikou.toFixed(3)} <= #{sar.toFixed(3)} [or] #{rsi.toFixed(3)} <= #{config.rsi_low} [or] #{macd.histogram.toFixed(3)} <= #{config.macd_short})"
#        warn "Short - Open: #{tk_diff.toFixed(3)} >= #{config.short_open} [&] #{c.tenkan.toFixed(3)} <= #{c.kijun.toFixed(3)} [&] #{tenkan_max.toFixed(3)} <= #{kumo_min.toFixed(3)} [&] #{c.chikou_span.toFixed(3)} <= 0 [&] #{aroon.up} - #{aroon.down} < -#{config.aroon_threshold}"
#      else
#        warn "Short - Close: #{tk_diff.toFixed(3)} >= #{config.short_close} [&] #{c.tenkan.toFixed(3)} >= #{c.kijun.toFixed(3)} [&] (#{c.chikou.toFixed(3)} >= #{sar.toFixed(3)} [or] #{rsi.toFixed(3)} >= #{config.rsi_low} [or] #{macd.histogram.toFixed(3)} >= #{config.macd_long})"
#        warn "Long - Open: #{tk_diff.toFixed(3)} >= #{config.long_open} [&] #{c.tenkan.toFixed(3)} >= #{c.kijun.toFixed(3)} [&] #{tenkan_min.toFixed(3)} >= #{kumo_max.toFixed(3)} [&] #{c.chikou_span.toFixed(3)} >= 0 [&] #{aroon.up} - #{aroon.down} >= #{config.aroon_threshold}"

  @win_loss: (context) ->
    context.trader_asset = context.cur_portfolio.positions[context.asset].amount
    context.trader_curr = context.cur_portfolio.positions[context.curr].amount
    balance = (context.cur_ins.price * context.trader_asset) + context.trader_curr
    context.fees_paid += context.trade_value - balance
    trade_net = balance - context.buy_value
    if context.mode == 'ichi' or context.mode == null
      if trade_net >= 0
        context.Strat1_win_cnt += 1
        context.Strat1_win_value += trade_net
      else
        context.Strat1_loss_cnt += 1
        context.Strat1_loss_value += trade_net
    else if context.mode =='scalp'
      if trade_net >= 0
        context.Strat2_win_cnt += 1
        context.Strat2_win_value += trade_net
      else
        context.Strat2_loss_cnt += 1
        context.Strat2_loss_value += trade_net

  @trade_msg: (context, msg) ->
    if context.trade_log_entries then debug msg
    if context.trade_emails then sendEmail msg

  @rnd_price: (price, digits) ->
    if digits?
      price = Math.round(price * Math.pow(10, digits)) / Math.pow(10, digits)
    else
      return price

  @place_sell_order: (context, amt) ->
    x = 0
    trade_result = null
    if context.use_limit_orders
      trade_price = Stats.rnd_price(context.cur_ins.price * (1 - context.sell_limit_percent / 100), context.price_rounding)    # use Limit Order
    else
      trade_price = null                                                              # use Market Order
    if amt?
      trade_amount = _.min([amt, context.trader_asset - context.asset_reserve])
    else
      trade_amount = context.trader_asset - context.asset_reserve
    if trade_amount >= context.min_trade_asset
      if _.contains(['all', 'both', 'sell'], context.stats)
        debug "~~~~~~~~~~~~"
      while (x <= context.trade_retries)
        Stats.trade_msg(context, "Attempting a SELL of #{trade_amount.toFixed(5)} #{context.asset} at #{if trade_price? then trade_price.toFixed(5) else trade_price} #{context.curr} with a timeout of #{context.sell_timeout} secs")
        trade_result = sell context.cur_ins, trade_amount, trade_price, context.sell_timeout
        if not trade_result? and context.use_limit_orders
          x++
          trade_price = Stats.rnd_price(trade_price * (1 - context.trade_adj_pct / 100), context.price_rounding)
        else
          return trade_result
      Stats.trade_msg(context, "SELL of #{trade_amount.toFixed(5)} #{context.asset} at #{if trade_price? then trade_price.toFixed(5) else trade_price} #{context.curr} FAILED - Order not completed")
    else
        Stats.trade_msg(context, "Can't attempt SELL of #{trade_amount.toFixed(5)} #{context.asset} - Exchange minimum trade (#{context.min_trade_asset} #{context.asset}) not met")
    return null

  @place_buy_order: (context, amt) ->
    x = 0
    trade_result = null
    order_price = Stats.rnd_price(context.cur_ins.price * (1 + context.buy_limit_percent / 100), context.price_rounding)
    if context.use_limit_orders
      trade_price = order_price                                                     # use Limit Order
    else
      trade_price = null                                                            # use Market Order
    if amt?
      trade_amount = _.min([amt * order_price, context.trader_curr - context.curr_reserve]) / order_price
    else
      trade_amount = (context.trader_curr - context.curr_reserve) / order_price
    if trade_amount >= context.min_trade_asset
      if _.contains(['all', 'both', 'sell'], context.stats)
        debug "~~~~~~~~~~~~"
      while (x <= context.trade_retries)
        Stats.trade_msg(context, "Attempting a BUY of #{(trade_amount * (1 - context.fee_percent / 100)).toFixed(5)} #{context.asset} at #{if trade_price? then trade_price.toFixed(5) else trade_price} #{context.curr} with a timeout of #{context.buy_timeout} secs")
        trade_result = buy context.cur_ins, trade_amount, trade_price, context.buy_timeout
        if not trade_result? and context.use_limit_orders
          x++
          trade_price = Stats.rnd_price(trade_price * (1 + context.trade_adj_pct / 100), context.price_rounding)
        else
          return trade_result
      Stats.trade_msg(context, "BUY of #{trade_amount.toFixed(5)} #{context.asset} at #{if trade_price? then trade_price.toFixed(5) else trade_price} #{context.curr} FAILED - Order not completed")
    else
        Stats.trade_msg(context, "Can't attempt BUY of #{trade_amount.toFixed(5)} #{context.asset} - Exchange minimum trade (#{context.min_trade_asset} #{context.asset}) not met")
    return null

  @sell: (context, amt = null) ->
    if context.trader_asset >= context.min_trade_asset
      if context.trader_asset - context.asset_reserve > 0
        trade_result = Stats.place_sell_order(context, amt)
        if trade_result?
          Stats.trade_msg(context, "SELL completed - #{trade_result.amount.toFixed(5)} #{context.asset} at #{trade_result.price.toFixed(5)} #{context.curr}")
          context.trade_value = trade_result.amount * trade_result.price
          context.trader_curr += context.trade_value
          context.trader_asset -= trade_result.amount
          Stats.win_loss(context)
          context.trade_open = false
          if amt? then context.trade_type = 'sell_amt' else context.trade_type = 'sell'
        context.traded = true

  @buy: (context, amt = null) ->
    if context.trader_curr >= ((context.cur_ins.price * context.min_trade_asset) * (1 + context.fee_percent / 100)) and context.trader_curr > 0.0001
      if context.trader_curr - context.curr_reserve > 0
        buy_value = (context.trader_asset * context.cur_ins.price) + context.trader_curr
        trade_result = Stats.place_buy_order(context, amt)
        if trade_result?
          Stats.trade_msg(context, "BUY completed - #{trade_result.amount.toFixed(5)} #{context.asset} at #{trade_result.price.toFixed(5)} #{context.curr}")
          context.buy_value = buy_value
          context.trade_value = trade_result.amount * trade_result.price
          context.fees_paid += buy_value - context.trade_value
          context.trader_curr -= context.trade_value
          context.trader_asset += trade_result.amount
          context.trade_open = true
          if amt? then context.trade_type = 'buy_amt' else context.trade_type = 'buy'
        context.traded = true

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Stats & Orders module v0.5.9 by sportpilot
#
# context: method
#
#   Installation: Replace -->   context: (context)->
#     with a copy of this block
#
init: (context)->
  Stats.context(context)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  EMA.context(context)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Stats & Orders module v0.5.9 by sportpilot
#
# serialize: method
#
#   Installation: Replace -->   serialize: (context)->
#     with a copy of this block
#
serialize: (context)->
  Stats.serialize(context)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Stats & Orders module v0.5.9 by sportpilot
#
# handle: method
#
#   Installation: Replace -->   handle: (context, data)->
#     with a copy of this block
#
handle: (context, data)->
  Stats.handle(context, data)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  EMA.handle(context, data)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Stats & Orders module v0.5.9 by sportpilot
#
# Process Stats
#
#   Installation: Paste this block at the end of ALL
#     other code or just BEFORE the finalize: method
#     if it exists.
#
#   NOTE: Pay attention to the indentation of the code
#           line. It must be adjusted for your host code.
#
  Stats.report(context)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Stats & Orders module v0.5.9 by sportpilot
#
# finalize: method
#
#   Installation: Replace: -->   finalize: (context)->
#     with a copy of this block
#
finalize: (context)->
  Stats.finalize(context)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

