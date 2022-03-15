function figCloseReq(src,event)
    global closeWindowCheck;
    closeWindowCheck = true;
    delete(src);
end