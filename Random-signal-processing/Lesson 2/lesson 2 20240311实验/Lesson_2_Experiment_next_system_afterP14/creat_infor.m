function creat_infor(N_persons)
    for counterparty_id=1:N_persons
        filename=['infor_id',num2str(counterparty_id)];
%         eval([filename,'=your_id']);
        counterparty_action = 0;
        save(filename, 'counterparty_id', 'counterparty_action');
    end
end