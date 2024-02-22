function out = getHeader(obj)
% GETHEADER  Build customized display header text.
%
%   See also GETHEADER
%
%   written ... 2024-02-23 ... UCHINO Yuki

txt = matlab.mixin.CustomDisplay.convertDimensionsToString(obj);
if isgpuarray(obj.v1)
    txt = [txt ' gpuArray'];
end
if issparse(obj.v1)
    if ~any(obj.v1,'all')
        txt = [txt ' All zero'];
    end
    txt = [txt ' sparse'];
end
if isempty(obj.v1)
    txt = [txt ' empty'];
end
txt = [txt ' ' matlab.mixin.CustomDisplay.getClassNameForHeader(obj)];
if isscalar(obj.v1)
    txt = [txt ' scalar'];
elseif isrow(obj.v1)
    txt = [txt ' row vector'];
elseif iscolumn(obj.v1)
    txt = [txt ' column vector'];
elseif ismatrix(obj.v1)
    txt = [txt ' matrix'];
else
    txt = [txt ' array'];
end
out = sprintf('  %s\n',txt);
end