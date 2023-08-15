function cl

h =  findobj('type','figure');
n = length(h);

for i=1:n
    close(h(i));
end
