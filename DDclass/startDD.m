function startDD
% STARTDD   set path and compile mexcuda
%
%   Adapt this to your local needs.
%
%   See also DD, DD.INFO
%
%   written ... 2024-02-23 ... UCHINO Yuki
%   revised ... 2024-03-08 ... UCHINO Yuki

err = false;
disp(' ')
disp('Trying to add the DDclass path to the MATLAB search path.')
try
    DDPATH = which('startDD');
    DDPATH = DDPATH(1:end-10);
    addpath(DDPATH);
catch
    disp('... Failed.')
    err = true;
end
if ~err
    disp('... Succeeded.')
end

disp(' ')
disp('Checking the environment.')
try
    checkRelease = isMATLABReleaseOlderThan("R2021b");
catch
    disp('... MATLAB R2021b or later is required.');
    return
end
if checkRelease
    disp('... MATLAB R2021b or later is required.');
    return
end
checkVer = ver;
checkFPD = any(matches({checkVer.Name},'Fixed-Point Designer'));
if ~checkFPD
    disp('... "Fixed-Point Designer" toolbox is required.');
    return
end
checkPCT = any(matches({checkVer.Name},'Parallel Computing Toolbox'));
if ~checkPCT
    disp('... "Parallel Computing Toolbox" toolbox is not installed.');
    disp('... gpuArray cannot be used.')
else
    disp('... No problems.');
end

if checkPCT
    disp(' ')
    disp('Checking GPU devices.')
    CheckGPU = gpuDeviceCount("available");
    if CheckGPU>0
        disp('... Found supported GPU devices.')
        while 1
            x = input('... (Re-)Compile cu files? [y/n]','s');
            if strcmpi(x,'y') || strcmpi(x,'n')
                break;
            end
        end
        if strcmpi(x,'y')
            p2 = CompileMEXCUDA;
            if p2
                disp('... mexcuda succeeded.');
            else
                disp('... mexcuda failed.');
            end
        end
    else
        disp('... Unable to find a supported GPU device.');
    end
end

disp(' ')
disp('Testing DD arithmetic.')
try
    startDDtestA = randn(3,3,'DD');
    startDDtestB = randn(3,3,'DD');
    startDDtestC = startDDtestA * startDDtestB;
    startDDtestB = startDDtestC + startDDtestB;
    startDDtestA = startDDtestA - startDDtestB;
    startDDtestC = startDDtestA \ startDDtestB;
    clear startDDtestA startDDtestB startDDtestC
catch
    disp('... Failed.');
end
disp('... Succeeded.');

disp(' ')
disp('You can also permanently save the search path.')
disp('(Run "pathtool" command and click "save")')
disp(' ')
end