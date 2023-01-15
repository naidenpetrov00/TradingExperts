//+------------------------------------------------------------------+
//|                                                         Test.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

bool buy = true;
bool sell = false;
bool sell = false;

double TP = 5;
double SL = 5;

int lostCount = 0;

double buyOpen = 0;
double sellOpen = 0;




//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   //if(OrdersTotal() == 0 && lostCount == 2)
   //  {
   //   int rsi=iRSI(_Symbol,Period(),14,PRICE_CLOSE,0);
   //   if(rsi >= 60)
   //     {
   //      BuyOrderOpener();
   //     }
   //   if(rsi <= 40)
   //     {
   //      SellOrderOpener();
   //     }
   //  }
   if(OrdersTotal() == 0)
     {
      if(buy == true && sell == false)
        {
         BuyOrderOpener();
        }
      if(buy == false && sell == true)
        {
         SellOrderOpener();
        }
     }
   if(buy == true && sell == false && OrdersTotal() > 0)
     {
      if(buyOpen - Ask >= SL)
        {
         buy = false;
         sell = true;
         lostCount++;
         CloseOrders();
        }
      if(Ask - buyOpen >= TP)
        {

         buy = true;
         sell = false;
         lostCount = 0;
         CloseOrders();

        }
     }
   if(sell == true && buy == false && OrdersTotal() > 0)
     {
      if(sellOpen - Bid >= TP)
        {
         buy = false;
         sell = true;
         lostCount = 0;
         CloseOrders();
        }
      if(Bid - sellOpen >= SL)
        {
         buy = true;
         sell = false;
         lostCount++;
         CloseOrders();
        }
     }

  }
//+------------------------------------------------------------------+
double BuyOrderOpener()
  {
   buy = true;
   sell = false;
   buyOpen = Ask;
   return OrderSend(_Symbol,OP_BUY,0.01,Ask,0,0,0,NULL,0,0,Blue);
  }
//+------------------------------------------------------------------+
double SellOrderOpener()
  {
   buy = false;
   sell = true;
   sellOpen = Bid;
   return OrderSend(_Symbol,OP_SELL,0.01,Bid,0,0,0,NULL,0,0,Red);
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

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
