//+------------------------------------------------------------------+
//|             ProjectName: 1 hour timeframe 50 moving average cross|
//|                                                        Version: 2|
//|                                                Status: Developing|
//+------------------------------------------------------------------+
double lastAskPrice = Ask;
double lastBidPrice = Bid;
double lastMovingAverage1=iMA(_Symbol,_Period,1,0,MODE_SMA,PRICE_CLOSE,0);
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   double movingAverage50 = iMA(_Symbol,_Period,50,0,MODE_SMA,PRICE_CLOSE,0);
   double movingAverage1 = iMA(_Symbol,_Period,1,0,MODE_SMA,PRICE_CLOSE,0);
   double askPrice = Ask;
   double bidPrice = Bid;

   if(ShortCrossChecker(movingAverage1,movingAverage50)== true)
     {
      Print("short");
     }
   if(LongCrossChecker(askPrice, movingAverage50) == true)
     {
      Print("long");
     }

   lastAskPrice = askPrice;
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
