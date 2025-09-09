%% compare_files_with_packets_fast.m
clc;
clear;

% --- User input: specify file paths ---
file1 = 'ThermDoc23a.bib';
file2 = 'ThermDoc23b.bib';

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
for k = 0:31
    names = {'[NUL]','[SOH]','[STX]','[ETX]','[EOT]','[ENQ]','[ACK]','[BEL]',...
             '[BS]','[TAB]','[LF]','[VT]','[FF]','[CR]','[SO]','[SI]',...
             '[DLE]','[DC1]','[DC2]','[DC3]','[DC4]','[NAK]','[SYN]','[ETB]',...
             '[CAN]','[EM]','[SUB]','[ESC]','[FS]','[GS]','[RS]','[US]'};
    nonPrintableMap(k) = names{k+1};
end
nonPrintableMap(127) = '[DEL]';

% --- Fixed column widths (6 each) ---
colWidth = 6;

% --- Prepare data for comparison ---
len1 = length(data1);
len2 = length(data2);
maxLength = max(len1, len2);

% Pad shorter array with zeros
data1Padded = [data1(:); zeros(maxLength - len1, 1)];
data2Padded = [data2(:); zeros(maxLength - len2, 1)];

% Find all differences
diffIndices = find(data1Padded ~= data2Padded);
totalDiffs = length(diffIndices);

if totalDiffs == 0
    if len1 ~= len2
        fprintf('No byte differences in common length, but files differ in size.\n');
    else
        fprintf('Files are identical.\n');
    end
    return;
end

% --- Navigation state ---
currentIdx = 1;
context = 10;  % bytes before/after difference

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
    ascii1Col = cell(rows,1); ascii2Col = cell(rows,1);
    dec1Col = cell(rows,1); dec2Col = cell(rows,1);
    hex1Col = cell(rows,1); hex2Col = cell(rows,1);
    statusCol = cell(rows,1);

    for i = 1:rows
        % --- ASCII ---
        a1 = padLeft(getAsciiRepresentation(seg1(i), nonPrintableMap), colWidth);
        a2 = padLeft(getAsciiRepresentation(seg2(i), nonPrintableMap), colWidth);

        % --- Decimal ---
        d1 = padLeft(sprintf('%d', seg1(i)), colWidth);
        d2 = padLeft(sprintf('%d', seg2(i)), colWidth);

        % --- Hex ---
        h1 = padLeft(sprintf('%02X', seg1(i)), colWidth);
        h2 = padLeft(sprintf('%02X', seg2(i)), colWidth);

        % --- Status ---
        if seg1(i) == seg2(i)
            statusCol{i} = 'same ';
        else
            statusCol{i} = 'diff ';
        end

        % --- Highlight current diff ---
        if i == diffPos
            if isempty(strtrim(a1)), a1 = '< >'; else, a1 = ['<' strtrim(a1) '>']; end
            if isempty(strtrim(a2)), a2 = '< >'; else, a2 = ['<' strtrim(a2) '>']; end
            d1 = ['<' strtrim(d1) '>']; d2 = ['<' strtrim(d2) '>'];
            h1 = ['<' strtrim(h1) '>']; h2 = ['<' strtrim(h2) '>'];
        end

        % --- Store ---
        ascii1Col{i} = a1; ascii2Col{i} = a2;
        dec1Col{i} = d1; dec2Col{i} = d2;
        hex1Col{i} = h1; hex2Col{i} = h2;
    end

    % --- Display ---
    clc;
    fprintf('Difference %d/%d at byte %d\n\n', currentIdx, totalDiffs, k);
    fprintf('%-6s %-6s %-6s %-6s %-6s %-6s %-6s\n', ...
        'ASCII1','ASCII2','DEC1','DEC2','HEX1','HEX2','Status');
    for i = 1:rows
        fprintf('%-6s %-6s %-6s %-6s %-6s %-6s %-6s\n', ...
            ascii1Col{i}, ascii2Col{i}, dec1Col{i}, dec2Col{i}, ...
            hex1Col{i}, hex2Col{i}, statusCol{i});
    end

    % --- Navigation commands ---
    fprintf(['\nCommands: n=next, p=previous, f=first, l=last, e=exit\n' ...
             '          d=next diff packet (Enter=next)\n']);
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
        currentIdx = 1;

    elseif strcmpi(cmd,'l')
        currentIdx = totalDiffs;

    elseif strcmpi(cmd,'d')  % jump to next diff packet
        % skip current contiguous diff run
        while currentIdx < totalDiffs && ...
              diffIndices(currentIdx+1) == diffIndices(currentIdx)+1
            currentIdx = currentIdx + 1;
        end
        % move to first byte of next diff packet
        if currentIdx < totalDiffs
            currentIdx = currentIdx + 1;
        else
            disp('Already at last diff packet.'); pause(0.5);
        end

    elseif strcmpi(cmd,'e')
        break;
    end
end

fprintf('\nComparison finished. Total differences: %d\n', totalDiffs);

