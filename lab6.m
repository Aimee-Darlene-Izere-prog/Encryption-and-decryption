function lab6
    [s,m,m1,m2] = encrypt('This is my message.');
    decrypt(s,m,m1,m2)
end
 
function [m,m1,m2] = encrypt_keygen(n)
    m1 = eye(n);
    m2 = eye(n);

    for row = 1:n-1
        m2(row, row+1:end)= randi([0,100],1,n-row);
    end 

    for row = 2:n
        m1(row, 1:row-1) = randi([0,100],1,row-1);

    end 
    m = m1*m2 ;
end 

function A_inv = my_inv(A)
    
    if size(A,1) ~= size(A,2)
        error('A must be a square matrix')
    else
        K = rref([A eye(size(A,1))]);

        if isequal(K(:,1:size(A,1)), eye(size(A,1)))

            A_inv = K(:,(size(A,1))+1:end);
        else
            error('A is not invertible')
        end 
    end 

end 

function [E1, m, m1,m2] = encrypt(E)

    [m, m1,m2] = encrypt_keygen(3);

    % % changing the code to corresponding ASCII numbers
    encMsg = double(E);

    % % % check if the matrix has the appropriate size
    numSpaces = size(m,1)- mod(length(E), size(m,1));

    if numSpaces >0
        encMsg = [encMsg 32* ones(1,numSpaces)];
    end 

    cols = length(encMsg)/size(m,1);

    K = reshape(encMsg, size(m,2),cols);

    % %% The encoded message 

    newMatr = mod(m*(K-32),95) + 32;
    E1 = reshape(char(newMatr),1,size(K,1)*size(K,2));
end 


function E = decrypt(E1,m,m1, m2)

    % % transforming the encoded message into corresponding ASCII numbers
    decry_code = double(E1);
    cols = length(decry_code)/size(m,1);

    K_res = reshape(decry_code, size(m,1), cols);

    m1_inv = my_inv(m1);
    m2_inv = my_inv(m2);
    m_inv = m2_inv * m1_inv;
    newMatr_res = mod(m_inv * (K_res - 32),95) + 32 ; 
    res_cols = size(K_res,1)*size(K_res,2);
    E = strtrim(char(reshape(newMatr_res, 1, res_cols)));

end 
