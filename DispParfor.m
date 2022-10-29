function [triggerUpdateFcn] = DispParfor(totalLoops, varargin)
    argParser = inputParser();
    argParser.KeepUnmatched = true;

    addRequired(argParser, "totalLoops", @isscalar);
    parse(argParser, totalLoops, varargin{:});
    
    parellelDataQueue = parallel.pool.DataQueue;
    afterEach(parellelDataQueue, @updateDisp);
    
    triggerUpdateFcn = @updateProxy;

    loopCnt = 0;
    function updateDisp(~)
        loopCnt = loopCnt + 1;
        disp(loopCnt)
    end

    function updateProxy()
        send(parellelDataQueue, []);
    end

end

