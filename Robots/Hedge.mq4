//+------------------------------------------------------------------+
//|                                                        Hedge.mq4 |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

bool buyPosition = true;
bool sellPosition = false;

//1/1
double firstOrderLot = 0.01;
double secondOppOrderLot = 0.02;
double thirdOppOrderLot = 0.04;
double fourthOppOrderLot = 0.08;
double fifthOppOrderLot = 0.16;
double sixOppOrderLot = 0.32;
double sevenOppOrderLot = 0.64;

//1/2
//double secondOppOrderLot = 0.04;
//double thirdOppOrderLot = 0.08;
//double fourthOppOrderLot = 0.16;
//double fifthOppOrderLot = 0.32;
//double sixOppOrderLot = 0.64;
//double sevenOppOrderLot = 0.128;

//1/3
//double secondOppOrderLot = 0.06;
//double thirdOppOrderLot = 0.12;
//double fourthOppOrderLot = 0.24;
//double fifthOppOrderLot = 0.48;
//double sixOppOrderLot = 0.96;
//double sevenOppOrderLot = 0.192;

int orderNumber = 0;

int buyOpenPrice = 0;
int sellOpenPrice = 0;

int TPForNormal = 5;
int oppositeOrderOpenRange = 5;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(OrdersTotal() == 0)
     {
      orderNumber = 0;
      OpenOrder(firstOrderLot);
     }
   else
     {
      switch(orderNumber)
        {
         case 1:
            FirstOrderHandler();
            break;
         case 2:
            SecondOrderHandler();
            break;
         //case 3:
         //   ThirdOrderHandler();
         //   break;
         //case 4:
         //   FourthOrderHandler();
         //   break;
         //case 5:
         //   FifthOrderHandler();
         //case 6:
         //   SixthOrderHandler();
         //   break;
         //case 7:
         //   SeventhOrderHandler();
         //   break;
            break;
         default:
            break;
        }

     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckOrder(double lot)
  {
   if(buyPosition == true && sellPosition == false)
     {
      if(Ask - buyOpenPrice >= TPForNormal)
        {
         CloseOrders();
        }
      else
         if(buyOpenPrice - Ask >= oppositeOrderOpenRange)
           {
            SellPositionOpener(lot);
           }
     }
   else
      if(sellPosition == true && buyPosition == false)
        {
         if(sellOpenPrice - Bid >= TPForNormal)
           {
            CloseOrders();
           }
         else
            if(Bid - sellOpenPrice >= oppositeOrderOpenRange)
              {
               BuyPositionOpener(lot);
              }
        }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void FirstOrderHandler()
  {
   CheckOrder(secondOppOrderLot);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SecondOrderHandler()
  {
   if(buyPosition == true && sellPosition == false)
     {
      if(Ask - buyOpenPrice >= TPForNormal)
        {
         CloseOrders();
        }
      else
         if(buyOpenPrice - Ask >= oppositeOrderOpenRange)
           {
            CloseOrders();
           }
     }
   else
      if(sellPosition == true && buyPosition == false)
        {
         if(sellOpenPrice - Bid >= TPForNormal)
           {
            CloseOrders();
           }
         else
            if(Bid - sellOpenPrice >= oppositeOrderOpenRange)
              {
               CloseOrders();
              }
        }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ThirdOrderHandler()
  {
   CheckOrder(fourthOppOrderLot);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void FourthOrderHandler()
  {
   CheckOrder(fifthOppOrderLot);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void FifthOrderHandler()
  {
   CheckOrder(sixOppOrderLot);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SixthOrderHandler()
  {
   CheckOrder(sevenOppOrderLot);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SeventhOrderHandler()
  {
   if(buyPosition == true && sellPosition == false)
     {
      if(Ask - buyOpenPrice >= TPForNormal)
        {
         CloseOrders();
        }
      else
         if(buyOpenPrice - Ask >= oppositeOrderOpenRange)
           {
            CloseOrders();
           }
     }
   else
      if(sellPosition == true && buyPosition == false)
        {
         if(sellOpenPrice - Bid >= TPForNormal)
           {
            CloseOrders();
           }
         else
            if(Bid - sellOpenPrice >= oppositeOrderOpenRange)
              {
               CloseOrders();
              }
        }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OpenOrder(double lot)
  {
   if(buyPosition == true && sellPosition == false)
     {
      BuyPositionOpener(lot);
     }
   else
      if(sellPosition == true && buyPosition == false)
        {
         SellPositionOpener(lot);
        }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double BuyPositionOpener(double lot)
  {
   buyPosition = true;
   sellPosition = false;
   orderNumber++;
   buyOpenPrice = Ask;

   return OrderSend(_Symbol,OP_BUY,lot,Ask,0,0,0,NULL,0,0,Blue);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double SellPositionOpener(double lot)
  {
   buyPosition = false;
   sellPosition = true;
   orderNumber++;
   sellOpenPrice = Bid;

   return OrderSend(_Symbol,OP_SELL,lot,Bid,0,0,0,NULL,0,0,Blue);
  }
//+------------------------------------------------------------------+
//|                                                                  |
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
