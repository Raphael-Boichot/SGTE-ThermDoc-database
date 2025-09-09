function str = getAsciiRepresentation(byte, map)
    if byte >= 32 && byte <= 126
        str = char(byte);
    elseif isKey(map, byte)
        str = map(byte);
    else
        str = '[NP]';
    end
end
