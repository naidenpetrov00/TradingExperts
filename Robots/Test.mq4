void OnTick()
       {
        OrderSend(_Symbol,OP_BUY,0.01,Ask,0,Bid,Bid + 1,NULL,0,0,Blue);
       }