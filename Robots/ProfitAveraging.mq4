//+------------------------------------------------------------------+
//|                                              ProfitAveraging.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                          Version: 1 - 15.01.2023 |
//|                                              Status: Development |
//|                           Comment: first order 0.01 opposite 0.03|
//+------------------------------------------------------------------+

int TP = 5;
double oppositeTP = 2.5;
double oppositeSP = 2.5;

int oppositeOrderValue = 5;

double buyOpenPrice = 0;
double sellOpenPrice = 0;

bool buy = false;
bool sell = false;
bool oppositeOrderEntered = false;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {


   return(INIT_SUCCEEDED);
  }
//-------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   if(OrdersTotal() == 0 && buy == false && sell == true)
     {
      SellOrderOpener();
     }
   if(OrdersTotal() == 0)
     {
      BuyOrderOpener();
     }
   if(buy == true && sell == false && oppositeOrderEntered == false)
     {
      if(buyOpenPrice - Ask >= TP)
        {
         OppositeSellOrderOpener();
        }
     }
   if(sell == true && buy == false && oppositeOrderEntered == false)
     {
      if(Bid - sellOpenPrice >= TP)
        {
         OppositeSellOrderOpener();
        }
     }
   if(oppositeOrderEntered == true)
     {
      if(buy == true && sell == false)
        {
         if(buyOpenPrice - Ask >= oppositeTP)
           {
            CloseOrders();
           }
         if(buyOpenPrice - Ask >= oppositeSP)
           {
            CloseOrders();
           }
        }
      if(buy == false && sell == true)
        {
         if(Bid - sellOpenPrice >= oppositeTP)
           {
            CloseOrders();
           }
         if(Bid - sellOpenPrice >= oppositeSP)
           {
            CloseOrders();
           }
        }
     }

  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double BuyOrderOpener()
  {
   buy = true;
   sell = false;
   buyOpenPrice = Ask;
   oppositeOrderEntered = false;
   return OrderSend(_Symbol,OP_BUY,0.01,Ask,0,0,Bid + TP,NULL,0,0,Blue);
  }
//+------------------------------------------------------------------+
double SellOrderOpener()
  {
   buy = false;
   sell = true;
   sellOpenPrice = Bid;
   oppositeOrderEntered = false;
   return OrderSend(_Symbol,OP_SELL,0.01,Bid,0,0,Ask + TP,NULL,0,0,Blue);
  }
//+------------------------------------------------------------------+
double OppositeBuyOrderOpener()
  {
   buy = true;
   sell = false;
   buyOpenPrice = Ask;
   oppositeOrderEntered = true;
   return OrderSend(_Symbol,OP_BUY,0.02,Ask,0,0,0,NULL,0,0,Blue);
  }
//+------------------------------------------------------------------+
double OppositeSellOrderOpener()
  {
   buy = false;
   sell = true;
   sellOpenPrice = Bid;
   oppositeOrderEntered = true;
   return OrderSend(_Symbol,OP_SELL,0.02,Bid,0,0,0,NULL,0,0,Blue);
  }
//+------------------------------------------------------------------+
void CloseOrders()
  {
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);

      string CurrencyPair = OrderSymbol();

      if(_Symbol == CurrencyPair)

         if(OrderType() == OP_SELL)
           {
            OrderClose(OrderTicket(),OrderLots(),Ask,0,Green);
           }
      if(OrderType() == OP_BUY)
        {
         OrderClose(OrderTicket(),OrderLots(),Bid,0,Green);
        }
     }
  }
//+------------------------------------------------------------------+
