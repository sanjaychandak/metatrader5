//+------------------------------------------------------------------+
//|                                     RSI - Downtrend Strategy.mq5 |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link "https://www.mql5.com"
#property version "1.00"

#include <Trade/Trade.mqh>
CTrade trade;

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
bool RSIDownwardsTrendStrategy(double rsiValue)
{
    if (rsiValue >= 10 && rsiValue <= 30)
    {
        return true;
    }

    return false;
}

bool RSIUpwardsTrendStrategy(double rsiValue)
{
    if (rsiValue >= 30 && rsiValue <= 100)
    {
        return true;
    }

    return false;
}

// string RSIDownwardTrendStrategy(double rsiValue)
// {
//     string signal = "";

//     if (rsiValue > 50)
//     {
//         signal = "Downtrend - SHORT";
//     }
//     else if (rsiValue < 30)
//     {
//         signal = " Downtrend - TAKE PROFIT";
//     }

//     return signal;
// }

// string RSISidewaysTrendBuyStrategy(double rsiValue)
// {
//     string signal = "";

//     if (rsiValue < 30)
//     {
//         signal = "Sideways - BUY";
//     }
//     else if (rsiValue > 50)
//     {
//         signal = " Sideways - TAKE PROFIT";
//     }

//     return signal;
// }

// string RSISidewaysTrendShortStrategy(double rsiValue)
// {
//     string signal = "";

//     if (rsiValue > 70)
//     {
//         signal = "Sideways - SHORT";
//     }
//     else if (rsiValue < 50)
//     {
//         signal = "Sideways - TAKE PROFIT";
//     }

//     return signal;
// }
void createBuyOrder()
{
    double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
    double sl = bid + 100 * SymbolInfoDouble(_Symbol, SYMBOL_POINT);
    double tp = bid - 100 * SymbolInfoDouble(_Symbol, SYMBOL_POINT);
    trade.Buy(0.01, _Symbol, bid, sl, tp, "This is a buy signal");
}

void createSellOrder()
{
    // TODO: Research the symbolinfo class
    double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
    double sl = ask + 100 * SymbolInfoDouble(_Symbol, SYMBOL_POINT);
    double tp = ask - 100 * SymbolInfoDouble(_Symbol, SYMBOL_POINT);
    trade.Sell(0.01, _Symbol, ask, sl, tp, "This is a buy signal");
}

bool getTheNumberOfOpenPositionsForSymbol(string _Symbol)
{
    int numberOfOpenPositionForSymbol = 0;

    for (int i = 0; i < PositionsTotal(); i++)
    {
        if (_Symbol == PositionGetSymbol(i))
        {
            return false;
        }
    }
    return true;
}

void OnTick()
{
    Print("String: Hello World!");
    if (getTheNumberOfOpenPositionsForSymbol(_Symbol))
    {
        // Creating array for prices
        double RSIArray[];
        bool signal = false;

        // Identying RSI properties
        int RSIDef = iRSI(_Symbol, _Period, 14, PRICE_CLOSE);

        // Sorting prices arrayj
        ArraySetAsSeries(RSIArray, true);

        // Identifying EA
        CopyBuffer(RSIDef, 0, 0, 1, RSIArray);

        // Calculating EA
        double RSIValue = NormalizeDouble(RSIArray[0], 2);

        signal = RSIDownwardsTrendStrategy(RSIValue);
        if (signal)
        {
            createBuyOrder();
        }

        signal = RSIUpwardsTrendStrategy(RSIValue);
        if (signal)
        {
            createSellOrder();
        }

        if (signal != "")
        {
            Comment(signal);
        }
        else
        {
            Comment("No signal");
        }
    }
}
//+------------------------------------------------------------------+
