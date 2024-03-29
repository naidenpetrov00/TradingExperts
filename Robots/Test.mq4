//+------------------------------------------------------------------+
//|                                              ProfitAveraging.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                          Version: 1 - 15.01.2023 |
//|                                              Status: Development |
//|                           Comment: first order 0.01 opposite 0.03|
//+------------------------------------------------------------------+

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
bool buy =false;
bool sell = false;

double TP = 0.2;
double SL = 0.2;

double buyPrice = 0;
double sellPrice = 0;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {

   if(OrdersTotal() == 0)
     {
      double firstPrevOpen = iOpen(Symbol(), 0,1);
      double firstPrevClose = iClose(Symbol(), 0,1);

      double secondPrevOpen = iOpen(Symbol(), 0,2);
      double secondPrevClose = iClose(Symbol(), 0,2);

      if(firstPrevOpen > firstPrevClose && secondPrevOpen > secondPrevClose)
        {
         SellOrderOpener();
        }
     }

   if(OrdersTotal() > 0 && sell == true)
     {
      if(sellPrice - Bid == TP)
        {
         CloseOrders();
        }

      if(Bid - sellPrice == SL)
        {
         CloseOrders();
        }
     }

  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double BuyOrderOpener()
  {
   buyPrice = Ask;
   return OrderSend(_Symbol,OP_BUY,0.01,Ask,0,0,Ask + 1,NULL,0,0,Blue);
  }
//+------------------------------------------------------------------+
double SellOrderOpener()
  {
   sellPrice = Bid;
   buy = false;
   sell = true;
   return OrderSend(_Symbol,OP_SELL,0.01,Bid,0,0,0,NULL,0,0,Blue);
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
