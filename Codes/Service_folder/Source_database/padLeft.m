function padded = padLeft(str, width)
    len = length(str);
    if len >= width
        padded = str;
    else
        padded = [str repmat(' ',1,width-len)];
    end
end
