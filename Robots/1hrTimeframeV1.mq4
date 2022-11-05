//+------------------------------------------------------------------+
//|             ProjectName: 1 hour timeframe 50 moving average cross|
//|                                                        Version: 1|
//|                     Status: Problem with getting the currentprice|
//+------------------------------------------------------------------+
double lastPriceAsk = MarketInfo(Symbol(), MODE_ASK);
double lastPriceBid = MarketInfo(Symbol(), MODE_BID);
bool first20 = false;
bool first50 = false;
bool first80 = false;
double highBuyPrice;
double highSellPrice;
double ticket =0;
double buyOpenPrice = 0;
double sellOpenPrice = 0;
double askPrice = 0;
double bidPrice = 0;
double lastMovingAverage1 =  iMA(_Symbol,_Period,1,0,MODE_SMA,PRICE_CLOSE,0);;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   double movingAverage50 = iMA(_Symbol,_Period,50,0,MODE_SMA,PRICE_CLOSE,0);
   double movingAverage1 = iMA(_Symbol,_Period,1,0,MODE_SMA,PRICE_CLOSE,0);
   askPrice = Ask;
   bidPrice = Bid;

   if(OrdersTotal() == 0 && LongCrossChecker(movingAverage1, movingAverage50) == true)
     {
      ResetPriceCheckers();
      buyOpenPrice = askPrice;
      ticket = OrderSend(_Symbol,OP_BUY,0.10,Ask,0,Bid - 30,0,NULL,0,0,Blue);
     }
   if(OrdersTotal() == 0 && ShortCrossChecker(movingAverage1, movingAverage50) == true)
     {
      ResetPriceCheckers();
      sellOpenPrice = bidPrice;
      ticket = OrderSend(_Symbol,OP_SELL,0.10,Bid,0,Ask + 30,0,NULL,0,0,Blue);
     }
   if(OrdersTotal() > 0)
     {
      if(OrderType() == OP_BUY)
      {
         BuyPosition(bidPrice,buyOpenPrice);
      }
      if(OrderType() == OP_SELL)
      {
         SellPosition(askPrice,sellOpenPrice);
      }
     }

   lastPriceAsk = askPrice;
   lastPriceBid = bidPrice;
   lastMovingAverage1 = movingAverage1;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool LongCrossChecker(double movingAverage1, double movingAverage50)
  {
   if(lastMovingAverage1 < movingAverage50 && movingAverage1 >= movingAverage50)
     {
      return true;
     }

   return false;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ShortCrossChecker(double movingAverage1, double movingAverage50)
  {
   if(lastMovingAverage1 > movingAverage50 && movingAverage1 <= movingAverage50)
     {
      return true;
     }

   return false;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SellPositionCloser()
  {
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);

      string CurrencyPair = OrderSymbol();

      if(_Symbol == CurrencyPair)

         if(OrderType() == OP_SELL)
           {
            OrderClose(OrderTicket(),OrderLots(),Ask,0,Red);
           }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BuyPositionCloser()
  {
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);

      string CurrencyPair = OrderSymbol();

      if(_Symbol == CurrencyPair)

         if(OrderType() == OP_BUY)
           {
            OrderClose(OrderTicket(),OrderLots(),Bid,0,Red);
           }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SellPosition(double askPrice, double sellOpenPrice)
  {
   if(first20 == false && sellOpenPrice - askPrice >= 20)
     {
      sellOpenPrice = OrderOpenPrice();
      Print("sell"+sellOpenPrice);
      first20 = true;
      OrderModify(ticket,OrderOpenPrice(),sellOpenPrice - 5,OrderTakeProfit(),0,Yellow);
     }
   if(first50 == false && sellOpenPrice - askPrice>= 50)
     {
      first50 = true;
      OrderModify(ticket,OrderOpenPrice(),sellOpenPrice - 30,OrderTakeProfit(),0,Yellow);
     }
   if(first80 == false && sellOpenPrice - askPrice >= 80)
     {
      first80 = true;
      highSellPrice = 0;
     }
   if(first80 == true)
     {
      if(askPrice < highSellPrice)
        {
         highSellPrice = askPrice;
         OrderModify(ticket,OrderOpenPrice(),highSellPrice - 50,OrderTakeProfit(),0,Yellow);
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BuyPosition(double bidPrice, double buyOpenPrice)
  {
   if(first20 == false && bidPrice - buyOpenPrice >= 20)
     {
      first20 = true;
      Print("buy"+buyOpenPrice);
      OrderModify(ticket,OrderOpenPrice(),buyOpenPrice + 5,OrderTakeProfit(),0,Yellow);
     }
   if(first50 == false && bidPrice - buyOpenPrice >= 50)
     {
      first50 = true;
      OrderModify(ticket,OrderOpenPrice(),buyOpenPrice + 30,OrderTakeProfit(),0,Yellow);
     }
   if(first80 == false && bidPrice - buyOpenPrice >= 80)
     {
      first80 = true;
      highBuyPrice = 0;
     }
   if(first80 == true)
     {
      if(bidPrice > highBuyPrice)
        {
         highBuyPrice = bidPrice;
         OrderModify(ticket,OrderOpenPrice(),highBuyPrice - 50,OrderTakeProfit(),0,Yellow);
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ResetPriceCheckers()
  {
   first20 = false;
   first50 = false;
   first80 = false;
  }
//+------------------------------------------------------------------+
