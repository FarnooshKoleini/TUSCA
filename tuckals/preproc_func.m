
function [a]=preproc_func(as,preproc,I,J,K)

% Perform scaling options (Preprocessing)
if preproc == 1      % No scaling
    a=as;
elseif preproc == 2	% global col centering
    a=meancorr(as);
elseif preproc == 3	% global row centering
    a=uf_col(as,I,J,K);
    a=meancorr(a')';
    a=f_col(a,I,J,K);
elseif preproc == 4	% center cols within layers
    for i=1:K
        a((i-1)*I+1:i*I,:)=meancorr(as((i-1)*I+1:i*I,:));
    end
elseif preproc == 5	% center rows within layers
    a=meancorr(as')';
elseif preproc == 6	% global scale
    a=autoscal(as);
elseif preproc == 7	% global row scaling
    a=uf_col(as,I,J,K);
    a=autoscal(a')';
    a=f_col(a,I,J,K);
elseif preproc == 8	% scale cols within layers
    for i=1:K
        a((i-1)*I+1:i*I,:)=autoscal(as((i-1)*I+1:i*I,:));
    end
elseif preproc == 9	% scale rows within layers
    a=autoscal(as')';
end
    end