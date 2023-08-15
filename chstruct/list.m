function list(x);
% LIST -- list the contents of a structure

if isstruct(x),
	n = length(x);
	for i = 1:n;
		disp(x(i))
		fn = fieldnames(x(i));
		for j = 1:length(fn)
			y = getfield(x(i),char(fn(j)));
			if isstruct(y),
				fprintf('\n%s = \n',char(fn(j)));
				list(y)
			end;
		end;
	end;
else
    disp(x);
end;
