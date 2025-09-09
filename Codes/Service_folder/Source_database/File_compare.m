%% compare_files_six_columns_final_f_l.m
clc;
clear;

% --- User input: specify file paths ---
file1 = 'ThermDoc25a.bib';
file2 = 'ThermDoc24b.bib';

% --- Read files as bytes ---
fid1 = fopen(file1, 'rb');
fid2 = fopen(file2, 'rb');
if fid1 == -1 || fid2 == -1
    error('Error opening one or both files.');
end

data1 = fread(fid1, Inf, 'uint8');
data2 = fread(fid2, Inf, 'uint8');
fclose(fid1);
fclose(fid2);

% --- ASCII mapping for non-printable characters ---
nonPrintableMap = containers.Map('KeyType','double','ValueType','char');
nonPrintableMap(0)  = '[NUL]';  nonPrintableMap(1)  = '[SOH]';  nonPrintableMap(2)  = '[STX]';
nonPrintableMap(3)  = '[ETX]';  nonPrintableMap(4)  = '[EOT]';  nonPrintableMap(5)  = '[ENQ]';
nonPrintableMap(6)  = '[ACK]';  nonPrintableMap(7)  = '[BEL]';  nonPrintableMap(8)  = '[BS]';
nonPrintableMap(9)  = '[TAB]';  nonPrintableMap(10) = '[LF]';   nonPrintableMap(11) = '[VT]';
nonPrintableMap(12) = '[FF]';   nonPrintableMap(13) = '[CR]';   nonPrintableMap(14) = '[SO]';
nonPrintableMap(15) = '[SI]';   nonPrintableMap(16) = '[DLE]';  nonPrintableMap(17) = '[DC1]';
nonPrintableMap(18) = '[DC2]';  nonPrintableMap(19) = '[DC3]';  nonPrintableMap(20) = '[DC4]';
nonPrintableMap(21) = '[NAK]';  nonPrintableMap(22) = '[SYN]';  nonPrintableMap(23) = '[ETB]';
nonPrintableMap(24) = '[CAN]';  nonPrintableMap(25) = '[EM]';   nonPrintableMap(26) = '[SUB]';
nonPrintableMap(27) = '[ESC]';  nonPrintableMap(28) = '[FS]';   nonPrintableMap(29) = '[GS]';
nonPrintableMap(30) = '[RS]';   nonPrintableMap(31) = '[US]';   nonPrintableMap(127)= '[DEL]';

% --- Fixed column widths ---
asciiWidth = 10;
hexWidth   = 6;
decWidth   = 6;

% --- Find all differences ---
len1 = length(data1);
len2 = length(data2);
maxLength = max(len1, len2);
diffIndices = [];
for k = 1:maxLength
    b1 = 0; b2 = 0;
    if k <= len1, b1 = data1(k); end
    if k <= len2, b2 = data2(k); end
    if b1 ~= b2
        diffIndices(end+1) = k;
    end
end
totalDiffs = length(diffIndices);

if totalDiffs == 0
    if len1 ~= len2
        fprintf('No byte differences in common length, but files differ in size.\n');
    else
        fprintf('Files are identical.\n');
    end
    return;
end

% --- Navigation through differences ---
currentIdx = 1;
context = 10; % bytes before/after difference
while true
    k = diffIndices(currentIdx);
    startIdx = max(1, k-context);
    endIdx = min(maxLength, k+context);

    seg1 = zeros(1,endIdx-startIdx+1,'uint8');
    seg2 = zeros(1,endIdx-startIdx+1,'uint8');
    for i = 1:length(seg1)
        idxSeg = startIdx + i - 1;
        if idxSeg <= len1, seg1(i) = data1(idxSeg); end
        if idxSeg <= len2, seg2(i) = data2(idxSeg); end
    end
    diffPos = k - startIdx + 1;
    rows = length(seg1);

    % --- Prepare columns ---
    ascii1Col = cell(rows,1); hex1Col = cell(rows,1); dec1Col = cell(rows,1);
    ascii2Col = cell(rows,1); hex2Col = cell(rows,1); dec2Col = cell(rows,1);
    for i = 1:rows
        % File1
        a1 = padLeft(getAsciiRepresentation(seg1(i), nonPrintableMap), asciiWidth);
        h1 = padLeft(sprintf('%02X', seg1(i)), hexWidth);
        d1 = padLeft(sprintf('%3d', seg1(i)), decWidth);
        % File2
        a2 = padLeft(getAsciiRepresentation(seg2(i), nonPrintableMap), asciiWidth);
        h2 = padLeft(sprintf('%02X', seg2(i)), hexWidth);
        d2 = padLeft(sprintf('%3d', seg2(i)), decWidth);

        % Highlight difference with < >, including spaces
        if i == diffPos
            if isempty(strtrim(a1)), a1 = '< >'; else, a1 = ['<' strtrim(a1) '>']; end
            if isempty(strtrim(a2)), a2 = '< >'; else, a2 = ['<' strtrim(a2) '>']; end
            h1 = ['<' strtrim(h1) '>']; d1 = ['<' strtrim(d1) '>'];
            h2 = ['<' strtrim(h2) '>']; d2 = ['<' strtrim(d2) '>'];
        end

        ascii1Col{i} = a1; hex1Col{i} = h1; dec1Col{i} = d1;
        ascii2Col{i} = a2; hex2Col{i} = h2; dec2Col{i} = d2;
    end

    % --- Display ---
    clc;
    fprintf('Difference %d/%d at byte %d\n\n', currentIdx, totalDiffs, k);
    fprintf('File1 ASCII HEX DEC   File2 ASCII HEX DEC\n');
    for i = 1:rows
        fprintf('%-10s %-6s %-6s   %-10s %-6s %-6s\n', ...
            ascii1Col{i}, hex1Col{i}, dec1Col{i}, ...
            ascii2Col{i}, hex2Col{i}, dec2Col{i});
    end

    % --- Navigation reminder ---
    fprintf('\nCommands: n=next, p=previous, f=first, l=last, e=exit (Enter = next)\n');
    cmd = input('Enter command: ','s');

    if strcmpi(cmd,'n') || isempty(cmd)
        if currentIdx < totalDiffs
            currentIdx = currentIdx + 1;
        else
            disp('Already at last difference.'); pause(0.5);
        end
    elseif strcmpi(cmd,'p')
        if currentIdx > 1
            currentIdx = currentIdx - 1;
        else
            disp('Already at first difference.'); pause(0.5);
        end
    elseif strcmpi(cmd,'f')
        currentIdx = 1;  % jump to first difference
    elseif strcmpi(cmd,'l')
        currentIdx = totalDiffs;  % jump to last difference
    elseif strcmpi(cmd,'e')
        break;
    end
end

fprintf('\nComparison finished. Total differences: %d\n', totalDiffs);

%% --- Helper functions ---
function str = getAsciiRepresentation(byte, map)
    if byte >= 32 && byte <= 126
        str = char(byte);
    elseif isKey(map, byte)
        str = map(byte);
    else
        str = '[NP]';
    end
end

function padded = padLeft(str, width)
    len = length(str);
    if len >= width
        padded = str;
    else
        padded = [str repmat(' ',1,width-len)];
    end
end
