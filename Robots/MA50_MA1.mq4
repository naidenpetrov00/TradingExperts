int barTime = Hour();
double lastPriceAsk = MarketInfo(Symbol(), MODE_ASK);
double lastPriceBid = MarketInfo(Symbol(), MODE_BID);

void OnTick()
{
   //if(Hour() >= 16 && Hour() <= 23)
 //if(MarketInfo(Symbol(), MODE_SPREAD) < 110)
   //{
      double priceAsk = MarketInfo(Symbol(), MODE_ASK);
      double priceBid = MarketInfo(Symbol(), MODE_BID);
      double movingAverage50 = iMA (_Symbol,_Period,70,0,MODE_SMA,PRICE_CLOSE,0);
      double movingAverage1 = iMA (_Symbol,_Period,1,0,MODE_SMA,PRICE_CLOSE,0);
      double previousMovingAverage1 = iMA (_Symbol,_Period,1,0,MODE_SMA,PRICE_CLOSE,1);
      double askPrice = MarketInfo(Symbol(), MODE_ASK);
      double bidPrice = MarketInfo(Symbol(), MODE_BID);
      if(OrdersTotal() == 0 && BuyCrossChecker(lastPriceAsk, priceAsk, movingAverage50) == true)
      {
         barTime = Hour();
         OrderSend(_Symbol,OP_BUY,0.10,Ask,0,0,0,NULL,0,0,Blue);
      }
      if(OrdersTotal() == 0 && SellCrossChecker(lastPriceBid, priceBid, movingAverage50) == true)
      {
         barTime = Hour();
         OrderSend(_Symbol,OP_SELL,0.10,Bid,0,0,0,NULL,0,0,Red);
      }
      if(OrdersTotal() > 0 && BarClosed() == true)
      {
         BuyPositionCloser();
         SellPositionCloser();
      }
      
      lastPriceAsk = priceAsk;
       lastPriceBid = priceBid;
  // }
}

bool BarClosed()
{
   if(barTime != Hour())
   {
      return true;
   }
   
   return false;
}

bool BuyCrossChecker(double lastPriceAsk, double priceAsk, double movingAverage50)
{
   if(lastPriceAsk < movingAverage50 && priceAsk > movingAverage50)
   {
      return true;
   }
   
   return false;
}

bool SellCrossChecker(double lastPriceBid, double priceBid, double movingAverage50)
{
   if(lastPriceBid > movingAverage50 && priceBid < movingAverage50)
   {
      return true;
   }
   
   return false;
}


