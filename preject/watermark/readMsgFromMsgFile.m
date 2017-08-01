% -------------------------------------------------------------------------
% 此函数的作用:从指定的保存水印信息的文件中读取水印
% 版本:v1.0
% 编辑时间:2016-05-24
% 作者:WangMian
% 传入参数:msgPath:保存水印文件的文件路径 msgName:水印文件的名称
%          msgLen:欲要从水印文件中读取的水印的长度
% 返回参数:msg:从水印文件中读取的长度为msgLen的水印
% -------------------------------------------------------------------------
function [msg] = readMsgFromMsgFile(msgPath,msgName,msgLen)
fprintf(1,'检测水印文件 %s 是否存在...\r',strcat(msgPath,msgName));
if ~exist(strcat(msgPath,msgName)) %#ok<EXIST>
   fprintf(1,'水印文件不存在或给定的水印文件路径错误,程序终止!\r');
   return ;
else
    fprintf(1,'水印文件 %s 存在，开始读取水印信息...\r',strcat(msgPath,msgName));
    msg = load(strcat(msgPath,msgName));
    if numel(msg) < msgLen
        fprintf(1,'从已有的水印文件 %s 中读取的水印信息的长度小于给定的长度!程序终止!\r',strcat(msgPath,msgName));
        return ;
    else
        msg = reshape(msg,1,numel(msg));
        msg = msg(1:msgLen);
    end
end
fprintf(1,'水印数据读取完成...\r');
