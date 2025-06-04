clear
clc

for your_id=1:40
    filename=['storage_id',num2str(your_id)];
    eval([filename,'=your_id']);
    Trade_no = 0;
    save(filename, 'your_id', 'Trade_no');
end