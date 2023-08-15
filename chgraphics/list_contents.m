function list_contents(dirname);
% LIST_CONTENTS -- lists the H1 comment line of all functions in dir
%
% dirname is optional.  Default = current working directory.
%
% list_contents(dirname);
if nargin < 1,
	fname = dir;
else
	fname = dir(dirname);
end;

for i = 1:length(fname);
	if fname(i).isdir ~= 1,
		fid=fopen(fname(i).name);
		line1 = fgetl(fid);
		line2 = fgetl(fid);
		if isempty(line2),
			fprintf(1,'%s -- No H1 line for this file.\n',fname(i).name);
		else
			fprintf(1,'%s\n',line2);
		end;
		fclose(fid);	
	end;
end;
