function out = getFooter(obj)
% GETFOOTER  Build customized display footer text
%
%   written ... 2024-02-23 ... UCHINO Yuki

out = '';
looseflag = strcmp(format().LineSpacing,'loose');
if looseflag
    fprintf('\n');
end
if isempty(obj.v1)
    return;
end

if issparse(obj.v1)
    if any(obj.v1,'all')
        idx = find(obj.v1);
        [x,y,v] = find(obj.v1);
        txtl = "(" + string(x);
        charl = string(strjust(char(txtl)));
        txtr = string(y) + ")";
        charr = string(strjust(char(txtr),'left'));
        vv = formattedDisplayText(v);
        splitv1 = splitlines(vv);
        vv = formattedDisplayText(zeros(length(idx),1) + obj.v2(idx));
        splitv2 = splitlines(vv);
        len = length(charl);
        if len < length(splitv1)-1
            charl = [blanks(strlength(charl(1)));charl];
            charr = [blanks(strlength(charr(1)));charr];
            splitv1 = string(strjust(char(splitv1),'right'));
            if len == length(splitv2)-1
                splitv2 = string(strjust(char(["1.0e+00 *";splitv2]),'right'));
            end
        elseif len < length(splitv2)-1
            charl = [blanks(strlength(charl(1)));charl];
            charr = [blanks(strlength(charr(1)));charr];
            splitv2 = string(strjust(char(splitv2),'right'));
            splitv1 = string(strjust(char(["1.0e+00 *";splitv1]),'right'));
        end
        txt = "   " + charl + "," + charr + " " + splitv1(1:end-1) + "    + " + splitv2(1:end-1);
        txt(1:end-1) = txt(1:end-1) + newline;
        disp(join(txt,''));
        if looseflag
            fprintf('\n');
        end
    end
else
    disp(obj.v1);
    disp('     +');
    if looseflag
        fprintf('\n');
    end
    disp(obj.v2);
end
end