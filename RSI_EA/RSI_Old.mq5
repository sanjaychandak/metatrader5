//+------------------------------------------------------------------+
//|                                                     RSI Example  |
//|                                    Copyright 2023, MetaQuotes Ltd.|
//|                                             https://www.mql5.com|
//+------------------------------------------------------------------+
#property copyright "2023, MetaQuotes Ltd."
#property link "https://www.mql5.com"
#property version "1.00"
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Lime

#include <Trade/Trade.mqh>
CTrade trade;

//--- input parameters
input int RSI_Period = 14;       // RSI period
input int Overbought_Level = 70; // Overbought level
input int Oversold_Level = 30;   // Oversold level

//--- indicator buffers
double ExtRSIBuffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
  // Indicator buffer
  SetIndexBuffer(0, ExtRSIBuffer);
  SetIndexLabel(0, "RSI");

  // Set index style
  SetIndexStyle(0, DRAW_LINE);

  return (INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
  Print("OnDeinit");
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
  int begin = RSI_Period;
  if (rates_total <= begin)
    return (0);

  // Calculate RSI
  for (int i = begin; i >= 0; i--)
  {
    double avg_gain = 0, avg_loss = 0;
    for (int j = i; j < i + RSI_Period; j++)
    {
      double diff = close[j] - close[j - 1];
      if (diff > 0)
        avg_gain += diff;
      else
        avg_loss -= diff;
    }

    if (avg_loss > 0)
      avg_loss /= RSI_Period;
    else
      avg_loss = 0;

    if (avg_gain > 0)
      avg_gain /= RSI_Period;
    else
      avg_gain = 0;

    double rs = 0;
    if (avg_loss != 0)
      rs = avg_gain / avg_loss;
    else
      rs = 100.0;

    ExtRSIBuffer[i] = 100.0 - (100.0 / (1 + rs));
  }

  // Generate buy/sell signals based on RSI conditions
  for (int i = RSI_Period; i >= 0; i--)
  {
    // Check for overbought condition
    if (ExtRSIBuffer[i] > Overbought_Level)
    {
      // Generate a sell signal or take-profit for existing buy positions
      // Your trade execution logic goes here...
      
    }
    // Check for oversold condition
    else if (ExtRSIBuffer[i] < Oversold_Level)
    {
      // Generate a buy signal or take-profit for existing sell positions
      // Your trade execution logic goes here...
      double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
      double sl = bid + 100 * SymbolInfoDouble(_Symbol, SYMBOL_POINT);
      double tp = bid - 100 * SymbolInfoDouble(_Symbol, SYMBOL_POINT);
      trade.Buy(0.01, _Symbol, bid, sl, tp, "This is a buy signal");
    }

    // Check for bullish or bearish divergence
    // Your divergence detection logic goes here...
  }

  return (rates_total);
}
//+------------------------------------------------------------------+
