//+------------------------------------------------------------------+
//|                                                          RSI.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link "https://www.mql5.com"
#property version "1.00"

//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include <Trade/Trade.mqh>

//+------------------------------------------------------------------+
//| Inputs                                                           |
//+------------------------------------------------------------------+
static input long InpMagicNumber = 546812; // magic number
static input double InpLotSize = 0.01;     // lot size
input int InpRSIPeriod = 21;               // rsi period
input int InpRSILevel = 70;                // rsi upper level
input int InpStopLoss = 200;               // stop loss in point (0=off)
input int InpTakeProfit = 100;             // take profit in points (0=off)
input bool InpCloseSignal = false;         // close trades by opposite signal

//+------------------------------------------------------------------+
//| Global variables                                                 |
//+------------------------------------------------------------------+
int handle;
double buffer[];
MqlTick currentTick;
CTrade trade;
datetime openTimeBuy = 0;
datetime openTimeSell = 0;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
  // Check user inputs
  if (InpMagicNumber <= 0)
  {
    Alert("Magic number <= 0");
    return INIT_PARAMETERS_INCORRECT;
  }

  if (InpLotSize <= 0 || InpLotSize > 10)
  {
    Alert("Lot size <= 0 or > 10");
    return INIT_PARAMETERS_INCORRECT;
  }

  if (InpRSIPeriod <= 1)
  {
    Alert("RSI period <= 1");
    return INIT_PARAMETERS_INCORRECT;
  }

  if (InpRSILevel >= 100 || InpRSILevel <= 50)
  {
    Alert("RSI level >= 100 or <= 50 ");
    return INIT_PARAMETERS_INCORRECT;
  }

  if (InpStopLoss < 0)
  {
    Alert("Stop Loss < 0 ");
    return INIT_PARAMETERS_INCORRECT;
  }

  if (InpTakeProfit < 0)
  {
    Alert("Take profit >= 100 or <= 50 ");
    return INIT_PARAMETERS_INCORRECT;
  }

  return (INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
  //---
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
  //---
}
//+------------------------------------------------------------------+
