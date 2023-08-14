//+------------------------------------------------------------------+
//|                                                      ProjectName |
#include<Trade\Trade.mqh>
#include <Trade\SymbolInfo.mqh>

CTrade trade;

CSymbolInfo    m_symbol;


   //input ushort   profitInUSD          = 1.00;           
   //input ushort   lossInUSD            = -20.00;          
   input ulong    InpMagic             = 397752952;  
   
void OnTick()
  {
   
   //---
   if(!m_symbol.Name(Symbol())) // sets symbol name
     {
      Print(__FILE__," ",__FUNCTION__,", ERROR: CSymbolInfo.Name");
      return;
     }

   trade.SetExpertMagicNumber(InpMagic);
   trade.SetMarginMode();
   trade.SetTypeFillingBySymbol(m_symbol.Name());
  
   string signal="";
   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK),_Digits);

   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID),_Digits);

   double myRSIArray[];

   int myRSIDef = iRSI(_Symbol, _Period, 14, PRICE_CLOSE);

   ArraySetAsSeries(myRSIArray, true);

   CopyBuffer(myRSIDef,0,0,3,myRSIArray);

   double myRSIValue = NormalizeDouble(myRSIArray[0], 2);
   if(myRSIValue>1 && myRSIValue<30)
      signal = "buy";
   if(myRSIValue>80 && myRSIValue<100)
      signal = "sell";
      
   double balance = AccountInfoDouble(ACCOUNT_BALANCE); 
   double profit = AccountInfoDouble(ACCOUNT_PROFIT);

   if(signal == "buy" && PositionsTotal() < 1)
      trade.Buy(1, m_symbol.Name(), Ask); 
   
   if(profit > 0.90 && PositionsTotal() > 1)   
      trade.Sell(1, m_symbol.Name(), Bid); 
      profit = 0.0;
      
   if(profit< -0.30 && PositionsTotal() > 1)   
      trade.Sell(1, m_symbol.Name(), Bid);
      profit = 0.0;         
   
  }

