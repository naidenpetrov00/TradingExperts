//+------------------------------------------------------------------+
//|                                              ProfitAveraging.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                          Version: 1 - 15.01.2023 |
//|                                              Status: Development |
//|                           Comment: first order 0.01 opposite 0.03|
//|                                              Made by: Bulochkaaaa|
//+------------------------------------------------------------------+

int TP = 5;
int SL = 5;

int lose = 0;
int win = 0;

double normalLot = 0.01;
double firstOppositeLot = 0.03;
double secondOppositeLot = 0.06;

double buyOpenPrice = 0;
double sellOpenPrice = 0;

bool buy = false;
bool sell = false;
bool normalOrder = false;
bool firstOrder = false;
bool secondOrder = false;
//-------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   if(OrdersTotal() == 0 && buy == false && sell == true)
     {
      SellOrderOpener(normalLot);
      NormalOrder();
     }
   if(OrdersTotal() == 0)
     {
      BuyOrderOpener(normalLot);
      NormalOrder();
     }
   if(normalOrder)
     {
      if(CloseChecker(Ask, buyOpenPrice) && buy == true)
        {
         CloseOrders();
        }
      else
         if(CloseChecker(sellOpenPrice, Bid)&& sell == true)
           {
            CloseOrders();
           }

      if(CloseChecker(buyOpenPrice, Ask)&& buy == true)
        {
         FirstOrder();
        }
      else
         if(CloseChecker(Bid, sellOpenPrice)&& sell == true)
           {
            FirstOrder();
           }
     }
   if(firstOrder)
     {
      if(buy == true && OrdersTotal() == 1)
        {
         SellOrderOpener(firstOppositeLot);
        }
      else
         if(sell == true && OrdersTotal() == 1)
           {
            BuyOrderOpener(firstOppositeLot);
           }

      if(CloseChecker(Ask, buyOpenPrice) && buy == true)
        {
         CloseOrders();
        }
      else
         if(CloseChecker(sellOpenPrice, Bid)&& sell == true)
           {
            CloseOrders();
           }

      if(CloseChecker(buyOpenPrice, Ask)&& buy == true)
        {
         SecondOrder();
        }
      else
         if(CloseChecker(Bid, sellOpenPrice)&& sell == true)
           {
            SecondOrder();
           }
     }
   if(secondOrder)
     {
      if(buy == true && OrdersTotal() == 2)
        {
         SellOrderOpener(secondOppositeLot);
        }
      else
         if(sell == true && OrdersTotal() ==  2)
           {
            BuyOrderOpener(secondOppositeLot);
           }

      if(CloseChecker(Ask, buyOpenPrice) && buy == true)
        {
         CloseOrders();
         win++;
        }
      else
         if(CloseChecker(sellOpenPrice, Bid)&& sell == true)
           {
            CloseOrders();
            win++;
           }

      if(CloseChecker(buyOpenPrice, Ask)&& buy == true)
        {
         CloseOrders();
         lose++;
        }
      else
         if(CloseChecker(Bid, sellOpenPrice)&& sell == true)
           {
            CloseOrders();
            lose++;
           }

      Comment(lose," ",win);
     }


  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double BuyOrderOpener(double lot)
  {
   buy = true;
   sell = false;
   buyOpenPrice = Ask;
   sellOpenPrice = 0;
   return OrderSend(_Symbol,OP_BUY,lot,Ask,0,0,0,NULL,0,0,Blue);
  }
//+------------------------------------------------------------------+
double SellOrderOpener(double lot)
  {
   buy = false;
   sell = true;
   sellOpenPrice = Bid;
   buyOpenPrice = 0;
   return OrderSend(_Symbol,OP_SELL,lot,Bid,0,0,0,NULL,0,0,Blue);
  }
//+------------------------------------------------------------------+

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
void NormalOrder()
  {
   normalOrder = true;
   firstOrder = false;
   secondOrder = false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void FirstOrder()
  {
   normalOrder = false;
   firstOrder = true;
   secondOrder = false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SecondOrder()
  {
   normalOrder = false;
   firstOrder = false;
   secondOrder = true;
  }
//+------------------------------------------------------------------+
bool CloseChecker(double firstPrice, double secondPrice)
  {
   if(firstPrice - secondPrice >= TP)
     {
      return true;
     }
   else
     {
      return false;
     }
  }
//+------------------------------------------------------------------+
