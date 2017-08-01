function count=getDiffcount(emMsg,exMsg)
msgLen=min(length(emMsg(:)),length(exMsg(:)));
count = 0;
for j = 1:msgLen
    if exMsg(1,j) ~= emMsg(1,j)
        count = count + 1;
    end
end