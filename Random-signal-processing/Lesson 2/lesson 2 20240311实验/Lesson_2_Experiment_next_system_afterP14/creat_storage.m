function creat_storage(N_persons)
    for your_id=1:N_persons
        filename=['storage_id',num2str(your_id)];
%         eval([filename,'=your_id']);
        Trade_no = 0;
        save(filename, 'your_id', 'Trade_no');
    end
end