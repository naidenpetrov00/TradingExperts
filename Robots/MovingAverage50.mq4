int orderType = 0;

double sellPrice = 0;
double buyPrice = 0;
double highestPrice = 0;
double lowestPrice = 0;

int count =0;
int barsCount = 0;
int minutes = 0;

void OnTick()
{
if(Hour() >= 16)
 //if(MarketInfo(Symbol(), MODE_SPREAD) < 110)
   {
      Comment("Under100 " + MarketInfo(Symbol(), MODE_SPREAD));
  
      double movingAverage50 = iMA (_Symbol,_Period,55,0,MODE_SMA,PRICE_CLOSE,0);
      double movingAverage1 = iMA (_Symbol,_Period,1,0,MODE_SMA,PRICE_CLOSE,0);
      double previousMovingAverage1 = iMA (_Symbol,_Period,1,0,MODE_SMA,PRICE_CLOSE,1);
      double askPrice = MarketInfo(Symbol(), MODE_ASK);
      double bidPrice = MarketInfo(Symbol(), MODE_BID);
      Comment(MarketInfo(Symbol(),MODE_SPREAD));
   
  if(previousMovingAverage1 > movingAverage50 && movingAverage1 < movingAverage50 && OrdersTotal() == 0)
    {
    minutes = Minute();
      Sell(bidPrice);
    }
  if(previousMovingAverage1 < movingAverage50 && movingAverage1 > movingAverage50 && OrdersTotal() == 0)
    {
    minutes = Minute();
      Buy(askPrice);
    }
  if(OrdersTotal() > 0)
    {
     if(OrderType() == OP_BUY)
       {
         BuyPosition(bidPrice);
       }
     if(OrderType()== OP_SELL)
       {
         SellPostion(askPrice);
       }
    }
   }
 else
   {
      Comment("Over110 " + MarketInfo(Symbol(), MODE_SPREAD));
   }
   
}
  
void Buy(double askPrice)
{
   orderType = OrderSend(_Symbol,OP_BUY,0.10,Ask,0,Ask-2,0,NULL,0,0,Blue);
   buyPrice = askPrice;
   highestPrice = askPrice;
}
  
void Sell(double bidPrice)
{
   orderType = OrderSend(_Symbol,OP_SELL,0.10,Bid,0,Bid+2,0,NULL,0,0,Red);
   sellPrice = bidPrice;
   lowestPrice = bidPrice;
}
  
void SellPostion(double askPrice)
{
   if(askPrice >= lowestPrice + 20)
    {
      SellPositionCloser();
    }
   if(askPrice < lowestPrice)
    {
      lowestPrice = askPrice;
    }
      
}
  
void BuyPosition(double bidPrice)
{
   if(bidPrice <= highestPrice - 20)
    {
      BuyPositionCloser();
    }
   if(bidPrice > highestPrice)
    {
      highestPrice = bidPrice;
    }
}
  
void SellPositionCloser()
{
   for(int i=OrdersTotal()-1;i>=0;i--)
    {
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      
      string CurrencyPair = OrderSymbol();
      
      if(_Symbol == CurrencyPair)
      
      if(OrderType() == OP_SELL)
       {
         OrderClose(OrderTicket(),OrderLots(),Ask,0,Green);
       }
    }
}
  
void BuyPositionCloser()
{
   for(int i=OrdersTotal()-1;i>=0;i--)
    {
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      
      string CurrencyPair = OrderSymbol();
      
      if(_Symbol == CurrencyPair)
      
      if(OrderType() == OP_BUY)
       {
         OrderClose(OrderTicket(),OrderLots(),Bid,0,Green);
       }
    }
}